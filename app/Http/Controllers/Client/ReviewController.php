<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{
    // ─────────────────────────────────────────────
    //  Helper: kiểm tra khách đã mua sản phẩm hay chưa
    // ─────────────────────────────────────────────
    private function hasPurchased(int $customerId, int $productId): bool
    {
        return Order::where('customer_id', $customerId)
            ->where('status', 'Đã hoàn thành')
            ->whereHas('items', fn ($q) => $q->where('product_id', $productId))
            ->exists();
    }

    // ─────────────────────────────────────────────
    //  Tạo đánh giá mới
    // ─────────────────────────────────────────────
    public function store(Request $request, int $productId)
    {
        $customer = Auth::guard('customer')->user();

        if (!$customer) {
            return back()->with('error', 'Vui lòng đăng nhập để đánh giá sản phẩm.');
        }

        if (!$this->hasPurchased($customer->id, $productId)) {
            return back()->with('error', 'Bạn chỉ có thể đánh giá sản phẩm đã mua và đã nhận hàng.');
        }

        // Kiểm tra đã đánh giá chưa
        $existing = Review::where('customer_id', $customer->id)
            ->where('product_id', $productId)
            ->first();

        if ($existing) {
            return back()->with('error', 'Bạn đã đánh giá sản phẩm này rồi. Hãy chỉnh sửa đánh giá hiện tại.');
        }

        $validated = $request->validate([
            'rating'  => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:2000',
        ]);

        Review::create([
            'product_id'  => $productId,
            'customer_id' => $customer->id,
            'rating'      => $validated['rating'],
            'comment'     => $validated['comment'] ?? null,
        ]);

        return back()->with('success', 'Cảm ơn bạn đã đánh giá sản phẩm!');
    }

    // ─────────────────────────────────────────────
    //  Cập nhật đánh giá
    // ─────────────────────────────────────────────
    public function update(Request $request, int $reviewId)
    {
        $customer = Auth::guard('customer')->user();
        $review   = Review::where('id', $reviewId)
            ->where('customer_id', $customer->id)
            ->firstOrFail();

        $validated = $request->validate([
            'rating'  => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:2000',
        ]);

        $review->update([
            'rating'  => $validated['rating'],
            'comment' => $validated['comment'] ?? null,
        ]);

        return back()->with('success', 'Đã cập nhật đánh giá của bạn!');
    }

    // ─────────────────────────────────────────────
    //  Xóa đánh giá
    // ─────────────────────────────────────────────
    public function destroy(int $reviewId)
    {
        $customer = Auth::guard('customer')->user();
        $review   = Review::where('id', $reviewId)
            ->where('customer_id', $customer->id)
            ->firstOrFail();

        $review->delete();

        return back()->with('success', 'Đã xóa đánh giá của bạn.');
    }
}
