<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        
        // 1. THÊM ĐOẠN NÀY ĐỂ KÍCH HOẠT INERTIA PROPS (Bắt lỗi Vue)
        $middleware->web(append: [
            \App\Http\Middleware\HandleInertiaRequests::class,
            \Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets::class,
        ]);

        // 2. GIỮ NGUYÊN ĐOẠN ĐIỀU HƯỚNG BẢO VỆ NÀY
        $middleware->redirectTo(
            guests: fn (Request $request) => $request->is('admin/*') ? route('admin.login') : route('client.login')
        );
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Handle 419 CSRF / session timeout
        $exceptions->render(function (\Illuminate\Session\TokenMismatchException $e, Request $request) {
            $loginUrl = $request->is('admin/*') ? route('admin.login') : route('login');
            return redirect()->guest($loginUrl)
                ->with('error', 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
        });
    })->create();