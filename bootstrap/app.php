<?php

use App\Http\Middleware\AdminPermission;
use App\Http\Middleware\HandleInertiaRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets;
use Illuminate\Http\Request;
use Illuminate\Session\TokenMismatchException;
use Illuminate\Support\Facades\Log;
use Spatie\Permission\Middleware\PermissionMiddleware;
use Spatie\Permission\Middleware\RoleMiddleware;
use Spatie\Permission\Middleware\RoleOrPermissionMiddleware;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        channels: __DIR__.'/../routes/channels.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {

        // ─── 1. Inertia & Asset Preloading ───────────────────────────────────
        $middleware->web(append: [
            HandleInertiaRequests::class,
            AddLinkHeadersForPreloadedAssets::class,
        ]);

        // ─── 2. Đăng ký Middleware Alias ─────────────────────────────────────
        // admin.permission → Middleware tùy chỉnh hỗ trợ superadmin bypass + Inertia 403
        // role / permission / role_or_permission → Spatie built-in (dùng trực tiếp nếu cần)
        $middleware->alias([
            'admin.permission' => AdminPermission::class,
            'role' => RoleMiddleware::class,
            'permission' => PermissionMiddleware::class,
            'role_or_permission' => RoleOrPermissionMiddleware::class,
        ]);

        // ─── 3. Auth Redirect (Điều hướng tùy ngữ cảnh URL) ─────────────────
        $middleware->redirectTo(
            guests: fn (Request $request) => $request->is('admin/*') ? route('admin.login') : route('client.login')
        );
    })
    ->withExceptions(function (Exceptions $exceptions) {

        // ─── 4. Handle 403 Forbidden (Permission denied) ─────────────────────
        $exceptions->render(function (AccessDeniedHttpException $e, Request $request) {
            $message = $e->getMessage() ?: 'Bạn không có quyền truy cập chức năng này.';

            if ($request->header('X-Inertia')) {
                return inertia('Errors/Forbidden', [
                    'status' => 403,
                    'message' => $message,
                ])->toResponse($request)->setStatusCode(403);
            }

            if ($request->wantsJson() || $request->expectsJson()) {
                return response()->json(['success' => false, 'message' => $message, 'code' => 403], 403);
            }

            return redirect()->route('dashboard')->with('error', $message);
        });

        // ─── 5. Handle 404 Not Found ──────────────────────────────────────────
        $exceptions->render(function (NotFoundHttpException $e, Request $request) {
            if ($request->header('X-Inertia')) {
                return inertia('Errors/Index', [
                    'status' => 404,
                    'message' => 'Trang bạn tìm không tồn tại.',
                ])->toResponse($request)->setStatusCode(404);
            }
        });

        // ─── 6. Handle Production Errors 500 ─────────────────────────────────
        $exceptions->render(function (Throwable $e, Request $request) {
            if (! config('app.debug')) {
                Log::error('PRODUCTION ERROR: '.$e->getMessage(), [
                    'trace' => $e->getTraceAsString(),
                    'url' => $request->fullUrl(),
                    'user' => auth()->id(),
                ]);

                if ($request->header('X-Inertia') || $request->wantsJson()) {
                    return inertia('Errors/Index', [
                        'status' => 500,
                        'message' => 'Hệ thống đang gặp sự cố, vui lòng thử lại sau.',
                    ])->toResponse($request)->setStatusCode(500);
                }
            }
        });

        // ─── 7. Handle 419 CSRF / Session Timeout ────────────────────────────
        $exceptions->render(function (TokenMismatchException $e, Request $request) {
            $loginUrl = $request->is('admin/*') ? route('admin.login') : route('login');

            return redirect()->guest($loginUrl)
                ->with('error', 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
        });
    })->create();
