<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use App\Models\ProductVariant;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CartController extends Controller
{
    // ─────────────────────────────────────────────
    //  Helper — load cart items for current customer
    // ─────────────────────────────────────────────
    public function getCartItems(?int $customerId)
    {
        if (! $customerId) {
            return collect();
        }

        return Cart::with(['product', 'variant.attributeValues.attribute', 'variant.attributeValues.value'])
            ->where('customer_id', '=', $customerId)
            ->get();
    }

    // ─────────────────────────────────────────────
    //  Cart index page
    // ─────────────────────────────────────────────
    public function index()
    {
        $customerId = auth('customer')->id();
        $items = $this->getCartItems($customerId);
        $subtotal = $items->sum(fn ($i) => $i->price * $i->quantity);

        return Inertia::render('Client/Cart/Index', [
            'cartItems' => $items,
            'subtotal' => $subtotal,
        ]);
    }

    // ─────────────────────────────────────────────
    //  Add to cart  (AJAX-friendly + buy_now flag)
    // ─────────────────────────────────────────────
    public function add(Request $request)
    {
        $request->validate([
            'product_id' => 'required|integer|exists:products,id',
            'variant_id' => 'required|integer|exists:product_variants,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $customerId = auth('customer')->id();
        if (! $customerId) {
            return redirect()->route('client.login')->with('error', 'Vui lòng đăng nhập để mua hàng!');
        }

        $variant = ProductVariant::findOrFail($request->variant_id);

        // Check combined stock
        $existingQty = Cart::where('customer_id', '=', $customerId)
            ->where('variant_id', '=', $variant->id)
            ->value('quantity') ?? 0;

        $wantQty = $existingQty + $request->quantity;
        if ($wantQty > $variant->stock) {
            return back()->with('error', "Chỉ còn {$variant->stock} sản phẩm trong kho!");
        }

        // Handle buy_now: Use Session, bypass DB cart completely
        if ($request->boolean('buy_now')) {
            session()->put('buy_now_item', [
                'product_id' => $request->product_id,
                'variant_id' => $variant->id,
                'quantity' => $request->quantity,
                'price' => $variant->price,
            ]);

            return redirect()->route('client.checkout', ['mode' => 'buy_now']);
        }

        // Upsert logic
        $existing = Cart::where('customer_id', '=', $customerId)
            ->where('product_id', '=', $request->product_id)
            ->where('variant_id', '=', $variant->id)
            ->first();

        if ($existing) {
            $existing->increment('quantity', $request->quantity);
        } else {
            Cart::create([
                'customer_id' => $customerId,
                'product_id' => $request->product_id,
                'variant_id' => $variant->id,
                'quantity' => $request->quantity,
                'price' => $variant->price,
            ]);
        }

        // Standard add-to-cart
        return back()->with('success', 'Đã thêm sản phẩm vào giỏ hàng!');
    }

    // ─────────────────────────────────────────────
    //  Update quantity (AJAX-friendly)
    // ─────────────────────────────────────────────
    public function update(Request $request, $id)
    {
        $request->validate(['quantity' => 'required|integer|min:1']);

        $item = Cart::where('id', '=', $id)
            ->where('customer_id', '=', auth('customer')->id())
            ->firstOrFail();

        $variant = ProductVariant::findOrFail($item->variant_id);
        if ($request->quantity > $variant->stock) {
            $msg = "Chỉ còn {$variant->stock} sản phẩm trong kho!";

            return ($request->wantsJson() || $request->ajax())
                ? response()->json(['success' => false, 'message' => $msg])
                : back()->with('error', $msg);
        }

        $item->update(['quantity' => $request->quantity]);

        return back()->with('success', 'Đã cập nhật giỏ hàng!');
    }

    // ─────────────────────────────────────────────
    //  Remove item (AJAX-friendly)
    // ─────────────────────────────────────────────
    public function remove(Request $request, $id)
    {
        Cart::where('id', '=', $id)
            ->where('customer_id', '=', auth('customer')->id())
            ->delete();

        return back()->with('success', 'Đã xóa sản phẩm khỏi giỏ hàng!');
    }
}
