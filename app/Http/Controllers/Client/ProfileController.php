<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function index()
    {
        $customer  = auth('customer')->user();
        $addresses = \App\Models\Address::where('customer_id', '=', $customer->id)
            ->orderByDesc('is_default')
            ->get();

        return Inertia::render('Client/Profile/Index', [
            'customer'  => $customer,
            'addresses' => $addresses,
        ]);
    }

    public function updateInfo(Request $request)
    {
        /** @var Customer $customer */
        $customer = auth('customer')->user();

        $request->validate([
            'name'   => 'required|string|max:255',
            'phone'  => 'nullable|string|max:20',
            'gender' => 'nullable|in:male,female,other',
        ], [
            'name.required' => 'Vui lòng nhập họ tên.',
        ]);

        $customer->update($request->only(['name', 'phone', 'gender']));

        return back()->with('success', 'Đã cập nhật hồ sơ thành công!');
    }

    public function storeAddress(Request $request)
    {
        $customerId = auth('customer')->id();

        $request->validate([
            'name'          => 'required|string|max:255',
            'phone_number'  => 'required|string|max:20',
            'address'       => 'required|string|max:255',
            'province_name' => 'required|string',
            'district_name' => 'required|string',
            'ward_name'     => 'required|string',
        ], [
            'name.required'          => 'Vui lòng nhập họ tên.',
            'phone_number.required'  => 'Vui lòng nhập số điện thoại.',
            'address.required'       => 'Vui lòng nhập địa chỉ cụ thể.',
            'province_name.required' => 'Vui lòng chọn Tỉnh/Thành phố.',
            'district_name.required' => 'Vui lòng chọn Quận/Huyện.',
            'ward_name.required'     => 'Vui lòng chọn Phường/Xã.',
        ]);

        // Ghép chuỗi địa chỉ đầy đủ
        $fullAddress = $request->address . ', ' . $request->ward_name . ', ' . $request->district_name . ', ' . $request->province_name;

        // Xử lý is_default: tự động mặc định nếu chưa có địa chỉ nào
        $isDefault = $request->boolean('is_default');
        if ($isDefault || \App\Models\Address::where('customer_id', $customerId)->count() === 0) {
            \App\Models\Address::where('customer_id', $customerId)->update(['is_default' => 0]);
            $isDefault = 1;
        }

        \App\Models\Address::create([
            'customer_id'  => $customerId,
            'name'         => $request->name,
            'phone_number' => $request->phone_number,
            'address'      => $fullAddress,
            'is_default'   => $isDefault,
        ]);

        return back()->with('success', 'Đã thêm địa chỉ mới!');
    }
}
