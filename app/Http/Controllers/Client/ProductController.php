<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Order;
use App\Models\Post;
use App\Models\Product;
use App\Models\Review;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // ─────────────────────────────────────────────
    //  Shop Listing
    // ─────────────────────────────────────────────
    public function index(Request $request)
    {
        $relations = ['brand', 'variants.attributeValues.attribute'];

        $query = Product::with($relations)->where('is_active', '=', true);

        if ($request->has('categories') && !empty($request->categories)) {
            $query->whereIn('category_id', (array) $request->categories);
        }
        if ($request->has('brands') && !empty($request->brands)) {
            $query->whereIn('brand_id', (array) $request->brands);
        }
        if ($request->filled('min_price')) {
            $query->whereHas('variants', fn ($q) => $q->where('price', '>=', $request->min_price));
        }
        if ($request->filled('max_price')) {
            $query->whereHas('variants', fn ($q) => $q->where('price', '<=', $request->max_price));
        }

        match ($request->input('sort', 'latest')) {
            'price_asc'  => $query->withMin('variants', 'price')->orderBy('variants_min_price', 'asc'),
            'price_desc' => $query->withMin('variants', 'price')->orderBy('variants_min_price', 'desc'),
            'popular'    => $query->orderBy('views_count', 'desc'),
            default      => $query->latest(),
        };

        $products   = $query->paginate(12)->withQueryString();

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
    //  Product Detail — đầy đủ dữ liệu (CellPhones style)
    // ─────────────────────────────────────────────
    public function show($slug)
    {
        // ── 1. Sản phẩm chính ──────────────────────────────────────
        $product = Product::with([
            'category.parent',                          // Breadcrumb đầy đủ (danh mục cha)
            'brand',
            'images',
            'variants.attributeValues.attribute',
            'variants.attributeValues.value',
        ])->where('slug', '=', $slug)->firstOrFail();

        // ── 2. Nhóm thuộc tính (cho selector) ──────────────────────
        $groupedAttributes = [];
        foreach ($product->variants as $variant) {
            if (!$variant->attributeValues) continue;
            foreach ($variant->attributeValues as $pivot) {
                $attribute = $pivot->attribute;
                $attrValue = $pivot->value;
                if (!$attribute || !$attrValue) continue;
                $attrName = $attribute->name;
                if (!isset($groupedAttributes[$attrName])) {
                    $groupedAttributes[$attrName] = ['id' => $attribute->id, 'values' => collect([])];
                }
                if (!$groupedAttributes[$attrName]['values']->contains('id', $attrValue->id)) {
                    $groupedAttributes[$attrName]['values']->push($attrValue);
                }
            }
        }
        foreach ($groupedAttributes as $key => $group) {
            $groupedAttributes[$key]['values'] = $group['values']->values()->all();
        }

        // ── 3. Thông số kỹ thuật (CellPhones style — có nhóm) ──────
        //    Dữ liệu lưu dạng JSON: [{"group":"Màn hình","specs":[{"label":"Kích thước","value":"6.1 inch"},...]}]
        //    Hoặc flat array: [{"label":"RAM","value":"8GB"},...] — cả hai đều được xử lý
        $specsRaw = $product->specifications;
        $specGroups = [];

        if (!empty($specsRaw) && is_array($specsRaw)) {
            // Kiểm tra định dạng có nhóm hay flat
            $hasGroups = isset($specsRaw[0]['group']) || isset($specsRaw[0]['specs']);
            if ($hasGroups) {
                // Định dạng có nhóm: [{ group, specs: [{label, value}] }]
                $specGroups = array_map(function ($g) {
                    return [
                        'group' => $g['group'] ?? 'Thông số',
                        'specs' => array_map(fn ($s) => [
                            'label' => $s['label'] ?? $s['key'] ?? '',
                            'value' => $s['value'] ?? '',
                        ], $g['specs'] ?? $g['items'] ?? []),
                    ];
                }, $specsRaw);
            } else {
                // Định dạng flat: [{label, value}] → gom vào 1 nhóm "Thông số kỹ thuật"
                $specGroups = [[
                    'group' => 'Thông số kỹ thuật',
                    'specs' => array_map(fn ($s) => [
                        'label' => $s['label'] ?? $s['key'] ?? array_key_first($s) ?? '',
                        'value' => $s['value'] ?? array_values($s)[0] ?? '',
                    ], $specsRaw),
                ]];
            }
        }

        // Bổ sung thông số từ groupedAttributes nếu specGroups rỗng
        if (empty($specGroups) && !empty($groupedAttributes)) {
            $attrSpecs = [];
            foreach ($groupedAttributes as $attrName => $group) {
                $valueList = implode(', ', array_map(fn ($v) => $v['value']['value'] ?? '', $group['values']));
                if ($valueList) {
                    $attrSpecs[] = ['label' => $attrName, 'value' => $valueList];
                }
            }
            if ($attrSpecs) {
                $specGroups = [['group' => 'Phân loại', 'specs' => $attrSpecs]];
            }
        }

        // ── 4. Sản phẩm tương tự (nhiều hơn, có kèm brand & giá) ──
        $relatedProducts = Product::with(['variants', 'brand'])
            ->where('category_id', '=', $product->category_id)
            ->where('id', '!=', $product->id)
            ->where('is_active', '=', true)
            ->withCount('reviews')
            ->withAvg('reviews', 'rating')
            ->latest()
            ->take(12)          // Lấy nhiều hơn để carousel đẹp hơn
            ->get();

        // Fallback: nếu không có sản phẩm cùng danh mục, lấy random để test UI
        if ($relatedProducts->isEmpty()) {
            $relatedProducts = Product::with(['variants', 'brand'])
                ->where('id', '!=', $product->id)
                ->where('is_active', '=', true)
                ->withCount('reviews')
                ->withAvg('reviews', 'rating')
                ->inRandomOrder()
                ->take(12)
                ->get();
        }

        // ── 5. Đánh giá + thống kê ──────────────────────────────────
        $customer   = auth('customer')->user();
        $canReview  = false;
        $userReview = null;

        if ($customer) {
            $hasPurchased = Order::where('customer_id', $customer->id)
                ->where('status', 'Đã hoàn thành')
                ->whereHas('items', fn ($q) => $q->where('product_id', $product->id))
                ->exists();

            $userReview = Review::where('customer_id', $customer->id)
                ->where('product_id', $product->id)
                ->first();

            $canReview = $hasPurchased && !$userReview;
        }

        $reviews      = Review::with('customer')
            ->where('product_id', $product->id)
            ->latest()
            ->get();
        $reviewCount  = $reviews->count();
        $averageRating = $reviewCount > 0 ? round($reviews->avg('rating'), 1) : 0;

        $starDistribution = [];
        for ($i = 5; $i >= 1; $i--) {
            $count = $reviews->where('rating', $i)->count();
            $starDistribution[$i] = [
                'count'   => $count,
                'percent' => $reviewCount > 0 ? round($count / $reviewCount * 100) : 0,
            ];
        }

        // ── 6. Tin tức / Bài viết liên quan (dựa trên tên brand + danh mục) ──
        $keywords = array_filter([
            $product->brand?->name,
            $product->category?->name,
            $product->name,
        ]);

        $relatedPosts = Post::published()
            ->select(['id', 'title', 'slug', 'thumbnail', 'summary', 'published_at', 'views'])
            ->where(function ($q) use ($keywords) {
                foreach ($keywords as $kw) {
                    $q->orWhere('title', 'like', '%' . $kw . '%');
                }
            })
            ->orderByDesc('views')
            ->limit(4)
            ->get()
            ->each->append('reading_time');

        // Nếu không tìm được bài nào liên quan → lấy bài phổ biến nhất
        if ($relatedPosts->isEmpty()) {
            $relatedPosts = Post::published()
                ->select(['id', 'title', 'slug', 'thumbnail', 'summary', 'published_at', 'views'])
                ->orderByDesc('views')
                ->limit(4)
                ->get()
                ->each->append('reading_time');
        }

        // ── 7. Sản phẩm cùng thương hiệu (bán chạy) ──────────────
        $sameBrandProducts = [];
        if ($product->brand_id) {
            $sameBrandProducts = Product::with(['variants'])
                ->where('brand_id', '=', $product->brand_id)
                ->where('id', '!=', $product->id)
                ->where('is_active', '=', true)
                ->orderByDesc('views_count')
                ->take(6)
                ->get();
        }

        return inertia('Client/Products/Show', [
            'product'           => $product,
            'groupedAttributes' => $groupedAttributes,
            'specGroups'        => $specGroups,           // Thông số kỹ thuật đã nhóm
            'relatedProducts'   => $relatedProducts,
            'sameBrandProducts' => $sameBrandProducts,    // Sản phẩm cùng hãng
            'relatedPosts'      => $relatedPosts,          // Tin tức liên quan
            'reviews'           => $reviews,
            'reviewCount'       => $reviewCount,
            'averageRating'     => $averageRating,
            'starDistribution'  => $starDistribution,
            'canReview'         => $canReview,
            'userReview'        => $userReview,
        ]);
    }

    // ─────────────────────────────────────────────
    //  View Counter
    // ─────────────────────────────────────────────
    public function incrementViews(Request $request, $id)
    {
        Product::where('id', '=', $id)->increment('views_count');
        return response()->json(['success' => true]);
    }
}
