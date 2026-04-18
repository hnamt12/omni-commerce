<?php
namespace App\Http\Requests\Admin\Auth;

use Illuminate\Auth\Events\Lockout;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class LoginRequest extends FormRequest {
    protected $redirect = '/admin/login';

    public function authorize(): bool { return true; }
    
    public function rules(): array {
        return ['email' => ['required', 'string', 'email'], 'password' => ['required', 'string']];
    }
    
    public function authenticate(): void {
        $this->ensureIsNotRateLimited();
        if (! Auth::guard('web')->attempt($this->only('email', 'password'), $this->boolean('remember'))) {
            RateLimiter::hit($this->throttleKey());
            throw ValidationException::withMessages(['email' => 'Tài khoản hoặc mật khẩu không chính xác.']);
        }
        RateLimiter::clear($this->throttleKey());
    }
    
    public function ensureIsNotRateLimited(): void {
        if (! RateLimiter::tooManyAttempts($this->throttleKey(), 5)) { return; }
        event(new Lockout($this));
        $seconds = RateLimiter::availableIn($this->throttleKey());
        throw ValidationException::withMessages(['email' => 'Bạn đã đăng nhập sai quá nhiều lần. Vui lòng thử lại sau '.$seconds.' giây.']);
    }
    
    public function throttleKey(): string {
        return Str::transliterate(Str::lower($this->input('email')).'|'.$this->ip());
    }
}
