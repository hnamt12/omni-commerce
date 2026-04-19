<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use App\Models\Order;
use App\Models\OrderStatusHistory;
use App\Services\OrderService;

class OrderController extends Controller
{
    protected $orderService;

    public function __construct(OrderService $orderService)
    {
        $this->orderService = $orderService;
    }

    // 9 trạng thái tiếng Việt chuẩn hóa
    const STATUSES = [
        'Chờ xác nhận',
        'Đã xác nhận',
        'Đang chuẩn bị hàng',
        'Đang giao hàng',
        'Đã hoàn thành',
        'Đã hủy',
        'Giao hàng thất bại',
        'Trả hàng/Hoàn tiền',
    ];

    const FINAL_STATUSES = ['Đã hoàn thành', 'Đã hủy', 'Giao hàng thất bại', 'Trả hàng/Hoàn tiền'];

    public function index(Request $request)
    {
        $search     = $request->input('search');
        $statusSlug = $request->input('status', 'tat-ca');

        // Ánh xạ Slug (URL đẹp/SEO) -> Tiếng Việt (DB)
        $statusMap = [
            'tat-ca'             => 'Tất cả',
            'cho-xac-nhan'       => 'Chờ xác nhận',
            'da-xac-nhan'        => 'Đã xác nhận',
            'dang-chuan-bi-hang' => 'Đang chuẩn bị hàng',
            'dang-giao-hang'     => 'Đang giao hàng',
            'da-hoan-thanh'      => 'Đã hoàn thành',
            'da-huy'             => 'Đã hủy',
            'giao-hang-that-bai' => 'Giao hàng thất bại',
            'tra-hang-hoan-tien' => 'Trả hàng/Hoàn tiền',
        ];

        $currentStatus = $statusMap[$statusSlug] ?? 'Tất cả';

        // 1. Đếm toàn bộ trạng thái bằng 1 query GROUP BY, map kết quả về slug
        $rawCounts = Order::select('status', DB::raw('count(*) as total'))
            ->groupBy('status')
            ->pluck('total', 'status')
            ->toArray();

        $statusCounts = [];
        $totalAll     = 0;
        foreach ($statusMap as $slug => $viStatus) {
            if ($slug !== 'tat-ca') {
                $count                = $rawCounts[$viStatus] ?? 0;
                $statusCounts[$slug] = $count;
                $totalAll            += $count;
            }
        }
        $statusCounts['tat-ca'] = $totalAll;

        // 2. Query danh sách đơn hàng cho tab hiện tại
        $query = Order::with(['items.product', 'items.variant', 'customer'])
            ->orderBy('created_at', 'desc');

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('order_code', 'like', "%{$search}%")
                  ->orWhere('name', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        if ($currentStatus !== 'Tất cả') {
            $query->where('status', $currentStatus);
        }

        $orders = $query->paginate(10)->withQueryString();

        return Inertia::render('Admin/Orders/Index', [
            'orders'       => $orders,
            'statusCounts' => $statusCounts,
            'statusMap'    => $statusMap,   // Để Vue build tabs
            'filters'      => [
                'search' => $search,
                'status' => $statusSlug,    // Trả về slug cho URL
            ],
        ]);
    }

    public function create()
    {
        $variants = \App\Models\ProductVariant::with(['product', 'attributeValues.value', 'attributeValues.attribute'])
            ->where('stock', '>', 0)
            ->get();

        return Inertia::render('Admin/Orders/Create', [
            'variants' => $variants,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'           => 'required|string|max:255',
            'phone'          => 'required|string|max:20',
            'address'        => 'required|string',
            'payment_method' => 'required|string',
            'cart'           => 'required|array|min:1',
            'shipping_fee'   => 'nullable|numeric|min:0',
            'discount_amount' => 'nullable|numeric|min:0',
        ]);

        try {
            DB::beginTransaction();

            $subtotal        = collect($request->cart)->sum(fn($item) => $item['price'] * $item['quantity']);
            $shipping_fee    = $request->shipping_fee ?? 0;
            $discount_amount = $request->discount_amount ?? 0;
            $grand_total     = $subtotal + $shipping_fee - $discount_amount;

            $orderCode = 'POS-' . strtoupper(\Illuminate\Support\Str::random(6));

            $order = Order::create([
                'order_code'     => $orderCode,
                'name'           => $request->name,
                'phone'          => $request->phone,
                'email'          => $request->email,
                'address'        => $request->address,
                'subtotal'       => $subtotal,
                'shipping_fee'   => $shipping_fee,
                'discount_amount' => $discount_amount,
                'grand_total'    => $grand_total,
                'payment_method' => $request->payment_method,
                'payment_status' => 'unpaid',
                'status'         => 'Đã xác nhận',
                'staff_id'       => Auth::id(),
            ]);

            foreach ($request->cart as $item) {
                $productName = $item['product']['name'] ?? 'Unknown';
                if (is_array($productName)) {
                    $productName = collect($productName)->first() ?? 'Unknown';
                }

                \App\Models\OrderItem::create([
                    'order_id'   => $order->id,
                    'product_id' => $item['product_id'],
                    'variant_id' => $item['id'],
                    'name'       => $productName,
                    'price'      => $item['price'],
                    'quantity'   => $item['quantity'],
                    'total_price' => $item['price'] * $item['quantity'],
                ]);

                \App\Models\ProductVariant::where('id', $item['id'])->decrement('stock', $item['quantity']);
            }

            OrderStatusHistory::create([
                'order_id'           => $order->id,
                'old_status'         => null,
                'new_status'         => 'Đã xác nhận',
                'changed_by_user_id' => Auth::id(),
                'note'               => 'Đơn hàng tạo từ POS',
            ]);

            DB::commit();
            return redirect()->route('admin.orders.index')->with('success', 'Tạo đơn hàng POS thành công!');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Lỗi: ' . $e->getMessage());
        }
    }

    public function show($id)
    {
        $order = Order::with([
            'items.product',
            'items.variant.attributeValues.attribute',
            'items.variant.attributeValues.value',
            'customer',
            'staff',
            'shippingVoucher',
            'statusHistories.changedByUser',
        ])->findOrFail($id);

        return Inertia::render('Admin/Orders/Show', [
            'order'    => $order,
            'statuses' => self::STATUSES,
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|string',
        ]);

        try {
            // Nếu là hành động Hủy đơn -> Chuyển thẳng cho Service xử lý an toàn tuyệt đối
            if ($request->status === 'Đã hủy') {
                $this->orderService->cancelOrder($id, 'admin', 'Admin hủy đơn qua hệ thống');
                return back()->with('success', 'Đã hủy đơn hàng, hoàn kho và xử lý hoàn tiền thành công.');
            }

            // Xử lý các trạng thái tịnh tiến bình thường (Đóng gói, Giao hàng...)
            DB::beginTransaction();
            $order = Order::lockForUpdate()->findOrFail($id);
            $oldStatus = $order->status;
            $newStatus = $request->status;

            if ($oldStatus === $newStatus) {
                DB::rollBack();
                return back()->withErrors(['error' => 'Trạng thái này đã được cập nhật trước đó!']);
            }

            // Logic cập nhật thanh toán khi giao thành công
            if ($newStatus === 'Đã hoàn thành' && $order->payment_status === 'unpaid') {
                $order->payment_status = 'paid';
                $order->payment_date   = now();
            } elseif ($newStatus === 'Giao hàng thất bại' && $order->payment_status === 'unpaid') {
                $order->payment_status = 'failed';
            }

            $order->status   = $newStatus;
            $order->staff_id = Auth::id();
            $order->save();

            OrderStatusHistory::create([
                'order_id'           => $order->id,
                'old_status'         => $oldStatus,
                'new_status'         => $newStatus,
                'changed_by_user_id' => Auth::id(),
                'note'               => 'Cập nhật trạng thái',
            ]);

            DB::commit();
            return back()->with('success', "Đã chuyển đơn hàng sang: $newStatus");

        } catch (\Exception $e) {
            DB::rollBack();
            \Illuminate\Support\Facades\Log::error("UPDATE_STATUS_ERROR: " . $e->getMessage());
            return back()->withErrors(['error' => 'Lỗi cập nhật: ' . $e->getMessage()]);
        }
    }

    public function export()
    {
        return \Maatwebsite\Excel\Facades\Excel::download(
            new \App\Exports\OrdersExport(),
            'don-hang-' . now()->format('Ymd_His') . '.xlsx'
        );
    }

    public function print($id)
    {
        $order = Order::with([
            'items.product',
            'items.variant.attributeValues.attribute',
            'items.variant.attributeValues.value',
        ])->findOrFail($id);

        return view('admin.orders.print', compact('order'));
    }

    public function destroy($id)
    {
        $order = Order::findOrFail($id);
        // Chỉ cho xóa đơn đã hủy
        if (!in_array($order->status, ['Đã hủy', 'Trả hàng/Hoàn tiền'])) {
            return redirect()->back()->with('error', 'Chỉ có thể xóa đơn hàng đã hủy hoặc hoàn tiền.');
        }
        $order->delete();
        return redirect()->route('admin.orders.index')->with('success', 'Đã xóa đơn hàng.');
    }
}
