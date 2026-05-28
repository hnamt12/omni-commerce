<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderStatusHistory;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

/**
 * Customer order management (history, detail, cancel).
 * Checkout → CheckoutController | Payments → PaymentController | Vouchers → VoucherController
 */
class OrderController extends Controller
{
    // ─────────────────────────────────────────────
    //  Customer order history
    // ─────────────────────────────────────────────
    public function index()
    {
        $orders = Order::with(['items.product', 'items.variant.attributeValues.value'])
            ->where('customer_id', '=', auth('customer')->id())
            ->orderBy('created_at', 'desc')
            ->paginate(10);

        return Inertia::render('Client/Order/Index', ['orders' => $orders]);
    }

    // ─────────────────────────────────────────────
    //  Customer order detail
    // ─────────────────────────────────────────────
    public function show($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::with([
            'items.product',
            'items.variant.attributeValues.value',
            'statusHistories',
        ])
            ->where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        return Inertia::render('Client/Order/Show', ['order' => $order]);
    }

    // ─────────────────────────────────────────────
    //  Cancel Order
    // ─────────────────────────────────────────────
    public function cancel($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::with('items.variant')
            ->where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        if ($order->status !== 'Chờ xác nhận') {
            return back()->with('error', 'Chỉ có thể hủy đơn hàng ở trạng thái Chờ xác nhận!');
        }

        DB::beginTransaction();
        try {
            foreach ($order->items as $item) {
                if ($item->variant) {
                    $item->variant->increment('stock', $item->quantity);
                }
            }

            $order->update(['status' => 'Đã hủy']);

            OrderStatusHistory::create([
                'order_id'   => $order->id,
                'old_status' => 'Chờ xác nhận',
                'new_status' => 'Đã hủy',
                'note'       => 'Khách hàng tự hủy đơn trên hệ thống.',
            ]);

            DB::commit();
            return back()->with('success', 'Đã hủy đơn hàng thành công!');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Có lỗi xảy ra khi hủy đơn hàng.');
        }
    }

    // ─────────────────────────────────────────────
    //  Re-buy: add all items from a past order to cart
    // ─────────────────────────────────────────────
    public function rebuy($id)
    {
        $customerId = auth('customer')->id();
        $order = Order::with('items.variant.product')
            ->where('id', '=', $id)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        // 1. Validate stock & active status first (all-or-nothing feedback)
        foreach ($order->items as $item) {
            $variant = $item->variant;
            if (!$variant || !$variant->product || !$variant->product->is_active) {
                return back()->with('error', "Sản phẩm «{$item->name}» đã ngừng kinh doanh.");
            }
            if ($variant->stock < $item->quantity) {
                return back()->with('error', "Sản phẩm «{$item->name}» không đủ tồn kho để mua lại số lượng này.");
            }
        }

        // 2. Add to cart (merge if already exists)
        foreach ($order->items as $item) {
            $cartItem = \App\Models\Cart::where('customer_id', '=', $customerId)
                ->where('variant_id', '=', $item->variant_id)
                ->first();

            if ($cartItem) {
                $cartItem->increment('quantity', $item->quantity);
            } else {
                \App\Models\Cart::create([
                    'customer_id' => $customerId,
                    'product_id'  => $item->product_id,
                    'variant_id'  => $item->variant_id,
                    'quantity'    => $item->quantity,
                    'price'       => $item->variant->price,
                ]);
            }
        }

        return redirect()->route('cart.index')->with('success', 'Đã thêm các sản phẩm vào giỏ hàng!');
    }
}
