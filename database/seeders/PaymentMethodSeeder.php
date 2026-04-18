<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PaymentMethod;

class PaymentMethodSeeder extends Seeder
{
    public function run(): void
    {
        // Avoid duplicates on re-run
        PaymentMethod::truncate();

        PaymentMethod::create([
            'name'       => 'Thanh toán khi nhận hàng (COD)',
            'code'       => 'cod',
            'type'       => 'cod',
            'logo_url'   => 'https://cdn-icons-png.flaticon.com/512/2800/2800155.png',
            'config'     => [],
            'is_active'  => true,
            'sort_order' => 1,
        ]);

        PaymentMethod::create([
            'name'       => 'Chuyển khoản (VietQR)',
            'code'       => 'vietqr',
            'type'       => 'manual',
            'logo_url'   => 'https://vietqr.net/portal/v2/img/logo-vietqr.png',
            'config'     => [
                'bank_id'      => 'MB',
                'bank_account' => '',
                'bank_owner'   => '',
            ],
            'is_active'  => true,
            'sort_order' => 2,
        ]);

        PaymentMethod::create([
            'name'       => 'Cổng thanh toán VNPay',
            'code'       => 'vnpay',
            'type'       => 'gateway',
            'logo_url'   => 'https://vnpay.vn/s1/statics.vnpay.vn/2023/9/06ncktiwd6dc1694418186387.png',
            'config'     => [
                'tmn_code'    => 'CGXZLS0Z',
                'hash_secret' => 'XNBOHAEGXYUCARFXCWQFFQVAHAOSRLRC',
                'url'         => 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
            ],
            'is_active'  => true,
            'sort_order' => 3,
        ]);
    }
}
