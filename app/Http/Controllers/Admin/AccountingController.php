<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Transaction;
use App\Models\VoucherUsage;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AccountingController extends Controller
{
    /**
     * Helper to parse date filters.
     */
    private function getFilterDates(Request $request): array
    {
        $startDate = $request->input('start_date')
            ? Carbon::parse($request->input('start_date'))->startOfDay()
            : Carbon::now()->subDays(29)->startOfDay();

        $endDate = $request->input('end_date')
            ? Carbon::parse($request->input('end_date'))->endOfDay()
            : Carbon::now()->endOfDay();

        return [$startDate, $endDate];
    }

    /**
     * 1. Transactions - Danh sách lịch sử giao dịch thanh toán.
     */
    public function transactions(Request $request)
    {
        [$startDate, $endDate] = $this->getFilterDates($request);

        $query = Transaction::with([
            'order' => fn ($q) => $q->select('id', 'order_code', 'grand_total', 'status'),
            'user' => fn ($q) => $q->select('id', 'name', 'email'),
        ])->whereBetween('created_at', [$startDate, $endDate]);

        if ($request->filled('payment_method')) {
            $query->where('payment_method', $request->input('payment_method'));
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('transaction_code', 'like', "%{$search}%")
                    ->orWhereHas('order', function ($oq) use ($search) {
                        $oq->where('order_code', 'like', "%{$search}%");
                    });
            });
        }

        $transactions = $query->latest()->paginate(20)->withQueryString();

        // Thống kê nhanh
        $stats = [
            'total_amount' => (float) Transaction::whereBetween('created_at', [$startDate, $endDate])->where('status', 'success')->sum('amount'),
            'success_count' => Transaction::whereBetween('created_at', [$startDate, $endDate])->where('status', 'success')->count(),
            'pending_count' => Transaction::whereBetween('created_at', [$startDate, $endDate])->where('status', 'pending')->count(),
            'failed_count' => Transaction::whereBetween('created_at', [$startDate, $endDate])->where('status', 'failed')->count(),
        ];

        return Inertia::render('Admin/Accounting/Transactions', [
            'transactions' => $transactions,
            'stats' => $stats,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'payment_method' => $request->input('payment_method', ''),
                'status' => $request->input('status', ''),
                'search' => $request->input('search', ''),
            ],
        ]);
    }

    /**
     * 2. Voucher Usage - Danh sách Voucher đã sử dụng.
     */
    public function voucherUsage(Request $request)
    {
        [$startDate, $endDate] = $this->getFilterDates($request);

        $query = VoucherUsage::with([
            'customer' => fn ($q) => $q->select('id', 'name', 'email'),
            'voucher' => fn ($q) => $q->select('id', 'name', 'code', 'type', 'discount_percentage', 'discount_amount_fixed'),
            'order' => fn ($q) => $q->select('id', 'order_code', 'grand_total', 'discount_amount', 'status'),
        ])->whereBetween('used_at', [$startDate, $endDate]);

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->whereHas('voucher', function ($q) use ($search) {
                $q->where('code', 'like', "%{$search}%")
                    ->orWhere('name', 'like', "%{$search}%");
            });
        }

        $usages = $query->latest('used_at')->paginate(20)->withQueryString();

        // Tổng giá trị discount & số lượng đã dùng trong kỳ
        $summary = [
            'total_used' => VoucherUsage::whereBetween('used_at', [$startDate, $endDate])->count(),
            'total_discount' => (float) Order::whereBetween('created_at', [$startDate, $endDate])
                ->whereNotNull('voucher_id')
                ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
                ->sum('discount_amount'),
        ];

        return Inertia::render('Admin/Accounting/VoucherUsage', [
            'usages' => $usages,
            'summary' => $summary,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'search' => $request->input('search', ''),
            ],
        ]);
    }

    /**
     * 3. Debt Report - Báo cáo công nợ (COD chưa thu tiền).
     */
    public function debtReport(Request $request)
    {
        [$startDate, $endDate] = $this->getFilterDates($request);

        // Đơn COD và payment_status = unpaid
        $query = Order::with(['customer' => fn ($q) => $q->select('id', 'name', 'phone')])
            ->where('payment_method', 'COD')
            ->where('payment_status', 'unpaid')
            ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
            ->whereBetween('created_at', [$startDate, $endDate]);

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('order_code', 'like', "%{$search}%")
                    ->orWhere('name', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        $orders = $query->latest()->paginate(20)->withQueryString();

        // Thống kê công nợ COD
        $stats = [
            'total_debt' => (float) Order::where('payment_method', 'COD')
                ->where('payment_status', 'unpaid')
                ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
                ->whereBetween('created_at', [$startDate, $endDate])
                ->sum('grand_total'),
            'total_orders' => Order::where('payment_method', 'COD')
                ->where('payment_status', 'unpaid')
                ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
                ->whereBetween('created_at', [$startDate, $endDate])
                ->count(),
            'delivered_unpaid' => Order::where('payment_method', 'COD')
                ->where('payment_status', 'unpaid')
                ->where('status', 'Đã hoàn thành')
                ->whereBetween('created_at', [$startDate, $endDate])
                ->sum('grand_total'),
        ];

        return Inertia::render('Admin/Accounting/DebtReport', [
            'orders' => $orders,
            'stats' => $stats,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'search' => $request->input('search', ''),
                'status' => $request->input('status', ''),
            ],
        ]);
    }

    /**
     * 4. Payment Reconciliation - Sao kê theo phương thức thanh toán.
     */
    public function paymentReconciliation(Request $request)
    {
        [$startDate, $endDate] = $this->getFilterDates($request);

        // Thống kê doanh thu theo phương thức thanh toán
        $reconciliation = Order::select('payment_method',
            DB::raw('COUNT(*) as total_orders'),
            DB::raw('SUM(CASE WHEN payment_status = "paid" THEN grand_total ELSE 0 END) as paid_amount'),
            DB::raw('SUM(CASE WHEN payment_status = "unpaid" THEN grand_total ELSE 0 END) as unpaid_amount'),
            DB::raw('SUM(grand_total) as total_amount')
        )
            ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
            ->whereBetween('created_at', [$startDate, $endDate])
            ->groupBy('payment_method')
            ->get();

        // Lấy chi tiết đơn hàng để hiển thị
        $ordersQuery = Order::with(['customer' => fn ($q) => $q->select('id', 'name')])
            ->whereNotIn('status', ['Đã hủy', 'Trả hàng/Hoàn tiền'])
            ->whereBetween('created_at', [$startDate, $endDate]);

        if ($request->filled('payment_method')) {
            $ordersQuery->where('payment_method', $request->input('payment_method'));
        }

        if ($request->filled('payment_status')) {
            $ordersQuery->where('payment_status', $request->input('payment_status'));
        }

        $orders = $ordersQuery->latest()->paginate(15)->withQueryString();

        return Inertia::render('Admin/Accounting/PaymentReconciliation', [
            'reconciliation' => $reconciliation,
            'orders' => $orders,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'payment_method' => $request->input('payment_method', ''),
                'payment_status' => $request->input('payment_status', ''),
            ],
        ]);
    }

    /**
     * 5. Inventory Valuation - Đối soát tồn kho theo giá trị.
     */
    public function inventoryValuation(Request $request)
    {
        [$startDate, $endDate] = $this->getFilterDates($request);

        // Lấy lịch sử biến động kho và tính giá trị dựa trên giá của product variant
        $inventoryQuery = DB::table('inventory_histories')
            ->join('product_variants', 'product_variants.id', '=', 'inventory_histories.product_variant_id')
            ->join('products', 'products.id', '=', 'product_variants.product_id')
            ->whereBetween('inventory_histories.created_at', [$startDate, $endDate])
            ->select(
                'products.name as product_name',
                'product_variants.sku',
                'product_variants.price',
                'inventory_histories.action_type',
                DB::raw('SUM(inventory_histories.quantity_change) as total_qty_change'),
                DB::raw('COUNT(inventory_histories.id) as trans_count')
            )
            ->groupBy('products.name', 'product_variants.sku', 'product_variants.price', 'inventory_histories.action_type');

        $rawHistory = $inventoryQuery->get();

        // Process dữ liệu để group theo sản phẩm SKU
        $valuationData = [];
        foreach ($rawHistory as $row) {
            $sku = $row->sku;
            if (! isset($valuationData[$sku])) {
                $valuationData[$sku] = [
                    'product_name' => $row->product_name,
                    'sku' => $sku,
                    'price' => (float) $row->price,
                    'imported_qty' => 0,
                    'imported_value' => 0.0,
                    'exported_qty' => 0,
                    'exported_value' => 0.0,
                    'adjusted_qty' => 0,
                    'adjusted_value' => 0.0,
                ];
            }

            $qty = (int) $row->total_qty_change;
            $val = abs($qty) * (float) $row->price;

            if ($row->action_type === 'import') {
                $valuationData[$sku]['imported_qty'] += $qty;
                $valuationData[$sku]['imported_value'] += $val;
            } elseif ($row->action_type === 'export') {
                $valuationData[$sku]['exported_qty'] += abs($qty);
                $valuationData[$sku]['exported_value'] += $val;
            } else {
                $valuationData[$sku]['adjusted_qty'] += $qty;
                $valuationData[$sku]['adjusted_value'] += ($qty * (float) $row->price);
            }
        }

        // Paginate manually vì chúng ta đang xử lý group bằng Collection
        $valuationCollection = collect(array_values($valuationData));
        $page = $request->integer('page', 1);
        $perPage = 15;
        $paginatedValuation = new LengthAwarePaginator(
            $valuationCollection->forPage($page, $perPage)->values(),
            $valuationCollection->count(),
            $perPage,
            $page,
            ['path' => $request->url(), 'query' => $request->query()]
        );

        // Thống kê tổng hợp kho trong kỳ
        $totals = [
            'total_imported_value' => (float) $valuationCollection->sum('imported_value'),
            'total_exported_value' => (float) $valuationCollection->sum('exported_value'),
            'total_adjusted_value' => (float) $valuationCollection->sum('adjusted_value'),
        ];

        return Inertia::render('Admin/Accounting/InventoryValuation', [
            'valuation' => $paginatedValuation,
            'totals' => $totals,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
            ],
        ]);
    }
}
