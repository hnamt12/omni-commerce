<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ActionLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ActionLogController extends Controller
{
    /**
     * Hiển thị danh sách nhật ký hệ thống.
     * Dùng Eager Loading với select() để tối ưu N+1 Query.
     */
    public function index(Request $request)
    {
        $query = ActionLog::with([
            'user'     => fn ($q) => $q->select('id', 'name', 'email'),
            'customer' => fn ($q) => $q->select('id', 'name', 'email'),
        ]);

        // Lọc theo user_id nếu có
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->integer('user_id'));
        }

        // Lọc theo customer_id nếu có
        if ($request->filled('customer_id')) {
            $query->where('customer_id', $request->integer('customer_id'));
        }

        // Lọc theo action (created / updated / deleted / login / logout / updated_permissions) nếu có
        if ($request->filled('action')) {
            $query->where('action', $request->input('action'));
        }

        // Lọc theo loại đối tượng (model class) nếu có
        if ($request->filled('loggable_type')) {
            $query->where('loggable_type', $request->input('loggable_type'));
        }

        // Lọc theo khoảng ngày bắt đầu (date_from)
        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->input('date_from'));
        }

        // Lọc theo khoảng ngày kết thúc (date_to)
        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->input('date_to'));
        }

        // Kiểm tra xuất báo cáo kiểm toán CSV
        if ($request->input('export') === 'csv') {
            return $this->exportToCsv($query);
        }

        $logs = $query->latest()->paginate(20)->withQueryString();

        return Inertia::render('Admin/ActionLogs/Index', [
            'logs'    => $logs,
            'filters' => $request->only(['user_id', 'customer_id', 'action', 'loggable_type', 'date_from', 'date_to']),
        ]);
    }

    /**
     * Xuất dữ liệu nhật ký hệ thống dạng CSV có hỗ trợ tiếng Việt có dấu (UTF-8 BOM).
     */
    private function exportToCsv($query)
    {
        $headers = [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => 'attachment; filename="action-logs-' . now()->format('Y-m-d') . '.csv"',
            'Pragma' => 'no-cache',
            'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
            'Expires' => '0',
        ];

        $callback = function () use ($query) {
            $file = fopen('php://output', 'w');
            
            // Thêm UTF-8 BOM cho Excel mở tiếng Việt chuẩn không lỗi font
            fprintf($file, chr(0xEF).chr(0xBB).chr(0xBF));

            // Tiêu đề cột
            fputcsv($file, [
                'ID',
                'Thời gian',
                'Người thực hiện (Admin/Staff)',
                'Email Người thực hiện',
                'Khách hàng liên quan',
                'Email Khách hàng',
                'Hành động',
                'Loại đối tượng',
                'ID đối tượng',
                'Dữ liệu cũ',
                'Dữ liệu mới',
                'Địa chỉ IP',
                'User Agent'
            ]);

            // Dùng chunk để tránh quá tải bộ nhớ RAM
            $query->orderBy('id', 'desc')->chunk(500, function ($logs) use ($file) {
                foreach ($logs as $log) {
                    fputcsv($file, [
                        $log->id,
                        $log->created_at->format('Y-m-d H:i:s'),
                        $log->user ? $log->user->name : 'N/A',
                        $log->user ? $log->user->email : 'N/A',
                        $log->customer ? $log->customer->name : 'N/A',
                        $log->customer ? $log->customer->email : 'N/A',
                        $this->translateAction($log->action),
                        $this->translateLoggableType($log->loggable_type),
                        $log->loggable_id,
                        json_encode($log->old_values, JSON_UNESCAPED_UNICODE),
                        json_encode($log->new_values, JSON_UNESCAPED_UNICODE),
                        $log->ip_address,
                        $log->user_agent,
                    ]);
                }
            });

            fclose($file);
        };

        return response()->stream($callback, 200, $headers);
    }

    /**
     * Dịch các hành động sang tiếng Việt dễ đọc cho kiểm toán.
     */
    private function translateAction(string $action): string
    {
        return match ($action) {
            'created' => 'Thêm mới',
            'updated' => 'Cập nhật',
            'deleted' => 'Xoá',
            'login' => 'Đăng nhập',
            'logout' => 'Đăng xuất',
            'updated_permissions' => 'Thay đổi quyền hạn',
            default => $action,
        };
    }

    /**
     * Định dạng loại đối tượng thân thiện với kiểm toán viên.
     */
    private function translateLoggableType(string $type): string
    {
        $class = class_basename($type);
        return match ($class) {
            'User' => 'Nhân sự quản trị',
            'Customer' => 'Khách hàng',
            'Order' => 'Đơn hàng',
            'Product' => 'Sản phẩm',
            'ProductVariant' => 'Biến thể sản phẩm',
            'Voucher' => 'Mã giảm giá (Voucher)',
            'PaymentMethod' => 'Phương thức thanh toán',
            'Supplier' => 'Nhà cung cấp',
            'FlashSale' => 'Flash Sale',
            'Setting' => 'Cấu hình hệ thống',
            default => $class,
        };
    }
}
