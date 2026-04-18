<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SettingController extends Controller
{
    // ─────────────────────────────────────────────
    //  Payment Settings: index
    // ─────────────────────────────────────────────
    public function paymentIndex()
    {
        $settings = [
            // VietQR
            'vietqr_is_active'   => Setting::get('vietqr_is_active', '1'),
            'vietqr_bank_id'     => Setting::get('vietqr_bank_id', 'MB'),
            'vietqr_bank_account'=> Setting::get('vietqr_bank_account', ''),
            'vietqr_bank_owner'  => Setting::get('vietqr_bank_owner', ''),
            // VNPay
            'vnpay_is_active'    => Setting::get('vnpay_is_active', '0'),
            'vnpay_tmn_code'     => Setting::get('vnpay_tmn_code', ''),
            'vnpay_hash_secret'  => Setting::get('vnpay_hash_secret', ''),
            'vnpay_url'          => Setting::get('vnpay_url', 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html'),
        ];

        return Inertia::render('Admin/Settings/Payment', ['settings' => $settings]);
    }

    // ─────────────────────────────────────────────
    //  Payment Settings: update
    // ─────────────────────────────────────────────
    public function paymentUpdate(Request $request)
    {
        $data = $request->validate([
            'vietqr_is_active'    => 'required|boolean',
            'vietqr_bank_id'      => 'nullable|string',
            'vietqr_bank_account' => 'nullable|string',
            'vietqr_bank_owner'   => 'nullable|string',
            'vnpay_is_active'     => 'required|boolean',
            'vnpay_tmn_code'      => 'nullable|string',
            'vnpay_hash_secret'   => 'nullable|string',
            'vnpay_url'           => 'nullable|string',
        ]);

        foreach ($data as $key => $value) {
            Setting::updateOrCreate(['key' => $key], ['value' => $value]);
        }

        return back()->with('success', 'Cập nhật cấu hình các cổng thanh toán thành công!');
    }
}
