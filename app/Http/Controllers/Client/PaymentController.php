<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderStatusHistory;
use App\Models\PaymentMethod;
use App\Services\PaymentService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PaymentController extends Controller
{
    public function __construct(private PaymentService $paymentService) {}

    // ─────────────────────────────────────────────
    //  VNPay Callback
    // ─────────────────────────────────────────────
    public function vnpayReturn(Request $request)
    {
        // Lấy Secret Key (fallback về sandbox nếu DB rỗng)
        $vnpayMethod = PaymentMethod::where('code', 'vnpay')->first();
        $vnp_HashSecret = trim($vnpayMethod?->config['hash_secret'] ?? 'XNBOHAEGXYUCARFXCWQFFQVAHAOSRLRC');

        $vnp_SecureHash = $request->vnp_SecureHash;
        $inputData = [];
        foreach ($request->all() as $key => $value) {
            if (substr($key, 0, 4) === 'vnp_') {
                $inputData[$key] = $value;
            }
        }
        unset($inputData['vnp_SecureHash']);
        ksort($inputData);
        $i = 0;
        $hashData = '';
        foreach ($inputData as $key => $value) {
            if ($i == 1) {
                $hashData .= '&'.urlencode($key).'='.urlencode($value);
            } else {
                $hashData .= urlencode($key).'='.urlencode($value);
                $i = 1;
            }
        }
        $secureHash = hash_hmac('sha512', $hashData, $vnp_HashSecret);

        // Tách mã đơn gốc từ TxnRef dạng ORDXXX_timestamp
        $realOrderCode = explode('_', $request->vnp_TxnRef)[0];
        $order = Order::where('order_code', $realOrderCode)->first();

        if (! $order) {
            return redirect()->route('client.order.index')
                ->with('error', 'Không tìm thấy đơn hàng trên hệ thống!');
        }

        if ($secureHash == $vnp_SecureHash) {
            if ($request->vnp_ResponseCode == '00') {
                // ✅ THANH TOÁN THÀNH CÔNG
                if ($order->payment_status === 'unpaid') {
                    $order->update(['payment_status' => 'paid']);
                    OrderStatusHistory::create([
                        'order_id' => $order->id,
                        'old_status' => $order->status,
                        'new_status' => $order->status,
                        'note' => 'Thanh toán VNPay thành công (MGD: '.$request->vnp_TransactionNo.').',
                    ]);
                }

                return redirect()->route('client.order.success', $order->id)
                    ->with('success', 'Thanh toán thành công!');
            } else {
                // ❌ LỖI HOẶC KHÁCH BẤM HỦY — GIỮ NGUYÊN ĐƠN
                OrderStatusHistory::create([
                    'order_id' => $order->id,
                    'old_status' => $order->status,
                    'new_status' => $order->status,
                    'note' => 'Khách hủy hoặc thanh toán VNPay thất bại (mã '.$request->vnp_ResponseCode.').',
                ]);

                return redirect()->route('client.order.show', $order->id)
                    ->with('error', 'Bạn đã hủy giao dịch hoặc thanh toán thất bại (Mã lỗi: '.$request->vnp_ResponseCode.'). Vui lòng thanh toán lại!');
            }
        }

        // ❌ SAI CHỮ KÝ — vẫn GIỮ NGUYÊN đơn
        OrderStatusHistory::create([
            'order_id' => $order->id,
            'old_status' => $order->status,
            'new_status' => $order->status,
            'note' => 'Lỗi xác thực chữ ký VNPay (trả về).',
        ]);

        return redirect()->route('client.order.show', $order->id)
            ->with('error', 'Lỗi xác thực chữ ký VNPay!');
    }

    // ─────────────────────────────────────────────
    //  VietQR: Trang quét mã QR
    // ─────────────────────────────────────────────
    public function paymentQr($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::with('items.product')
            ->where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        $qrConfig = PaymentMethod::where('code', 'vietqr')->first()?->config ?? [];
        $vietqr = [
            'bank_id' => $qrConfig['bank_id'] ?? '',
            'bank_account' => $qrConfig['bank_account'] ?? '',
            'bank_owner' => $qrConfig['bank_owner'] ?? '',
        ];

        return Inertia::render('Client/Checkout/PaymentQr', [
            'order' => $order,
            'vietqr' => $vietqr,
        ]);
    }

    // ─────────────────────────────────────────────
    //  VietQR: Khách xác nhận đã chuyển khoản
    // ─────────────────────────────────────────────
    public function confirmPaid($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        OrderStatusHistory::create([
            'order_id' => $order->id,
            'old_status' => $order->status,
            'new_status' => $order->status,
            'note' => 'Khách hàng xác nhận đã chuyển khoản thành công. Chờ Admin kiểm tra biến động số dư.',
        ]);

        return redirect()->route('client.order.success', $order->id)
            ->with('success', 'Hệ thống đã ghi nhận yêu cầu. Chúng tôi sẽ xử lý ngay khi nhận được tiền!');
    }

    // ─────────────────────────────────────────────
    //  Retry Payment (VNPay or VietQR)
    // ─────────────────────────────────────────────
    public function retryPayment($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        if ($order->payment_status === 'paid') {
            return back()->with('error', 'Đơn hàng đã được thanh toán.');
        }
        if ($order->status === 'Đã hủy') {
            return back()->with('error', 'Đơn hàng này đã bị hủy, không thể thanh toán lại.');
        }

        if ($order->payment_method === 'VietQR') {
            return redirect()->route('client.order.payment_qr', $order->id);
        }

        if ($order->payment_method === 'VNPay') {
            $vnpayMethod = PaymentMethod::where('code', 'vnpay')->first();
            if (! $vnpayMethod || ! $vnpayMethod->is_active) {
                return back()->with('error', 'Cổng thanh toán VNPay đang bảo trì.');
            }
            $vnp_Url = $this->paymentService->generateVnpayUrl($order, request()->ip());

            return Inertia::location($vnp_Url);
        }

        return back()->with('error', 'Phương thức thanh toán không hỗ trợ thử lại.');
    }
}
