<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;

class ProfileController extends Controller
{
    public function index()
    {
        $user = auth('web')->user();
        return Inertia::render('Admin/Profile/Index', [
            'user' => $user
        ]);
    }

    public function update(Request $request)
    {
        $user = auth('web')->user();

        $request->validate([
            'name'   => 'required|string|max:255',
            'email'  => 'required|string|email|max:255|unique:users,email,' . $user->id,
            'avatar' => 'nullable|image|max:2048',
        ], [
            'name.required'  => 'Vui lòng nhập họ tên.',
            'email.required' => 'Vui lòng nhập địa chỉ email.',
            'email.email'    => 'Định dạng email không hợp lệ.',
            'email.unique'   => 'Email này đã được sử dụng.',
            'avatar.image'   => 'Định dạng ảnh không hợp lệ.',
            'avatar.max'     => 'Ảnh đại diện tối đa 2MB.',
        ]);

        $data = $request->only(['name', 'email']);

        if ($request->hasFile('avatar')) {
            // Delete old avatar
            if ($user->avatar && Storage::disk('public')->exists(str_replace('/storage/', '', $user->avatar))) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $user->avatar));
            }
            $path = $request->file('avatar')->store('avatars', 'public');
            $data['avatar'] = '/storage/' . $path;
        }

        $user->update($data);

        return back()->with('success', 'Cập nhật hồ sơ thành công.');
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => ['required', 'current_password:web'],
            'password'         => ['required', 'string', 'min:6', 'confirmed'],
        ], [
            'current_password.required'         => 'Vui lòng nhập mật khẩu hiện tại.',
            'current_password.current_password' => 'Mật khẩu hiện tại không đúng.',
            'password.required'                 => 'Vui lòng nhập mật khẩu mới.',
            'password.min'                      => 'Mật khẩu mới phải có ít nhất 6 ký tự.',
            'password.confirmed'                => 'Mật khẩu xác nhận không khớp.',
        ]);

        $user = auth('web')->user();
        $user->update([
            'password' => Hash::make($request->password)
        ]);

        return back()->with('success', 'Đổi mật khẩu thành công.');
    }
}
