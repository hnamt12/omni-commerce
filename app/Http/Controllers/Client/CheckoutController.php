<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Address;
use App\Models\Cart;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusHistory;
use App\Models\PaymentMethod;
use App\Models\ProductVariant;
use App\Models\Setting;
use App\Models\User;
use App\Models\Voucher;
use App\Notifications\NewOrderNotification;
use App\Services\PaymentService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CheckoutController extends Controller
{
    public function __construct(private PaymentService $paymentService) {}

    // ─────────────────────────────────────────────
    //  Checkout page
    // ─────────────────────────────────────────────
    public function checkout(Request $request)
    {
        $customerId = auth('customer')->id();
        $mode = $request->query('mode', 'cart');

        if ($mode === 'buy_now' && session()->has('buy_now_item')) {
            $buyNowData = session('buy_now_item');
            $cartItem = new Cart($buyNowData);
            $cartItem->load(['product', 'variant.attributeValues.attribute', 'variant.attributeValues.value']);
            $cartItems = collect([$cartItem]);
        } else {
            $query = Cart::with(['product', 'variant.attributeValues.attribute', 'variant.attributeValues.value'])
                ->where('customer_id', '=', $customerId);

            if ($request->has('cart_ids') && is_array($request->cart_ids)) {
                $query->whereIn('id', $request->cart_ids);
            }

            $cartItems = $query->get();
        }

        if ($cartItems->isEmpty()) {
            return redirect()->route('cart.index')->with('error', 'Giỏ hàng của bạn đang trống!');
        }

        $shippingFee = 35_000;
        $subtotal = $cartItems->sum(fn ($i) => $i->price * $i->quantity);

        $addresses = Address::where('customer_id', '=', $customerId)->orderByDesc('is_default')->get();
        $defaultAddress = $addresses->firstWhere('is_default', true) ?? $addresses->first();

        $availableVouchers = Voucher::where('is_active', true)
            ->where(function ($query) {
                $query->whereNull('start_date')->orWhere('start_date', '<=', now());
            })
            ->where(function ($query) {
                $query->whereNull('end_date')->orWhere('end_date', '>=', now());
            })->get();

        $paymentMethods = PaymentMethod::where('is_active', true)->orderBy('id', 'asc')->get();

        return Inertia::render('Client/Checkout/Index', [
            'checkout_mode' => $mode,
            'cart_ids' => $request->cart_ids ?? [],
            'cartItems' => $cartItems,
            'subtotal' => $subtotal,
            'shippingFee' => $shippingFee,
            'total' => $subtotal + $shippingFee,
            'customer' => auth('customer')->user(),
            'addresses' => $addresses,
            'defaultAddress' => $defaultAddress,
            'appliedVouchers' => session('applied_vouchers', []),
            'availableVouchers' => $availableVouchers,
            'paymentMethods' => $paymentMethods,
        ]);
    }

    // ─────────────────────────────────────────────
    //  Place order
    // ─────────────────────────────────────────────
    public function store(Request $request)
    {
        $customerId = auth('customer')->id();

        // ── 1. Resolve delivery address ───────────────────────
        $name = '';
        $phone = '';
        $addressText = '';

        if ($request->address_mode === 'existing') {
            $request->validate(['address_id' => 'required|exists:addresses,id']);
            $addr = Address::where('id', '=', $request->address_id)->where('customer_id', '=', $customerId)->firstOrFail();
            $name = $addr->name;
            $phone = $addr->phone_number;
            $addressText = $addr->address;
        } else {
            $request->validate([
                'new_name' => 'required|string|max:255',
                'new_phone' => 'required|string|max:20',
                'new_address' => 'required|string|max:500',
            ], [
                'new_name.required' => 'Vui lòng nhập họ tên người nhận.',
                'new_phone.required' => 'Vui lòng nhập số điện thoại.',
                'new_address.required' => 'Vui lòng nhập địa chỉ giao hàng.',
            ]);
            $name = $request->new_name;
            $phone = $request->new_phone;
            $addressText = $request->new_address;

            $isFirst = Address::where('customer_id', '=', $customerId)->count() === 0;
            Address::create([
                'customer_id' => $customerId,
                'name' => $name,
                'phone_number' => $phone,
                'address' => $addressText,
                'is_default' => $isFirst ? 1 : 0,
            ]);
        }

        $request->validate(['payment_method' => 'required|in:COD,VietQR,VNPay']);

        // ── 2. Load cart ────────────────────────────
        $mode = $request->input('mode', 'cart');
        if ($mode === 'buy_now' && session()->has('buy_now_item')) {
            $buyNowData = session('buy_now_item');
            $cartItem = new Cart($buyNowData);
            $cartItem->load(['product', 'variant']);
            $cartItems = collect([$cartItem]);
        } else {
            $query = Cart::with(['product', 'variant'])->where('customer_id', '=', $customerId);

            if ($request->has('cart_ids') && is_array($request->cart_ids)) {
                $query->whereIn('id', $request->cart_ids);
            }

            $cartItems = $query->get();
        }
        if ($cartItems->isEmpty()) {
            return back()->with('error', 'Giỏ hàng trống, không thể đặt hàng!');
        }

        $subtotal = $cartItems->sum(fn ($i) => $i->price * $i->quantity);

        DB::beginTransaction();
        try {
            // ── 3. Create Order record ────────────────────
            $order = Order::create([
                'order_code' => 'ORD'.strtoupper(Str::random(8)),
                'customer_id' => $customerId,
                'name' => $name,
                'phone' => $phone,
                'email' => auth('customer')->user()->email,
                'address' => $addressText,
                'description' => $request->note,
                'subtotal' => $subtotal,
                'shipping_fee' => 0,
                'discount_amount' => 0,
                'grand_total' => $subtotal,
                'payment_method' => $request->payment_method,
                'payment_status' => 'unpaid',
                'status' => 'Chờ xác nhận',
            ]);

            // Save VAT metadata & calculate 10% inclusive VAT amount
            $order->update([
                'tax_amount' => round($subtotal * 10 / 110, 2),
                'vat_invoice_number' => str_pad($order->id, 7, '0', STR_PAD_LEFT),
                'vat_invoice_serial' => Setting::get('invoice_serial_prefix', 'AA/22E'),
                'vat_invoice_template' => Setting::get('invoice_template_code', '01GTKT0/001'),
            ]);

            // ── 4. Create order items & deduct stock ──────
            foreach ($cartItems as $item) {
                $variant = ProductVariant::lockForUpdate()->find($item->variant_id);
                if (! $variant || $variant->stock < $item->quantity) {
                    $productName = $item->product->name ?? 'Sản phẩm';
                    throw new \Exception("Sản phẩm «{$productName}» không đủ tồn kho!");
                }

                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item->product_id,
                    'variant_id' => $variant->id,
                    'name' => $item->product->name ?? 'Sản phẩm',
                    'sku_code' => $variant->sku ?? '',
                    'image_url' => $item->variant->image ?? $item->product->thumbnail ?? '',
                    'quantity' => $item->quantity,
                    'price' => $item->price,
                    'total_price' => $item->price * $item->quantity,
                ]);

                $variant->decrement('stock', $item->quantity);
            }

            // ── 5. Log order status history ───────────────
            OrderStatusHistory::create([
                'order_id' => $order->id,
                'old_status' => null,
                'new_status' => 'Chờ xác nhận',
                'note' => 'Khách hàng đặt hàng trực tuyến.',
            ]);

            // ── 6. Clear session or cart ─────────────────────────────
            if ($mode === 'buy_now') {
                session()->forget('buy_now_item');
            } else {
                if ($request->has('cart_ids') && is_array($request->cart_ids)) {
                    Cart::where('customer_id', '=', $customerId)->whereIn('id', $request->cart_ids)->delete();
                } else {
                    Cart::where('customer_id', '=', $customerId)->delete();
                }
            }

            DB::commit();

            // ── 7. Gửi thông báo tới Admin có quyền quản lý đơn hàng ─────────
            try {
                // 🛑 [BẮT ĐẦU DEBUG]
                Log::channel('single')->info('--- BẮT ĐẦU TEST THÔNG BÁO ĐƠN HÀNG ---');
                Log::channel('single')->info('1. Đơn hàng vừa tạo ID: '.($order->id ?? 'KHÔNG_CÓ_ID'));

                // Lấy danh sách người nhận (Thêm ID 2 vào fallback để đảm bảo bắt trúng Admin test)
                $receivers = User::whereHas('roles', function ($q) {
                    $q->whereIn('name', ['admin', 'super admin', 'Super Admin']);
                })->orWhereIn('id', [1, 2])->get();

                Log::channel('single')->info('2. Số lượng người nhận tìm thấy: '.$receivers->count());
                Log::channel('single')->info('3. Danh sách ID người nhận: '.json_encode($receivers->pluck('id')));

                if ($receivers->isNotEmpty()) {
                    try {
                        Log::channel('single')->info('4. Đang tiến hành gọi hàm Notification::send...');
                        Notification::send($receivers, new NewOrderNotification($order));
                        Log::channel('single')->info('5. ✅ GỬI THÔNG BÁO THÀNH CÔNG (KHÔNG VĂNG LỖI).');
                    } catch (\Exception $e) {
                        Log::channel('single')->error('❌ LỖI NGHIÊM TRỌNG KHI GỬI THÔNG BÁO: '.$e->getMessage());
                        Log::channel('single')->error('File lỗi: '.$e->getFile().' - Dòng: '.$e->getLine());
                    }
                } else {
                    Log::channel('single')->warning('⚠️ KHÔNG TÌM THẤY AI ĐỂ GỬI THÔNG BÁO!');
                }
                // 🛑 [KẾT THÚC DEBUG]
            } catch (\Throwable $e) {
                logger()->error('[Notification] Failed to send NewOrderNotification: '.$e->getMessage());
            }

            // ── 7. Payment gateway redirect ───────────────
            if ($request->payment_method === 'VNPay') {
                $vnpayMethod = PaymentMethod::where('code', 'vnpay')->first();
                if (! $vnpayMethod || ! $vnpayMethod->is_active) {
                    return back()->with('error', 'Cổng thanh toán VNPay đang bảo trì. Vui lòng chọn phương thức khác.');
                }
                $vnp_Url = $this->paymentService->generateVnpayUrl($order, $request->ip());

                return Inertia::location($vnp_Url);
            }

            if ($request->payment_method === 'VietQR') {
                session()->forget('applied_vouchers');

                return redirect()->route('client.order.payment_qr', $order->id);
            }

            session()->forget('applied_vouchers');

            return redirect()->route('client.order.success', $order->id)
                ->with('success', 'Đặt hàng thành công! Cảm ơn bạn đã mua hàng.');

        } catch (\Exception $e) {
            DB::rollBack();

            return back()->with('error', $e->getMessage());
        }
    }

    // ─────────────────────────────────────────────
    //  Order success page
    // ─────────────────────────────────────────────
    public function success($orderId)
    {
        $customerId = auth('customer')->id();
        $order = Order::with(['items.product', 'items.variant.attributeValues.value'])
            ->where('id', '=', $orderId)
            ->where('customer_id', '=', $customerId)
            ->firstOrFail();

        $qrMethod = PaymentMethod::where('code', 'vietqr')->first();
        $qrConfig = $qrMethod?->config ?? [];
        $vietqr = [
            'is_active' => $qrMethod?->is_active ?? false,
            'bank_id' => $qrConfig['bank_id'] ?? '',
            'bank_account' => $qrConfig['bank_account'] ?? '',
            'bank_owner' => $qrConfig['bank_owner'] ?? '',
        ];

        return Inertia::render('Client/Checkout/Success', [
            'order' => $order,
            'vietqr' => $vietqr,
        ]);
    }
}
