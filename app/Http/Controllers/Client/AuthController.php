<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
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
            'email'    => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::guard('customer')->attempt($credentials, $request->boolean('remember'))) {
            $request->session()->regenerate();
            $redirectUrl = $request->query('intended', route('home'));
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
            'name'     => 'required|string|max:255',
            'email'    => 'required|string|email|max:255|unique:customers',
            'password' => 'required|string|min:6|confirmed',
        ], [
            'email.unique'       => 'Email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng email khác.',
            'password.confirmed' => 'Mật khẩu xác nhận không khớp.',
            'password.min'       => 'Mật khẩu phải có ít nhất 6 ký tự.',
        ]);

        $customer = Customer::create([
            'name'      => $request->name,
            'email'     => $request->email,
            'password'  => Hash::make($request->password),
            'is_active' => true,
        ]);

        Auth::guard('customer')->login($customer);
        $request->session()->regenerate();

        return redirect()->route('home')
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
                    'name'             => $socialUser->getName() ?? 'Khách hàng',
                    'email'            => $socialUser->getEmail(),
                    'password'         => Hash::make(Str::random(24)),
                    "{$provider}_id"   => $socialUser->getId(),
                    'avatar'           => $socialUser->getAvatar(),
                    'is_active'        => true,
                ]);
            }

            Auth::guard('customer')->login($customer);
            $request = request();
            $request->session()->regenerate();

            return redirect()->route('home')->with('success', 'Đăng nhập thành công! 🎉');

        } catch (\Exception $e) {
            Log::error("Social Login Error [{$provider}]: " . $e->getMessage());
            return redirect()->route('login')
                ->with('error', 'Đăng nhập bằng mạng xã hội thất bại. Vui lòng thử lại!');
        }
    }
}
