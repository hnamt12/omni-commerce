<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\OrderCancelRequest;
use App\Services\OrderService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;

class CancelRequestController extends Controller
{
    protected $orderService;

    public function __construct(OrderService $orderService)
    {
        $this->orderService = $orderService;
    }

    public function index(Request $request)
    {
        $status = $request->input('status', 'pending');

        $requests = OrderCancelRequest::with(['order', 'customer'])
            ->where('status', $status)
            ->orderBy('created_at', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/CancelRequests/Index', [
            'requests' => $requests,
            'filters' => ['status' => $status],
        ]);
    }

    public function approve(Request $request, $id)
    {
        $cancelRequest = OrderCancelRequest::findOrFail($id);

        if ($cancelRequest->status !== 'pending') {
            return back()->withErrors(['error' => 'Yêu cầu này đã được xử lý.']);
        }

        try {
            DB::beginTransaction();

            $cancelRequest->status = 'approved';
            $cancelRequest->save();

            // Gọi OrderService để hủy đơn an toàn
            $this->orderService->cancelOrder($cancelRequest->order_id, 'admin', 'Duyệt yêu cầu hủy: '.$cancelRequest->reason);

            DB::commit();

            return back()->with('success', 'Đã duyệt yêu cầu và hủy đơn hàng thành công!');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('CANCEL_REQUEST_APPROVE_ERROR: '.$e->getMessage());

            return back()->withErrors(['error' => 'Lỗi khi hủy đơn hàng: '.$e->getMessage()]);
        }
    }

    public function reject(Request $request, $id)
    {
        $cancelRequest = OrderCancelRequest::findOrFail($id);

        if ($cancelRequest->status !== 'pending') {
            return back()->withErrors(['error' => 'Yêu cầu này đã được xử lý.']);
        }

        $cancelRequest->status = 'rejected';
        $cancelRequest->save();

        return back()->with('success', 'Đã từ chối yêu cầu hủy đơn.');
    }
}
