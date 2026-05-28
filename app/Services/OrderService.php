<?php

namespace App\Services;

use App\Models\Order;
use App\Models\OrderStatusHistory;
use App\Models\ProductVariant;
use App\Models\Transaction;
use App\Models\VoucherUsage;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class OrderService
{
    /**
     * Logic Hủy Đơn Hàng Dùng Chung (Admin & Client)
     */
    public function cancelOrder($orderId, $canceledBy = 'system', $cancelReason = '')
    {
        return DB::transaction(function () use ($orderId, $canceledBy, $cancelReason) {
            // 1. Khóa dòng Đơn hàng (Row Lock) để chống 2 request hủy cùng lúc
            $order = Order::lockForUpdate()->with('items')->findOrFail($orderId);

            // 2. Kiểm tra điều kiện Hủy (Chặn nếu đã giao cho Ship)
            $uncancellableStates = ['Đang giao hàng', 'Giao hàng thất bại', 'Đã hoàn thành', 'Đã hủy', 'Trả hàng/Hoàn tiền'];
            if (in_array($order->status, $uncancellableStates)) {
                throw new Exception('Không thể hủy đơn hàng ở trạng thái: '.$order->status);
            }

            $oldStatus = $order->status;

            // 3. Xử lý Trả Kho an toàn
            foreach ($order->items as $item) {
                if ($item->variant_id) {
                    // DÙNG PRODUCTVARIANT, KHÔNG DÙNG PRODUCTSKU
                    $variant = ProductVariant::lockForUpdate()->find($item->variant_id);
                    if ($variant) {
                        $variant->increment('stock', $item->quantity);
                    }
                }
            }

            // 4. Xử lý Trả Voucher (Để khách có thể dùng lại)
            VoucherUsage::where('order_id', $order->id)->delete();

            // 5. Xử lý Hoàn tiền (Nếu khách đã thanh toán Online)
            if ($order->payment_status === 'paid' && $order->payment_method !== 'COD') {
                $order->payment_status = 'refunded';
                // Ghi nhận vào bảng Transaction cho Kế toán
                Transaction::create([
                    'order_id' => $order->id,
                    'payment_method' => $order->payment_method,
                    'amount' => $order->grand_total,
                    'status' => 'refund_pending',
                    'response_data' => json_encode(['reason' => $cancelReason, 'canceled_by' => $canceledBy]),
                ]);
            } else {
                $order->payment_status = 'failed';
            }

            // 6. Cập nhật Đơn hàng
            $order->status = 'Đã hủy';
            $order->canceled_by = $canceledBy;
            $order->cancel_reason = $cancelReason;
            $order->save();

            // 7. Ghi vết lịch sử
            $userId = Auth::check() ? Auth::id() : null;
            OrderStatusHistory::create([
                'order_id' => $order->id,
                'old_status' => $oldStatus,
                'new_status' => 'Đã hủy',
                'changed_by_user_id' => $userId,
                'note' => "Hủy bởi {$canceledBy}: {$cancelReason}",
            ]);

            return $order;
        });
    }
}
