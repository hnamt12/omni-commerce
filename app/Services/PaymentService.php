<?php

namespace App\Services;

use App\Models\Order;
use App\Models\PaymentMethod;

class PaymentService
{
    /**
     * Generate a VNPay payment URL for the given order.
     * Bulletproof: int-casts amount, fixes IPv6 localhost, falls back to sandbox credentials.
     */
    public function generateVnpayUrl(Order $order, ?string $ipAddress = null): string
    {
        $vnpayMethod = PaymentMethod::where('code', 'vnpay')->first();
        $config = $vnpayMethod?->config ?? [];

        $vnp_TmnCode = trim($config['tmn_code'] ?? 'CGXZLS0Z');
        $vnp_HashSecret = trim($config['hash_secret'] ?? 'XNBOHAEGXYUCARFXCWQFFQVAHAOSRLRC');
        $vnp_Url = trim($config['url'] ?? 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html');
        $vnp_Returnurl = route('client.vnpay.return');

        // Suffix timestamp ─ cho phép thanh toán lại cùng đơn
        $vnp_TxnRef = $order->order_code.'_'.time();
        $vnp_OrderInfo = 'Thanh toan don hang '.$order->order_code;
        $vnp_OrderType = 'billpayment';

        // Ép kiểu INT ─ tránh lỗi float làm sai chữ ký
        $vnp_Amount = (int) round($order->grand_total * 100);
        $vnp_Locale = 'vn';

        // Fix IPv6 localhost ::1 → VNPay không chấp nhận
        $vnp_IpAddr = $ipAddress ?: '127.0.0.1';
        if ($vnp_IpAddr === '::1' || empty($vnp_IpAddr)) {
            $vnp_IpAddr = '127.0.0.1';
        }

        $inputData = [
            'vnp_Version' => '2.1.0',
            'vnp_TmnCode' => $vnp_TmnCode,
            'vnp_Amount' => $vnp_Amount,
            'vnp_Command' => 'pay',
            'vnp_CreateDate' => now()->setTimezone('Asia/Ho_Chi_Minh')->format('YmdHis'),
            'vnp_CurrCode' => 'VND',
            'vnp_IpAddr' => $vnp_IpAddr,
            'vnp_Locale' => $vnp_Locale,
            'vnp_OrderInfo' => $vnp_OrderInfo,
            'vnp_OrderType' => $vnp_OrderType,
            'vnp_ReturnUrl' => $vnp_Returnurl,
            'vnp_TxnRef' => $vnp_TxnRef,
        ];

        ksort($inputData);
        $query = '';
        $i = 0;
        $hashdata = '';
        foreach ($inputData as $key => $value) {
            if ($i == 1) {
                $hashdata .= '&'.urlencode($key).'='.urlencode($value);
            } else {
                $hashdata .= urlencode($key).'='.urlencode($value);
                $i = 1;
            }
            $query .= urlencode($key).'='.urlencode($value).'&';
        }

        $vnp_Url .= '?'.$query;
        if (! empty($vnp_HashSecret)) {
            $vnpSecureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);
            $vnp_Url .= 'vnp_SecureHash='.$vnpSecureHash;
        }

        return $vnp_Url;
    }
}
