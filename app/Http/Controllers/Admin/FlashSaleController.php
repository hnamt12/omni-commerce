<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\FlashSale;
use App\Models\FlashSaleItem;
use App\Models\Product;
use App\Models\ProductVariant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class FlashSaleController extends Controller
{
    public function index()
    {
        $flashSales = FlashSale::withCount('items')->latest()->paginate(15);

        return Inertia::render('Admin/FlashSales/Index', [
            'flashSales' => $flashSales,
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/FlashSales/Form', ['flashSale' => null]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'start_time' => 'required|date',
            'end_time' => 'required|date|after:start_time',
            'is_active' => 'boolean',
        ]);
        $data['is_active'] = $data['is_active'] ?? false;
        $flashSale = FlashSale::create($data);

        return redirect()->route('admin.flash-sales.show', $flashSale->id)->with('success', 'Đã tạo chiến dịch Flash Sale! Hãy thêm sản phẩm.');
    }

    public function show($id)
    {
        $flashSale = FlashSale::with([
            'items.variant.product',
            'items.variant.attributeValues.value',
        ])->findOrFail($id);

        return Inertia::render('Admin/FlashSales/Show', ['flashSale' => $flashSale]);
    }

    public function edit($id)
    {
        $flashSale = FlashSale::findOrFail($id);

        return Inertia::render('Admin/FlashSales/Form', ['flashSale' => $flashSale]);
    }

    public function update(Request $request, $id)
    {
        $flashSale = FlashSale::findOrFail($id);
        $data = $request->validate([
            'name' => 'sometimes|string|max:255',
            'start_time' => 'sometimes|date',
            'end_time' => 'sometimes|date|after:start_time',
            'is_active' => 'boolean',
        ]);
        $flashSale->update($data);
        // If update came from Form page (has name), redirect to show; else stay
        if ($request->has('name')) {
            return redirect()->route('admin.flash-sales.show', $flashSale->id)->with('success', 'Đã cập nhật chiến dịch!');
        }

        return back()->with('success', 'Đã cập nhật chiến dịch!');
    }

    public function destroy($id)
    {
        FlashSale::findOrFail($id)->delete();

        return redirect()->route('admin.flash-sales.index')->with('success', 'Đã xóa chiến dịch!');
    }

    public function addMultipleProducts(Request $request, $id)
    {
        $currentFlashSale = FlashSale::findOrFail($id);
        $request->validate([
            'items' => 'required|array|min:1',
            'items.*.variant_id' => 'required|exists:product_variants,id',
            'items.*.discount_price' => 'required|numeric|min:0',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        DB::beginTransaction();
        try {
            foreach ($request->items as $item) {
                $variant = ProductVariant::lockForUpdate()->find($item['variant_id']);

                if ($item['discount_price'] >= $variant->price) {
                    throw new \Exception('Giá Sale của một số phân loại lớn hơn hoặc bằng giá gốc!');
                }
                if ($item['quantity'] > $variant->stock) {
                    throw new \Exception('Số lượng Sale vượt tồn kho thực tế!');
                }

                // Xóa item cũ nếu đã tồn tại trong Flash Sale này (để cập nhật đè lên)
                FlashSaleItem::where('flash_sale_id', $currentFlashSale->id)
                    ->where('variant_id', $variant->id)
                    ->delete();

                // Check trùng giờ
                $isOverlapping = FlashSaleItem::where('variant_id', '=', $variant->id)
                    ->whereHas('flashSale', function ($q) use ($currentFlashSale) {
                        $q->where('id', '!=', $currentFlashSale->id)
                            ->where('is_active', '=', 1)
                            ->where(function ($query) use ($currentFlashSale) {
                                $query->where('start_time', '<', $currentFlashSale->end_time)
                                    ->where('end_time', '>', $currentFlashSale->start_time);
                            });
                    })->exists();

                if ($isOverlapping) {
                    throw new \Exception("Biến thể ID {$variant->id} đang tham gia Flash Sale khác trùng giờ!");
                }

                $currentFlashSale->items()->create([
                    'variant_id' => $variant->id,
                    'discount_price' => $item['discount_price'],
                    'quantity' => $item['quantity'],
                    'sold_count' => 0,
                ]);
            }
            DB::commit();

            return back()->with('success', 'Đã cập nhật sản phẩm vào Flash Sale!');
        } catch (\Exception $e) {
            DB::rollBack();

            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    public function removeProduct($itemId)
    {
        FlashSaleItem::findOrFail($itemId)->delete();

        return back()->with('success', 'Đã xóa sản phẩm khỏi Flash Sale!');
    }

    public function searchProducts(Request $request)
    {
        $keyword = $request->input('keyword', '');
        if (! $keyword) {
            return response()->json([]);
        }

        $products = Product::with(['variants' => function ($q) {
            $q->where('stock', '>', 0)->with('attributeValues.value');
        }])
            ->where('is_active', 1)
            ->where('name', 'like', "%{$keyword}%")
            ->take(20)
            ->get();

        $filtered = $products->filter(fn ($p) => $p->variants->count() > 0)->values();

        return response()->json($filtered);
    }

    public function getProductVariants($id)
    {
        $product = Product::with(['variants' => function ($q) {
            $q->where('stock', '>', 0)->with('attributeValues.value');
        }])->findOrFail($id);

        return response()->json($product);
    }
}
