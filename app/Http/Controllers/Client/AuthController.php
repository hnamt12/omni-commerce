<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    /** Default banner image if none set in Settings */
    private const DEFAULT_AUTH_BANNER =
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2070&auto=format&fit=crop';

    // ─────────────────────────────────────────────
    //  Pages
    // ─────────────────────────────────────────────

    public function showLogin(): Response
    {
        try {
            $banner = Setting::get('client_auth_banner', self::DEFAULT_AUTH_BANNER);
        } catch (\Exception $e) {
            $banner = self::DEFAULT_AUTH_BANNER;
        }

        return Inertia::render('Client/Auth/Login', ['authBanner' => $banner]);
    }

    public function showRegisterForm(): Response
    {
        try {
            $banner = Setting::get('client_auth_banner', self::DEFAULT_AUTH_BANNER);
        } catch (\Exception $e) {
            $banner = self::DEFAULT_AUTH_BANNER;
        }

        return Inertia::render('Client/Auth/Register', ['authBanner' => $banner]);
    }

    // ─────────────────────────────────────────────
    //  Standard Auth
    // ─────────────────────────────────────────────

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ], [
            'email.required' => 'Vui lòng nhập địa chỉ email.',
            'email.email' => 'Định dạng email không hợp lệ.',
            'password.required' => 'Vui lòng nhập mật khẩu.',
        ]);

        if (Auth::guard('customer')->attempt($credentials, $request->boolean('remember'))) {
            $request->session()->regenerate();
            $redirectUrl = $request->query('intended', route('client.home'));

            return redirect()->to($redirectUrl)->with('success', 'Đăng nhập thành công!');
        }

        throw ValidationException::withMessages([
            'email' => 'Email hoặc mật khẩu không đúng.',
        ]);
    }

    public function logout(Request $request)
    {
        Auth::guard('customer')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/');
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:customers',
            'password' => 'required|string|min:6|confirmed',
        ], [
            'name.required' => 'Vui lòng nhập họ và tên.',
            'email.required' => 'Vui lòng nhập địa chỉ email.',
            'email.email' => 'Định dạng email không hợp lệ.',
            'email.unique' => 'Email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng email khác.',
            'password.required' => 'Vui lòng nhập mật khẩu.',
            'password.confirmed' => 'Mật khẩu nhập lại không khớp.',
            'password.min' => 'Mật khẩu phải có ít nhất 6 ký tự.',
        ]);

        $customer = Customer::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'is_active' => true,
        ]);

        Auth::guard('customer')->login($customer);
        $request->session()->regenerate();

        return redirect()->route('client.home')
            ->with('success', 'Đăng ký thành công! Chào mừng bạn đến với OmniCommerce. 🎉');
    }

    // ─────────────────────────────────────────────
    //  Socialite (OAuth2)
    // ─────────────────────────────────────────────

    /**
     * Redirect user to OAuth provider.
     */
    public function redirectToProvider(string $provider)
    {
        return Socialite::driver($provider)->redirect();
    }

    /**
     * Handle OAuth callback: auto-register if not exists, then login.
     */
    public function handleProviderCallback(string $provider)
    {
        try {
            // stateless() prevents session issues with Inertia SPA context
            $socialUser = Socialite::driver($provider)->stateless()->user();

            // Try to find by email first (user may have registered normally)
            $customer = Customer::where('email', '=', $socialUser->getEmail())->first();

            if ($customer) {
                // Link the social ID to existing account if not already linked
                if (empty($customer->{"{$provider}_id"})) {
                    $customer->update(["{$provider}_id" => $socialUser->getId()]);
                }
            } else {
                // Auto-register a brand new customer
                $customer = Customer::create([
                    'name' => $socialUser->getName() ?? 'Khách hàng',
                    'email' => $socialUser->getEmail(),
                    'password' => Hash::make(Str::random(24)),
                    "{$provider}_id" => $socialUser->getId(),
                    'avatar' => $socialUser->getAvatar(),
                    'is_active' => true,
                ]);
            }

            Auth::guard('customer')->login($customer);
            $request = request();
            $request->session()->regenerate();

            return redirect()->route('client.home')->with('success', 'Đăng nhập thành công! 🎉');

        } catch (\Exception $e) {
            Log::error("Social Login Error [{$provider}]: ".$e->getMessage());

            return redirect()->route('login')
                ->with('error', 'Đăng nhập bằng mạng xã hội thất bại. Vui lòng thử lại!');
        }
    }

    // ─────────────────────────────────────────────
    //  Forgot & Reset Password
    // ─────────────────────────────────────────────

    public function showForgotPassword(): Response
    {
        try {
            $banner = Setting::get('client_auth_banner', self::DEFAULT_AUTH_BANNER);
        } catch (\Exception $e) {
            $banner = self::DEFAULT_AUTH_BANNER;
        }

        return Inertia::render('Client/Auth/ForgotPassword', ['authBanner' => $banner]);
    }

    public function sendResetLinkEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:customers,email',
        ], [
            'email.required' => 'Vui lòng nhập địa chỉ email.',
            'email.email' => 'Định dạng email không hợp lệ.',
            'email.exists' => 'Không tìm thấy tài khoản với email này.',
        ]);

        $token = Str::random(60);

        // Save token to password_reset_tokens table
        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $request->email],
            [
                'email' => $request->email,
                'token' => Hash::make($token),
                'created_at' => now(),
            ]
        );

        // Generate the reset URL
        $resetUrl = route('client.password.reset', ['token' => $token, 'email' => $request->email]);

        // Send Email
        try {
            Mail::raw("Chào bạn,\n\nVui lòng click vào đường dẫn sau để đặt lại mật khẩu cho tài khoản OmniCommerce của bạn:\n{$resetUrl}\n\nĐường dẫn này sẽ hết hạn sau 60 phút.\n\nTrân trọng,\nOmniCommerce Team", function ($message) use ($request) {
                $message->to($request->email)
                    ->subject('Khôi phục mật khẩu tài khoản OmniCommerce');
            });
        } catch (\Exception $e) {
            Log::error('Failed to send reset link email: '.$e->getMessage());
            Log::info('Password Reset Link (Logged for Dev): '.$resetUrl);
        }

        return back()->with('success', 'Đã gửi email khôi phục mật khẩu. Vui lòng kiểm tra hộp thư!');
    }

    public function showResetPassword(Request $request, string $token): Response
    {
        try {
            $banner = Setting::get('client_auth_banner', self::DEFAULT_AUTH_BANNER);
        } catch (\Exception $e) {
            $banner = self::DEFAULT_AUTH_BANNER;
        }

        return Inertia::render('Client/Auth/ResetPassword', [
            'authBanner' => $banner,
            'token' => $token,
            'email' => $request->query('email'),
        ]);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email|exists:customers,email',
            'password' => 'required|string|min:6|confirmed',
        ], [
            'email.required' => 'Vui lòng nhập địa chỉ email.',
            'email.email' => 'Định dạng email không hợp lệ.',
            'email.exists' => 'Không tìm thấy tài khoản với email này.',
            'password.required' => 'Vui lòng nhập mật khẩu mới.',
            'password.min' => 'Mật khẩu phải có ít nhất 6 ký tự.',
            'password.confirmed' => 'Xác nhận mật khẩu mới không khớp.',
        ]);

        $record = DB::table('password_reset_tokens')->where('email', $request->email)->first();

        if (! $record || ! Hash::check($request->token, $record->token)) {
            throw ValidationException::withMessages([
                'email' => 'Mã khôi phục mật khẩu không hợp lệ hoặc đã hết hạn.',
            ]);
        }

        // Update password
        Customer::where('email', $request->email)->update([
            'password' => Hash::make($request->password),
        ]);

        // Delete the token
        DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return redirect()->route('client.login')->with('success', 'Mật khẩu của bạn đã được cập nhật thành công! Vui lòng đăng nhập lại.');
    }
}
