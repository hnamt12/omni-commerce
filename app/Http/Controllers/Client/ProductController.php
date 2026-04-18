<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // ─────────────────────────────────────────────
    //  Shop Listing (Phase 150)
    // ─────────────────────────────────────────────
    public function index(Request $request)
    {
        $relations = ['brand', 'variants.attributeValues.attribute'];

        $query = Product::with($relations)->where('is_active', '=', true);

        // Filter: categories (array)
        if ($request->has('categories') && !empty($request->categories)) {
            $query->whereIn('category_id', (array) $request->categories);
        }
        // Filter: brands (array)
        if ($request->has('brands') && !empty($request->brands)) {
            $query->whereIn('brand_id', (array) $request->brands);
        }
        // Filter: price range
        if ($request->filled('min_price')) {
            $query->whereHas('variants', fn ($q) => $q->where('price', '>=', $request->min_price));
        }
        if ($request->filled('max_price')) {
            $query->whereHas('variants', fn ($q) => $q->where('price', '<=', $request->max_price));
        }

        // Sorting
        match ($request->input('sort', 'latest')) {
            'price_asc'  => $query->withMin('variants', 'price')->orderBy('variants_min_price', 'asc'),
            'price_desc' => $query->withMin('variants', 'price')->orderBy('variants_min_price', 'desc'),
            'popular'    => $query->orderBy('views_count', 'desc'),
            default      => $query->latest(),
        };

        $products   = $query->paginate(12)->withQueryString();

        // Sidebar data
        $categories = Category::whereNull('parent_id')
            ->where('is_active', '=', true)
            ->withCount('products')
            ->orderBy('name')
            ->get();

        $brands = Brand::withCount('products')
            ->orderBy('name')
            ->get();

        return inertia('Client/Shop/Index', [
            'products'   => $products,
            'categories' => $categories,
            'brands'     => $brands,
            'filters'    => $request->only(['categories', 'brands', 'min_price', 'max_price', 'sort']),
        ]);
    }

    // ─────────────────────────────────────────────
    //  Product Detail (Phase 150)
    // ─────────────────────────────────────────────
    public function show($slug)
    {
        $product = Product::with([
            'category', 'brand', 'images',
            'variants.attributeValues.attribute',   // Attribute group name (e.g. "Màu sắc")
            'variants.attributeValues.value',       // AttributeValue text (e.g. "Đỏ") — CRITICAL
            'reviews.customer',
        ])->where('slug', '=', $slug)->firstOrFail();

        // Group attributes — push AttributeValue (not the pivot row)
        $groupedAttributes = [];
        foreach ($product->variants as $variant) {
            if (!$variant->attributeValues) continue;
            foreach ($variant->attributeValues as $pivot) {
                /** @var \App\Models\ProductVariantAttribute $pivot */
                $attribute = $pivot->attribute;          // Attribute model (e.g. "Màu sắc")
                $attrValue = $pivot->value;              // AttributeValue model (e.g. "Đỏ")

                if (!$attribute || !$attrValue) continue;

                $attrName = $attribute->name;
                if (!isset($groupedAttributes[$attrName])) {
                    $groupedAttributes[$attrName] = [
                        'id'     => $attribute->id,
                        'values' => collect([]),
                    ];
                }
                if (!$groupedAttributes[$attrName]['values']->contains('id', $attrValue->id)) {
                    $groupedAttributes[$attrName]['values']->push($attrValue);
                }
            }
        }
        // Convert to plain arrays for clean Inertia JSON
        foreach ($groupedAttributes as $key => $group) {
            $groupedAttributes[$key]['values'] = $group['values']->values()->all();
        }

        $relatedProducts = Product::with(['variants'])
            ->where('category_id', '=', $product->category_id)
            ->where('id', '!=', $product->id)
            ->where('is_active', '=', true)
            ->take(4)
            ->get();

        return inertia('Client/Products/Show', [
            'product'           => $product,
            'groupedAttributes' => $groupedAttributes,
            'relatedProducts'   => $relatedProducts,
            'reviews'           => $product->reviews,
        ]);
    }

    // ─────────────────────────────────────────────
    //  View Counter (Phase 141)
    // ─────────────────────────────────────────────
    public function incrementViews(Request $request, $id)
    {
        Product::where('id', '=', $id)->increment('views_count');
        return response()->json(['success' => true]);
    }
}
