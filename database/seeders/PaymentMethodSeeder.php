<?php

namespace Database\Seeders;

use App\Models\PaymentMethod;
use Illuminate\Database\Seeder;

class PaymentMethodSeeder extends Seeder
{
    public function run(): void
    {
        // Avoid duplicates on re-run
        PaymentMethod::truncate();

        PaymentMethod::create([
            'name' => 'Thanh toán khi nhận hàng (COD)',
            'code' => 'cod',
            'description' => 'Khách hàng thanh toán trực tiếp cho shipper khi nhận hàng.',
            'type' => 'cod',
            'logo_url' => 'https://cdn-icons-png.flaticon.com/512/2800/2800155.png',
            'config' => [],
            'is_active' => true,
            'sort_order' => 1,
        ]);

        PaymentMethod::create([
            'name' => 'Chuyển khoản ngân hàng',
            'code' => 'bank_transfer',
            'description' => 'Khách hàng chuyển khoản thủ công theo thông tin tài khoản.',
            'type' => 'manual',
            'logo_url' => null,
            'config' => [
                'bank_name' => '',
                'account_no' => '',
                'account_name' => '',
            ],
            'is_active' => true,
            'sort_order' => 2,
        ]);

        PaymentMethod::create([
            'name' => 'Chuyển khoản (VietQR)',
            'code' => 'vietqr',
            'description' => 'Quét mã QR VietQR để thanh toán tự động xác nhận.',
            'type' => 'manual',
            'logo_url' => 'https://vietqr.net/portal/v2/img/logo-vietqr.png',
            'config' => [
                'bank_id' => 'MB',
                'bank_account' => '',
                'bank_owner' => '',
            ],
            'is_active' => true,
            'sort_order' => 3,
        ]);

        PaymentMethod::create([
            'name' => 'Cổng thanh toán VNPay',
            'code' => 'vnpay',
            'description' => 'Thanh toán online qua cổng VNPay (thẻ ATM, Visa, QR).',
            'type' => 'gateway',
            'logo_url' => 'https://vnpay.vn/s1/statics.vnpay.vn/2023/9/06ncktiwd6dc1694418186387.png',
            'config' => [
                'tmn_code' => 'CGXZLS0Z',
                'hash_secret' => 'XNBOHAEGXYUCARFXCWQFFQVAHAOSRLRC',
                'url' => 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
            ],
            'is_active' => true,
            'sort_order' => 4,
        ]);
    }
}
