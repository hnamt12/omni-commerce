<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\InventoryHistory;
use App\Models\Product;
use App\Models\ProductLot;
use App\Models\ProductVariant;
use App\Models\Supplier;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Inertia\Inertia;

class InventoryController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $categoryId = $request->input('category_id');
        $brandId = $request->input('brand_id');
        $stockStatus = $request->input('stock_status');

        $query = Product::with(['category', 'brand', 'variants'])
            ->withSum('variants as total_stock', 'stock')
            ->where('is_active', 1);

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('sku', 'like', "%{$search}%");
            });
        }
        if ($categoryId) {
            $query->where('category_id', $categoryId);
        }
        if ($brandId) {
            $query->where('brand_id', $brandId);
        }

        // Filter by stock status using HAVING on the aggregated column
        if ($stockStatus === 'in_stock') {
            $query->having('total_stock', '>', 10);
        } elseif ($stockStatus === 'low_stock') {
            $query->havingRaw('total_stock > 0 AND total_stock <= 10');
        } elseif ($stockStatus === 'out_of_stock') {
            $query->having('total_stock', '<=', 0);
        }

        $products = $query->orderByDesc('id')->paginate(15)->withQueryString();

        // Compute stock_value and variant_count after pagination
        $products->getCollection()->transform(function ($product) {
            $product->stock_value = $product->variants->sum(fn ($v) => $v->stock * $v->price);
            $product->variant_count = $product->variants->count();

            return $product;
        });

        $categories = Category::select('id', 'name')->get();
        $brands = Brand::select('id', 'name')->get();

        // Global stats (all variants)
        $totalVariants = ProductVariant::count();
        $totalValue = (float) ProductVariant::sum(DB::raw('stock * price'));
        $lowStock = ProductVariant::where('stock', '>', 0)->where('stock', '<=', 10)->count();
        $outOfStock = ProductVariant::where('stock', '<=', 0)->count();

        return Inertia::render('Admin/Inventory/Index', [
            'products' => $products,
            'filters' => $request->only(['search', 'category_id', 'brand_id', 'stock_status']),
            'categories' => $categories,
            'brands' => $brands,
            'stats' => compact('totalVariants', 'totalValue', 'lowStock', 'outOfStock'),
        ]);
    }

    public function edit($id)
    {
        $product = Product::with(['variants.attributeValues.value', 'variants.lots.supplier'])->findOrFail($id);
        $suppliers = Supplier::where('is_active', 1)->orderBy('name')->get();

        return Inertia::render('Admin/Inventory/Edit', [
            'product' => $product,
            'suppliers' => $suppliers,
        ]);
    }

    public function updateBulk(Request $request, $id)
    {
        $request->validate([
            'items' => 'required|array',
            'items.*.variant_id' => 'required|exists:product_variants,id',
            'items.*.type' => 'required|in:add,sub,set',
            'items.*.quantity' => 'required|numeric|min:0',
            'items.*.supplier_id' => 'nullable|exists:suppliers,id',
            'items.*.lot_number' => 'nullable|string|max:50',
            'items.*.expiry_date' => 'nullable|date',
            'items.*.note' => 'required_if:items.*.type,add,sub|nullable|string|min:5|max:255',
        ], [
            'items.*.note.required_if' => 'Vui lòng nhập lý do kiểm kho (ít nhất 5 ký tự) khi thay đổi số lượng!',
            'items.*.note.min' => 'Lý do quá ngắn, vui lòng nhập rõ ràng hơn (≥ 5 ký tự).',
        ]);

        try {
            DB::transaction(function () use ($request) {
                foreach ($request->items as $item) {
                    // Skip no-op entries
                    if (in_array($item['type'], ['add', 'sub']) && $item['quantity'] == 0) {
                        continue;
                    }

                    $variant = ProductVariant::lockForUpdate()->findOrFail($item['variant_id']);
                    $stockBefore = $variant->stock;
                    $stockAfter = $stockBefore;
                    $actionType = 'system';
                    $lot = null;

                    if ($item['type'] === 'add') {
                        $stockAfter += $item['quantity'];
                        $actionType = 'import';

                        // Create a specific lot for the import batch
                        $lot = ProductLot::create([
                            'product_variant_id' => $variant->id,
                            'supplier_id' => $item['supplier_id'] ?? null,
                            'lot_number' => $item['lot_number'] ?? ('LOT-'.strtoupper(Str::random(6))),
                            'expiry_date' => $item['expiry_date'] ?? null,
                            'quantity' => $item['quantity'],
                            'initial_quantity' => $item['quantity'],
                        ]);
                    } elseif ($item['type'] === 'sub') {
                        $stockAfter -= $item['quantity'];
                        $actionType = 'export';
                        // FIFO subtraction is automatically executed via the ProductVariant Eloquent updating observer!
                    } elseif ($item['type'] === 'set') {
                        $stockAfter = $item['quantity'];
                        $actionType = 'adjustment';
                    }

                    if ($stockAfter < 0) {
                        throw new \Exception("Tồn kho của phân loại ID {$variant->id} không thể âm!");
                    }

                    if ($stockBefore === $stockAfter) {
                        continue;
                    } // No change – skip log

                    $variant->update(['stock' => $stockAfter]);

                    InventoryHistory::create([
                        'product_variant_id' => $variant->id,
                        'user_id' => auth()->id(),
                        'action_type' => $actionType,
                        'quantity_change' => $stockAfter - $stockBefore,
                        'stock_before' => $stockBefore,
                        'stock_after' => $stockAfter,
                        'note' => $item['note'] ?? 'Kiểm kê hệ thống',
                        'supplier_id' => $item['supplier_id'] ?? null,
                        'lot_number' => $item['lot_number'] ?? ($lot ? $lot->lot_number : null),
                        'expiry_date' => $item['expiry_date'] ?? null,
                    ]);
                }
            });

            return redirect()->route('admin.inventory.index')->with('success', 'Cập nhật kho hàng loạt thành công!');
        } catch (\Exception $e) {
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    // Kept for backward-compatibility with any existing single-variant update calls
    public function updateStock(Request $request, $variantId)
    {
        $request->validate([
            'type' => 'required|in:add,sub,set',
            'quantity' => 'required|integer|min:0',
            'note' => 'required|string|max:255',
        ]);

        try {
            DB::transaction(function () use ($request, $variantId) {
                $variant = ProductVariant::where('id', $variantId)->lockForUpdate()->firstOrFail();
                $stockBefore = $variant->stock ?? 0;
                $quantity = (int) $request->quantity;
                $type = $request->type;

                $stockAfter = $stockBefore;
                $quantityChange = 0;
                $actionType = 'system';

                if ($type === 'add') {
                    $stockAfter = $stockBefore + $quantity;
                    $quantityChange = $quantity;
                    $actionType = 'import';
                } elseif ($type === 'sub') {
                    $stockAfter = $stockBefore - $quantity;
                    $quantityChange = -$quantity;
                    $actionType = 'export';
                } elseif ($type === 'set') {
                    $stockAfter = $quantity;
                    $quantityChange = $stockAfter - $stockBefore;
                    $actionType = 'adjustment';
                }

                if ($stockAfter < 0) {
                    throw new \Exception('Số lượng tồn kho không thể âm.');
                }

                $variant->update(['stock' => $stockAfter]);

                InventoryHistory::create([
                    'product_variant_id' => $variant->id,
                    'user_id' => auth()->id(),
                    'action_type' => $actionType,
                    'quantity_change' => $quantityChange,
                    'stock_before' => $stockBefore,
                    'stock_after' => $stockAfter,
                    'note' => $request->note,
                ]);
            });

            return back()->with('success', 'Cập nhật kho thành công!');
        } catch (\Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }

    public function export()
    {
        $fileName = 'Kiem_Kho_'.date('Y-m-d_H-i-s').'.csv';
        $headers = [
            'Content-type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename={$fileName}",
            'Pragma' => 'no-cache',
            'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
            'Expires' => '0',
        ];

        $callback = function () {
            $file = fopen('php://output', 'w');
            // UTF-8 BOM – Excel reads Vietnamese correctly
            fprintf($file, chr(0xEF).chr(0xBB).chr(0xBF));
            fputcsv($file, ['Mã SP', 'Tên Sản Phẩm', 'Danh Mục', 'Thương Hiệu', 'Tổng Tồn Kho', 'Tổng Giá Trị (VNĐ)']);

            $products = Product::with(['category', 'brand', 'variants'])->where('is_active', 1)->get();
            foreach ($products as $p) {
                $totalStock = $p->variants->sum('stock');
                $totalValue = $p->variants->sum(fn ($v) => $v->stock * $v->price);
                fputcsv($file, [
                    $p->sku ?? '',
                    $p->name,
                    $p->category->name ?? 'N/A',
                    $p->brand->name ?? 'N/A',
                    $totalStock,
                    $totalValue,
                ]);
            }
            fclose($file);
        };

        return response()->stream($callback, 200, $headers);
    }
}
