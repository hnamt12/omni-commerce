<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Auth\LoginRequest;
use App\Models\ActionLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class AuthController extends Controller
{
    /**
     * Show the admin login page.
     */
    public function showLogin(): Response
    {
        return Inertia::render('Admin/Login');
    }

    /**
     * Handle admin login request.
     *
     * @throws ValidationException
     */
    public function login(LoginRequest $request)
    {
        $request->authenticate();

        $request->session()->regenerate();

        $user = Auth::guard('web')->user();
        if ($user) {
            ActionLog::create([
                'user_id' => $user->id,
                'action' => 'login',
                'loggable_type' => get_class($user),
                'loggable_id' => $user->id,
                'old_values' => null,
                'new_values' => ['email' => $user->email, 'name' => $user->name],
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);
        }

        return redirect()->route('dashboard');
    }

    /**
     * Handle admin logout request.
     */
    public function logout(Request $request)
    {
        $user = Auth::guard('web')->user();
        if ($user) {
            ActionLog::create([
                'user_id' => $user->id,
                'action' => 'logout',
                'loggable_type' => get_class($user),
                'loggable_id' => $user->id,
                'old_values' => null,
                'new_values' => ['email' => $user->email, 'name' => $user->name],
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);
        }

        Auth::guard('web')->logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/admin/login');
    }
}
