<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Product;
use App\Models\Category;
use App\Models\Brand;
use App\Models\Attribute;
use App\Models\AttributeValue;
use App\Models\ProductImage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $products = Product::with(['category', 'brand', 'variants'])
            ->when($search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%")
                      ->orWhere('sku', 'like', "%{$search}%");
            })
            ->orderBy('id', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Products/Index', [
            'products' => $products,
            'filters' => $request->only(['search'])
        ]);
    }

    public function create()
    {
        $categories = Category::all(); 
        $brands = Brand::all();
        $attributes = Attribute::with('values')->get();

        return Inertia::render('Admin/Products/Form', [
            'categories' => $categories,
            'brands' => $brands,
            'attributes' => $attributes
        ]);
    }

    public function store(Request $request)
    {
        Log::info('Product submission data:', $request->all());

        $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'brand_id' => 'nullable|exists:brands,id',
            'variants' => 'required|string', 
            'image' => 'nullable|image|max:2048',
        ]);

        try {
            DB::beginTransaction();

            $imageUrl = null;
            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('products', 'public');
                $imageUrl = Storage::url($path);
            }

            $product = Product::create([
                'name' => $request->name,
                'slug' => Str::slug($request->name),
                'category_id' => $request->category_id,
                'brand_id' => $request->brand_id ?: null,
                'description' => $request->description,
                'weight' => $request->weight ? (float)$request->weight : 0,
                'length' => $request->length ? (float)$request->length : 0,
                'width' => $request->width ? (float)$request->width : 0,
                'height' => $request->height ? (float)$request->height : 0,
                'is_active' => filter_var($request->is_active, FILTER_VALIDATE_BOOLEAN),
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
                'image_url' => $imageUrl,
                'base_price' => $request->base_price ?? 0,
                'sku' => $request->sku ?? strtoupper(Str::random(8)),
            ]);

            $variantsData = json_decode($request->variants, true);
            
            if (is_array($variantsData)) {
                foreach ($variantsData as $v) {
                    $variant = $product->variants()->create([
                        'sku' => $v['sku'] ?? ($product->sku . '-' . strtoupper(Str::random(4))),
                        'price' => $v['price'] ?? 0,
                        'original_price' => $v['original_price'] ?? null,
                        'stock' => $v['stock'] ?? 0,
                        'options' => $v['options'] ?? null,
                    ]);

                    if (!empty($v['attributes']) && is_array($v['attributes'])) {
                        foreach ($v['attributes'] as $attrId => $attrValueId) {
                            
                            if (!is_numeric($attrValueId)) {
                                $newVal = AttributeValue::firstOrCreate([
                                    'attribute_id' => $attrId,
                                    'value' => $attrValueId
                                ]);
                                $attrValueId = $newVal->id;
                            }

                            $variant->attributeValues()->create([
                                'attribute_id' => $attrId,
                                'attribute_value_id' => $attrValueId,
                            ]);
                        }
                    }
                }
            }

            if ($request->hasFile('gallery')) {
                foreach ($request->file('gallery') as $file) {
                    $path = Storage::disk('public')->putFile('product_gallery', $file);
                    ProductImage::create([
                        'product_id' => $product->id,
                        'image_url' => Storage::url($path),
                    ]);
                }
            }

            DB::commit();

            return redirect()->route('admin.products.index')->with('success', 'Tạo sản phẩm thành công.');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("PRODUCT CREATE ERROR: " . $e->getMessage());
            return back()->withErrors(['error' => 'Lỗi khi lưu sản phẩm: ' . $e->getMessage()]);
        }
    }

    public function show($id)
    {
        $product = Product::with(['category', 'brand', 'variants.attributeValues.attribute', 'variants.attributeValues.value'])->findOrFail($id);
        $item_images = ProductImage::where('product_id', $id)->get();
        
        return Inertia::render('Admin/Products/Show', [
            'product' => $product,
            'item_images' => $item_images
        ]);
    }

    public function edit($id)
    {
        $product = Product::with('variants.attributeValues')->findOrFail($id);
        $categories = Category::all(); 
        $brands = Brand::all();
        $attributes = Attribute::with('values')->get();
        $item_images = ProductImage::where('product_id', $id)->get();

        return Inertia::render('Admin/Products/Form', [
            'product' => $product,
            'categories' => $categories,
            'brands' => $brands,
            'attributes' => $attributes,
            'item_images' => $item_images
        ]);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);
        $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'variants' => 'required|string',
        ]);

        try {
            DB::beginTransaction();
            $product->update([
                'name' => $request->name,
                'slug' => Str::slug($request->name),
                'category_id' => $request->category_id,
                'brand_id' => $request->brand_id ?: null,
                'description' => $request->description,
                'weight' => $request->weight ? (float)$request->weight : 0,
                'length' => $request->length ? (float)$request->length : 0,
                'width' => $request->width ? (float)$request->width : 0,
                'height' => $request->height ? (float)$request->height : 0,
                'is_active' => filter_var($request->is_active, FILTER_VALIDATE_BOOLEAN),
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
            ]);

            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('products', 'public');
                $product->update(['image_url' => Storage::url($path)]);
            }

            $variantsData = json_decode($request->variants, true);
            $keptVariantIds = [];

            if (is_array($variantsData)) {
                foreach ($variantsData as $v) {
                    $variantId = $v['id'] ?? null;
                    if ($variantId) {
                        $variant = \App\Models\ProductVariant::find($variantId);
                        if ($variant && $variant->product_id == $product->id) {
                            $variant->update([
                                'sku' => $v['sku'], 'price' => $v['price'],
                                'original_price' => $v['original_price'], 'stock' => $v['stock'],
                            ]);
                            $keptVariantIds[] = $variant->id;
                        }
                    } else {
                        $variant = $product->variants()->create([
                            'sku' => $v['sku'] ?? ($product->sku . '-' . strtoupper(Str::random(4))),
                            'price' => $v['price'] ?? 0, 'original_price' => $v['original_price'] ?? null, 'stock' => $v['stock'] ?? 0,
                        ]);
                        $keptVariantIds[] = $variant->id;
                    }

                    if (isset($variant)) {
                        $variant->attributeValues()->delete(); // Reset map
                        if (!empty($v['attributes']) && is_array($v['attributes'])) {
                            foreach ($v['attributes'] as $attrId => $attrValueId) {
                                if (!is_numeric($attrValueId)) {
                                    $newVal = \App\Models\AttributeValue::firstOrCreate(['attribute_id' => $attrId, 'value' => $attrValueId]);
                                    $attrValueId = $newVal->id;
                                }
                                $variant->attributeValues()->create(['attribute_id' => $attrId, 'attribute_value_id' => $attrValueId]);
                            }
                        }
                    }
                }
            }
            $product->variants()->whereNotIn('id', $keptVariantIds)->delete(); // Chỉ xóa biến thể bị gỡ bỏ
            DB::commit();
            return redirect()->route('admin.products.index')->with('success', 'Cập nhật sản phẩm thành công.');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("PRODUCT UPDATE ERROR: " . $e->getMessage());
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return redirect()->back()->with('success', 'Đã xóa sản phẩm vào thùng rác.');
    }
}
