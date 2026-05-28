<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Address;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ProfileController extends Controller
{
    public function index()
    {
        $customer = auth('customer')->user();
        $addresses = Address::where('customer_id', '=', $customer->id)
            ->orderByDesc('is_default')
            ->get();

        $favoriteProducts = $customer->favoriteProducts()
            ->with(['variants.attributeValues.value', 'brand'])
            ->get();

        return Inertia::render('Client/Profile/Index', [
            'customer' => $customer,
            'addresses' => $addresses,
            'favoriteProducts' => $favoriteProducts,
        ]);
    }

    public function updateInfo(Request $request)
    {
        /** @var Customer $customer */
        $customer = auth('customer')->user();

        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'gender' => 'nullable|in:male,female,other',
            'avatar' => 'nullable|image|max:2048',
        ], [
            'name.required' => 'Vui lòng nhập họ tên.',
            'avatar.image' => 'Định dạng ảnh đại diện không hợp lệ.',
            'avatar.max' => 'Ảnh đại diện tối đa 2MB.',
        ]);

        $data = $request->only(['name', 'phone', 'gender']);

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists and not default
            if ($customer->avatar && Storage::disk('public')->exists(str_replace('/storage/', '', $customer->avatar))) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $customer->avatar));
            }
            // Store new avatar
            $path = $request->file('avatar')->store('avatars', 'public');
            $data['avatar'] = '/storage/'.$path;
        }

        $customer->update($data);

        return back()->with('success', 'Đã cập nhật hồ sơ thành công!');
    }

    public function storeAddress(Request $request)
    {
        $customerId = auth('customer')->id();

        $request->validate([
            'name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string|max:255',
            'province_name' => 'required|string',
            'district_name' => 'required|string',
            'ward_name' => 'required|string',
        ], [
            'name.required' => 'Vui lòng nhập họ tên.',
            'phone_number.required' => 'Vui lòng nhập số điện thoại.',
            'address.required' => 'Vui lòng nhập địa chỉ cụ thể.',
            'province_name.required' => 'Vui lòng chọn Tỉnh/Thành phố.',
            'district_name.required' => 'Vui lòng chọn Quận/Huyện.',
            'ward_name.required' => 'Vui lòng chọn Phường/Xã.',
        ]);

        // Ghép chuỗi địa chỉ đầy đủ
        $fullAddress = $request->address.', '.$request->ward_name.', '.$request->district_name.', '.$request->province_name;

        // Xử lý is_default: tự động mặc định nếu chưa có địa chỉ nào
        $isDefault = $request->boolean('is_default');
        if ($isDefault || Address::where('customer_id', $customerId)->count() === 0) {
            Address::where('customer_id', $customerId)->update(['is_default' => 0]);
            $isDefault = 1;
        }

        Address::create([
            'customer_id' => $customerId,
            'name' => $request->name,
            'phone_number' => $request->phone_number,
            'address' => $fullAddress,
            'is_default' => $isDefault,
        ]);

        return back()->with('success', 'Đã thêm địa chỉ mới!');
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => ['required', 'current_password:customer'],
            'password' => ['required', 'string', 'min:6', 'confirmed'],
        ], [
            'current_password.required' => 'Vui lòng nhập mật khẩu hiện tại.',
            'current_password.current_password' => 'Mật khẩu hiện tại không đúng.',
            'password.required' => 'Vui lòng nhập mật khẩu mới.',
            'password.min' => 'Mật khẩu mới phải có ít nhất 6 ký tự.',
            'password.confirmed' => 'Mật khẩu xác nhận không khớp.',
        ]);

        /** @var Customer $customer */
        $customer = auth('customer')->user();
        $customer->update([
            'password' => Hash::make($request->password),
        ]);

        return back()->with('success', 'Đã đổi mật khẩu thành công!');
    }
}
