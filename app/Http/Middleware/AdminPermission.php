<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

/**
 * AdminPermission Middleware
 *
 * Kiểm tra quyền truy cập của Admin/Staff vào các route được bảo vệ.
 *
 * Logic phân cấp:
 *   1. Superadmin (role = 'superadmin') → Bypass toàn bộ, truy cập mọi thứ.
 *   2. Admin (role = 'admin')           → Bypass toàn bộ, truy cập mọi thứ.
 *   3. Staff (role = 'staff')           → Phải có permission cụ thể được yêu cầu.
 *
 * Xử lý 403 Inertia-aware:
 *   - Nếu là Inertia request → Render trang lỗi 403 Vue.
 *   - Nếu là JSON API      → Trả về JSON 403.
 *   - Nếu là HTML thường   → Redirect về dashboard với flash error.
 */
class AdminPermission
{
    public function handle(Request $request, Closure $next, string ...$permissions): Response
    {
        $user = Auth::guard('web')->user();

        // Không xác thực → Đã được route middleware auth:web bắt trước rồi
        // Nhưng defensive check ở đây để chắc chắn
        if (!$user) {
            return $this->forbiddenResponse($request, 401, 'Bạn cần đăng nhập để truy cập trang này.');
        }

        // ─── SUPERADMIN & ADMIN: Bypass toàn bộ permission check ──────────────
        // Sử dụng hasAnyRole để check một lần, tránh N+1
        if ($user->hasAnyRole(['superadmin', 'admin'])) {
            return $next($request);
        }

        // ─── STAFF: Phải có ÍT NHẤT 1 trong các permissions được yêu cầu ──────
        if (empty($permissions)) {
            // Middleware được gọi không có permission param → cho phép nếu đã xác thực
            return $next($request);
        }

        // Dùng method của Spatie để check hiệu quả (sử dụng cache nội bộ)
        if ($user->hasAnyPermission($permissions)) {
            return $next($request);
        }

        // ─── Không có quyền → 403 ─────────────────────────────────────────────
        $missingPermissions = implode(', ', $permissions);
        \Illuminate\Support\Facades\Log::warning('[AdminPermission] Access denied', [
            'user_id'    => $user->id,
            'user_name'  => $user->name,
            'route'      => $request->path(),
            'method'     => $request->method(),
            'required'   => $permissions,
            'ip'         => $request->ip(),
        ]);

        return $this->forbiddenResponse(
            $request,
            403,
            'Bạn không có quyền truy cập chức năng này. Vui lòng liên hệ quản trị viên.'
        );
    }

    /**
     * Tạo response 403 phù hợp với loại request (Inertia / JSON / HTML).
     */
    private function forbiddenResponse(Request $request, int $status, string $message): Response
    {
        // Inertia request (Vue SPA) → Render trang lỗi Vue
        if ($request->header('X-Inertia')) {
            return inertia('Errors/Forbidden', [
                'status'  => $status,
                'message' => $message,
            ])->toResponse($request)->setStatusCode($status);
        }

        // API / AJAX JSON request
        if ($request->wantsJson() || $request->expectsJson()) {
            return response()->json([
                'success' => false,
                'message' => $message,
                'code'    => $status,
            ], $status);
        }

        // Fallback: redirect về dashboard với flash error
        return redirect()->route('dashboard')->with('error', $message);
    }
}
