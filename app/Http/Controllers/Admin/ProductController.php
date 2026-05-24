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
        $search     = $request->input('search');
        $categoryId = $request->input('category_id');
        $brandId    = $request->input('brand_id');
        $isActive   = $request->input('is_active'); // '1', '0', or null (all)

        $sortField = $request->input('sort', 'created_at');
        $sortDir = $request->input('direction', 'desc');

        $products = Product::with(['category', 'brand', 'variants'])
            ->when($search, fn($q) => $q->where('name', 'like', "%{$search}%")->orWhere('sku', 'like', "%{$search}%"))
            ->when($categoryId, fn($q) => $q->where('category_id', $categoryId))
            ->when($brandId,    fn($q) => $q->where('brand_id', $brandId))
            ->when($isActive !== null && $isActive !== '', fn($q) => $q->where('is_active', (bool) $isActive))
            ->orderBy($sortField, $sortDir)
            ->paginate(15)
            ->withQueryString();

        return Inertia::render('Admin/Products/Index', [
            'products'   => $products,
            'categories' => Category::orderBy('name')->get(['id', 'name']),
            'brands'     => Brand::orderBy('name')->get(['id', 'name']),
            'filters'    => $request->only(['search', 'category_id', 'brand_id', 'is_active', 'sort', 'direction']),
        ]);
    }

    public function create()
    {
        $categories = Category::all(); 
        $brands = Brand::all();

        return Inertia::render('Admin/Products/Form', [
            'categories' => $categories,
            'brands' => $brands,
            'attributes' => \App\Models\Attribute::with('values')->get(),
        ]);
    }

    public function store(Request $request)
    {
        Log::info('Product store payload:', $request->all());

        $request->validate([
            'name'        => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'brand_id'    => 'nullable|exists:brands,id',
            'variants'    => 'required|string',
            'thumbnail'   => 'nullable|image|max:2048',
        ]);

        try {
            $product = DB::transaction(function () use ($request) {

                // ── 1. Upload thumbnail ──
                $thumbnailUrl = null;
                if ($request->hasFile('thumbnail')) {
                    $path         = $request->file('thumbnail')->store('products/thumbnails', 'public');
                    $thumbnailUrl = Storage::url($path);
                }

                // ── 2. Create base Product ──
                $product = Product::create([
                    'name'           => $request->name,
                    'slug'           => Str::slug($request->name),
                    'sku'            => $request->sku ?: strtoupper(Str::random(8)),
                    'category_id'    => $request->category_id,
                    'brand_id'       => $request->brand_id ?: null,
                    'description'    => $request->description,
                    'base_price'     => $request->base_price ?? 0,
                    'sale_price'     => $request->sale_price ?: null,
                    'cost_price'     => $request->cost_price ?: null,
                    'weight'         => $request->weight ? (float) $request->weight : 0,
                    'length'         => $request->length ? (float) $request->length : 0,
                    'width'          => $request->width  ? (float) $request->width  : 0,
                    'height'         => $request->height ? (float) $request->height : 0,
                    'is_active'      => $request->boolean('is_active'),
                    'is_featured'    => $request->boolean('is_featured'),
                    'thumbnail'      => $thumbnailUrl,
                    'image_url'      => $thumbnailUrl,
                    'specifications' => json_decode($request->specifications, true) ?: null,
                ]);

                // ── 3. Save Variants + sync attribute values ──
                $variantsData = json_decode($request->variants, true) ?: [];

                foreach ($variantsData as $v) {
                    $variant = $product->variants()->create([
                        'sku'            => $v['sku'] ?? ($product->sku . '-' . strtoupper(Str::random(4))),
                        'price'          => $v['price'] ?? 0,
                        'sale_price'     => $v['sale_price'] ?? null,
                        'cost_price'     => $v['cost_price'] ?? null,
                        'stock'          => $v['stock'] ?? 0,
                    ]);

                    $this->syncVariantAttributes($variant, $v['attributes'] ?? []);
                }

                // ── 4. Gallery images ──
                if ($request->hasFile('gallery')) {
                    foreach ($request->file('gallery') as $file) {
                        $path = Storage::disk('public')->putFile('product_gallery', $file);
                        ProductImage::create([
                            'product_id' => $product->id,
                            'image_url'  => Storage::url($path),
                        ]);
                    }
                }

                return $product;
            });

            return redirect()->route('admin.products.index')->with('success', 'Tạo sản phẩm thành công.');
        } catch (\Exception $e) {
            Log::error("PRODUCT CREATE ERROR: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            return back()->withErrors(['error' => 'Lỗi khi lưu sản phẩm: ' . $e->getMessage()]);
        }
    }

    public function show($id)
    {
        $product = Product::with(['category', 'brand', 'images', 'variants.attributeValues.attribute', 'variants.attributeValues.value'])->findOrFail($id);
        
        return Inertia::render('Admin/Products/Show', [
            'product' => $product,
            'item_images' => $product->images,
        ]);
    }

    public function edit($id)
    {
        $product = Product::with(['images', 'category', 'brand', 'variants.attributeValues.value'])->findOrFail($id);
        $categories = Category::all(); 
        $brands = Brand::all();

        // Pre-compute attributes with string values for the frontend Tag Input
        // Output: [{ attribute_id: 1, values: ['Đỏ', 'Xanh'] }, ...]
        $attrGroups = [];
        foreach ($product->variants as $variant) {
            foreach ($variant->attributeValues as $pva) {
                $attrId = $pva->attribute_id;
                $stringValue = $pva->value->value ?? (string) $pva->attribute_value_id;

                if (!isset($attrGroups[$attrId])) {
                    $attrGroups[$attrId] = [];
                }
                if (!in_array($stringValue, $attrGroups[$attrId])) {
                    $attrGroups[$attrId][] = $stringValue;
                }
            }
        }
        $productAttributes = [];
        foreach ($attrGroups as $attrId => $values) {
            $productAttributes[] = ['attribute_id' => $attrId, 'values' => $values];
        }

        return Inertia::render('Admin/Products/Form', [
            'product' => $product,
            'categories' => $categories,
            'brands' => $brands,
            'attributes' => \App\Models\Attribute::with('values')->get(),
            'item_images' => $product->images,
            'product_attributes' => $productAttributes,
        ]);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $request->validate([
            'name'        => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'brand_id'    => 'nullable|exists:brands,id',
            'variants'    => 'required|string',
            'thumbnail'   => 'nullable|image|max:2048',
        ]);

        try {
            DB::transaction(function () use ($request, $product) {

                // ── 1. Update base Product ──
                $product->update([
                    'name'           => $request->name,
                    'slug'           => Str::slug($request->name),
                    'sku'            => $request->sku ?: $product->sku,
                    'category_id'    => $request->category_id,
                    'brand_id'       => $request->brand_id ?: null,
                    'description'    => $request->description,
                    'base_price'     => $request->base_price ?? $product->base_price,
                    'sale_price'     => $request->sale_price ?: null,
                    'cost_price'     => $request->cost_price ?: null,
                    'weight'         => $request->weight ? (float) $request->weight : 0,
                    'length'         => $request->length ? (float) $request->length : 0,
                    'width'          => $request->width  ? (float) $request->width  : 0,
                    'height'         => $request->height ? (float) $request->height : 0,
                    'is_active'      => $request->boolean('is_active'),
                    'is_featured'    => $request->boolean('is_featured'),
                    'specifications' => json_decode($request->specifications, true) ?: null,
                ]);

                // ── 2. Upload thumbnail (if new one provided) ──
                if ($request->hasFile('thumbnail')) {
                    $path = $request->file('thumbnail')->store('products/thumbnails', 'public');
                    $url = Storage::url($path);
                    $product->update([
                        'thumbnail' => $url,
                        'image_url' => $url,
                    ]);
                }

                // ── 3a. Delete removed gallery images ──
                if ($request->has('deleted_images')) {
                    $deletedIds = json_decode($request->deleted_images, true) ?: [];
                    if (!empty($deletedIds)) {
                        $imagesToDelete = ProductImage::where('product_id', $product->id)
                            ->whereIn('id', $deletedIds)
                            ->get();

                        foreach ($imagesToDelete as $img) {
                            // Convert stored URL back to relative path for deletion
                            $relativePath = str_replace('/storage/', '', $img->image_url);
                            Storage::disk('public')->delete($relativePath);
                            $img->delete();
                        }
                    }
                }

                // ── 3b. Upload new gallery images ──
                if ($request->hasFile('gallery')) {
                    foreach ($request->file('gallery') as $file) {
                        $path = Storage::disk('public')->putFile('product_gallery', $file);
                        ProductImage::create([
                            'product_id' => $product->id,
                            'image_url'  => Storage::url($path),
                        ]);
                    }
                }

                // ── 4. Upsert Variants + sync attribute values ──
                $variantsData  = json_decode($request->variants, true) ?: [];
                $keptVariantIds = [];

                foreach ($variantsData as $v) {
                    $variantPayload = [
                        'sku'            => $v['sku'] ?? ($product->sku . '-' . strtoupper(Str::random(4))),
                        'price'          => $v['price'] ?? 0,
                        'sale_price'     => $v['sale_price'] ?? null,
                        'cost_price'     => $v['cost_price'] ?? null,
                        'stock'          => $v['stock'] ?? 0,
                    ];

                    $existingId = $v['id'] ?? null;

                    if ($existingId) {
                        // Update existing variant (only if it truly belongs to this product)
                        $variant = $product->variants()->where('id', $existingId)->first();
                        if ($variant) {
                            $variant->update($variantPayload);
                        } else {
                            // ID provided but doesn't belong to this product → create new
                            $variant = $product->variants()->create($variantPayload);
                        }
                    } else {
                        $variant = $product->variants()->create($variantPayload);
                    }

                    $keptVariantIds[] = $variant->id;

                    // Sync attribute values for this variant
                    $this->syncVariantAttributes($variant, $v['attributes'] ?? []);
                }

                // ── 4. Delete orphaned variants ──
                $product->variants()->whereNotIn('id', $keptVariantIds)->each(function ($orphan) {
                    $orphan->attributeValues()->delete();
                    $orphan->delete();
                });
            });

            return redirect()->route('admin.products.index')->with('success', 'Cập nhật sản phẩm thành công.');
        } catch (\Exception $e) {
            Log::error("PRODUCT UPDATE ERROR: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    /**
     * Sync attribute values for a single variant.
     * Deletes existing rows then re-creates from the attributes map.
     *
     * @param  \App\Models\ProductVariant  $variant
     * @param  array  $attributes  e.g. { "1": "3", "2": "Red" }
     */
    private function syncVariantAttributes($variant, array $attributes): void
    {
        // Wipe existing attribute rows for this variant
        $variant->attributeValues()->delete();

        foreach ($attributes as $attrId => $attrValueId) {
            // If value is a string name (not numeric id), resolve or create it
            if (!is_numeric($attrValueId)) {
                $resolved = AttributeValue::firstOrCreate(
                    ['attribute_id' => $attrId, 'value' => $attrValueId]
                );
                $attrValueId = $resolved->id;
            }

            $variant->attributeValues()->create([
                'attribute_id'       => $attrId,
                'attribute_value_id' => $attrValueId,
            ]);
        }
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return redirect()->back()->with('success', 'Đã xóa sản phẩm vào thùng rác.');
    }
}
