<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Inertia\Inertia;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        // ─── Date Filter ──────────────────────────────────────────────────────
        $endDate   = $request->input('end_date')   ? Carbon::parse($request->input('end_date'))->endOfDay()   : Carbon::now()->endOfDay();
        $startDate = $request->input('start_date') ? Carbon::parse($request->input('start_date'))->startOfDay() : Carbon::now()->subDays(29)->startOfDay();

        // Previous period (same duration) для comparison
        $diff      = $startDate->diffInDays($endDate);
        $prevEnd   = $startDate->copy()->subDay()->endOfDay();
        $prevStart = $prevEnd->copy()->subDays($diff)->startOfDay();

        // Cache key based on filters
        $cacheKey = 'dashboard_' . md5($startDate->toDateString() . '_' . $endDate->toDateString());

        $data = Cache::remember($cacheKey, 300, function () use ($startDate, $endDate, $prevStart, $prevEnd) {

            // ─── 1. Revenue ─────────────────────────────────────────────────
            $completedStatuses = ['Đã hoàn thành', 'Đang giao hàng', 'Đang chuẩn bị hàng', 'Đã xác nhận'];

            $revenueThis = Order::whereIn('status', $completedStatuses)
                ->whereBetween('created_at', [$startDate, $endDate])
                ->sum('grand_total');

            $revenuePrev = Order::whereIn('status', $completedStatuses)
                ->whereBetween('created_at', [$prevStart, $prevEnd])
                ->sum('grand_total');

            $revenueGrowth = $revenuePrev > 0
                ? round((($revenueThis - $revenuePrev) / $revenuePrev) * 100, 1)
                : ($revenueThis > 0 ? 100 : 0);

            // ─── 2. Orders ──────────────────────────────────────────────────
            $ordersThis    = Order::whereBetween('created_at', [$startDate, $endDate])->count();
            $ordersPrev    = Order::whereBetween('created_at', [$prevStart, $prevEnd])->count();
            $ordersGrowth  = $ordersPrev > 0 ? round((($ordersThis - $ordersPrev) / $ordersPrev) * 100, 1) : ($ordersThis > 0 ? 100 : 0);
            $ordersPending = Order::where('status', 'Chờ xác nhận')->count();

            // ─── 3. Customers ────────────────────────────────────────────────
            $customersThis   = Customer::whereBetween('created_at', [$startDate, $endDate])->count();
            $customersPrev   = Customer::whereBetween('created_at', [$prevStart, $prevEnd])->count();
            $customersGrowth = $customersPrev > 0 ? round((($customersThis - $customersPrev) / $customersPrev) * 100, 1) : ($customersThis > 0 ? 100 : 0);

            // ─── 4. Inventory ────────────────────────────────────────────────
            $inventoryValue = DB::table('product_variants')
                ->whereNull('deleted_at')
                ->selectRaw('SUM(stock * price) as total')
                ->value('total') ?? 0;

            $lowStockItems = DB::table('product_variants')
                ->join('products', 'products.id', '=', 'product_variants.product_id')
                ->whereNull('product_variants.deleted_at')
                ->whereNull('products.deleted_at')
                ->where('product_variants.stock', '<', 5)
                ->select(
                    'products.id as product_id',
                    'products.name as product_name',
                    'products.image_url',
                    'product_variants.id as variant_id',
                    'product_variants.sku',
                    'product_variants.stock',
                    'product_variants.price'
                )
                ->orderBy('product_variants.stock', 'asc')
                ->limit(10)
                ->get();

            // ─── 5. Revenue Chart (by day) ───────────────────────────────────
            $revenueByDay = Order::select(
                    DB::raw('DATE(created_at) as date'),
                    DB::raw('SUM(grand_total) as total')
                )
                ->whereIn('status', $completedStatuses)
                ->whereBetween('created_at', [$startDate, $endDate])
                ->groupBy('date')
                ->orderBy('date')
                ->get()
                ->keyBy('date');

            $chartLabels = [];
            $chartSeries = [];
            $cursor = $startDate->copy()->startOfDay();
            while ($cursor->lte($endDate)) {
                $d = $cursor->format('Y-m-d');
                $chartLabels[] = $cursor->format('d/m');
                $chartSeries[] = (float) ($revenueByDay[$d]->total ?? 0);
                $cursor->addDay();
            }

            // ─── 6. Order Status Distribution ───────────────────────────────
            $statusDistribution = Order::select('status', DB::raw('count(*) as total'))
                ->whereBetween('created_at', [$startDate, $endDate])
                ->groupBy('status')
                ->pluck('total', 'status');

            // ─── 7. Top 5 Products ───────────────────────────────────────────
            $topProducts = DB::table('order_items')
                ->join('orders', 'orders.id', '=', 'order_items.order_id')
                ->join('products', 'products.id', '=', 'order_items.product_id')
                ->select(
                    'products.id',
                    'products.name',
                    'products.image_url',
                    DB::raw('SUM(order_items.quantity) as sold'),
                    DB::raw('SUM(order_items.price * order_items.quantity) as revenue')
                )
                ->whereNotIn('orders.status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
                ->whereBetween('orders.created_at', [$startDate, $endDate])
                ->groupBy('products.id', 'products.name', 'products.image_url')
                ->orderByDesc('sold')
                ->limit(5)
                ->get();

            // ─── 8. Top Staff ────────────────────────────────────────────────
            $topStaff = DB::table('orders')
                ->join('users', 'users.id', '=', 'orders.staff_id')
                ->select(
                    'users.id',
                    'users.name',
                    DB::raw('COUNT(orders.id) as orders_closed'),
                    DB::raw('SUM(orders.grand_total) as revenue')
                )
                ->whereNotNull('orders.staff_id')
                ->whereIn('orders.status', $completedStatuses)
                ->whereBetween('orders.created_at', [$startDate, $endDate])
                ->groupBy('users.id', 'users.name')
                ->orderByDesc('orders_closed')
                ->limit(5)
                ->get();

            // ─── 9. Recent Orders ────────────────────────────────────────────
            $recentOrders = Order::latest()->limit(8)
                ->get(['id', 'order_code', 'name', 'grand_total', 'status', 'payment_status', 'created_at']);

            return compact(
                'revenueThis', 'revenueGrowth',
                'ordersThis', 'ordersGrowth', 'ordersPending',
                'customersThis', 'customersGrowth',
                'inventoryValue', 'lowStockItems',
                'chartLabels', 'chartSeries',
                'statusDistribution', 'topProducts',
                'topStaff', 'recentOrders'
            );
        });

        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                'revenueThis'     => $data['revenueThis'],
                'revenueGrowth'   => $data['revenueGrowth'],
                'ordersThis'      => $data['ordersThis'],
                'ordersGrowth'    => $data['ordersGrowth'],
                'ordersPending'   => $data['ordersPending'],
                'customersThis'   => $data['customersThis'],
                'customersGrowth' => $data['customersGrowth'],
                'inventoryValue'  => $data['inventoryValue'],
            ],
            'chart' => [
                'labels' => $data['chartLabels'],
                'series' => $data['chartSeries'],
            ],
            'statusDistribution' => $data['statusDistribution'],
            'topProducts'        => $data['topProducts'],
            'topStaff'           => $data['topStaff'],
            'lowStockItems'      => $data['lowStockItems'],
            'recentOrders'       => $data['recentOrders'],
            'filters' => [
                'start_date' => request('start_date', Carbon::now()->subDays(29)->format('Y-m-d')),
                'end_date'   => request('end_date', Carbon::now()->format('Y-m-d')),
            ],
        ]);
    }
}
