<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Banner;
use App\Models\Category;
use App\Models\FlashSale;
use App\Models\Product;
use Inertia\Inertia;

class HomeController extends Controller
{
    public function index()
    {
        $productRelations = ['category', 'brand', 'variants.attributeValues.attribute'];

        // 1. Category tree (mega-menu)
        $categories = Category::whereNull('parent_id')
            ->where('is_active', '=', true)
            ->with(['children' => fn ($q) => $q->where('is_active', '=', true)->orderBy('id', 'asc')->limit(10)])
            ->orderBy('id', 'asc')
            ->get()
            ->map(function ($cat) {
                $cat->top_products = \App\Models\Product::where('category_id', $cat->id)
                    ->where('is_active', true)
                    ->orderBy('is_featured', 'desc')->orderBy('id', 'desc')
                    ->take(3)
                    ->get(['id', 'name', 'slug', 'thumbnail', 'base_price', 'sale_price']);
                
                $cat->top_brands = \App\Models\Brand::whereHas('products', function($q) use ($cat) {
                    $q->where('category_id', $cat->id);
                })->take(10)->get(['id', 'name', 'slug']);
            
                return $cat;
            });

        // 2. Banners from DB
        $banners = Banner::where('is_active', '=', true)
            ->orderBy('sort_order', 'asc')
            ->orderBy('id', 'asc')
            ->get();

        // 3. Active Flash Sale
        $flashSale = FlashSale::where('is_active', '=', true)
            ->where('start_time', '<=', now())
            ->where('end_time', '>', now())
            ->with(['items.variant.product', 'items.variant.attributeValues.value'])
            ->first();

        // 4. New arrivals (latest 10)
        $newProducts = Product::with($productRelations)
            ->where('is_active', '=', true)
            ->orderBy('id', 'desc')
            ->take(10)
            ->get();

        // 5. Trending (most viewed 10)
        $trendingProducts = Product::with($productRelations)
            ->where('is_active', '=', true)
            ->orderBy('views_count', 'desc')
            ->take(10)
            ->get();

        $featuredBrands = \App\Models\Brand::where('is_active', true)->take(8)->get();

        return Inertia::render('Client/Home', [
            'categories'       => $categories,
            'banners'          => $banners,
            'flashSale'        => $flashSale,
            'newProducts'      => $newProducts,
            'trendingProducts' => $trendingProducts,
            'featuredBrands'   => $featuredBrands,
        ]);
    }

    public function getRecentlyViewed(\Illuminate\Http\Request $request)
    {
        $ids = $request->input('ids', []);
        if (empty($ids)) return response()->json([]);

        // Fetch products with necessary relations for ProductCard
        $products = \App\Models\Product::with(['brand', 'variants'])
            ->whereIn('id', $ids)
            ->where('is_active', true)
            ->get()
            // Sort exactly as the IDs array order (most recent first)
            ->sortBy(function($model) use ($ids) {
                return array_search($model->id, $ids);
            })->values();

        return response()->json($products);
    }

    public function searchSuggestions(\Illuminate\Http\Request $request)
    {
        $keyword = $request->input('q');
        if (!$keyword || mb_strlen($keyword) < 2) {
            return response()->json([]);
        }

        $products = \App\Models\Product::where('is_active', true)
            ->where(function($q) use ($keyword) {
                $q->where('name', 'like', "%{$keyword}%")
                  ->orWhere('sku', 'like', "%{$keyword}%");
            })
            ->take(5)
            ->get(['id', 'name', 'slug', 'thumbnail', 'base_price', 'sale_price']);

        return response()->json($products);
    }
}
