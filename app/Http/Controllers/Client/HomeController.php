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
            ->get();

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

        return Inertia::render('Client/Home', [
            'categories'       => $categories,
            'banners'          => $banners,
            'flashSale'        => $flashSale,
            'newProducts'      => $newProducts,
            'trendingProducts' => $trendingProducts,
        ]);
    }
}
