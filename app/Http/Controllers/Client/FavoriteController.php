<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Product;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function toggle(Request $request, $productId)
    {
        $customerId = auth('customer')->id();
        if (! $customerId) {
            return back()->with('error', 'Vui lòng đăng nhập để lưu sản phẩm yêu thích.');
        }

        $product = Product::findOrFail($productId);

        $favorite = Favorite::where('customer_id', $customerId)
            ->where('product_id', $product->id)
            ->first();

        if ($favorite) {
            $favorite->delete();
            $message = 'Đã xóa sản phẩm khỏi danh sách yêu thích.';
        } else {
            Favorite::create([
                'customer_id' => $customerId,
                'product_id' => $product->id,
            ]);
            $message = 'Đã thêm sản phẩm vào danh sách yêu thích.';
        }

        return back()->with('success', $message);
    }
}
