<?php

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Client\AuthController as ClientAuthController;
use App\Http\Controllers\Admin\AccountingController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// ═══════════════════════════════════════════════════════════════════════
// ADMIN ROUTES
// ═══════════════════════════════════════════════════════════════════════
Route::prefix('admin')->group(function () {

    // ─── Guest-only (Login) ───────────────────────────────────────────
    Route::middleware('guest:web')->group(function () {
        Route::get('/login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
        Route::post('/login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
    });

    // ─── Authenticated Admin/Staff ────────────────────────────────────
    Route::middleware('auth:web')->group(function () {

        // Logout — mọi user đã đăng nhập đều có thể logout
        Route::post('/logout', [AdminAuthController::class, 'logout'])->name('admin.logout');

        // Admin Profile
        Route::get('/profile', [\App\Http\Controllers\Admin\ProfileController::class, 'index'])->name('admin.profile.index');
        Route::post('/profile', [\App\Http\Controllers\Admin\ProfileController::class, 'update'])->name('admin.profile.update');
        Route::post('/profile/password', [\App\Http\Controllers\Admin\ProfileController::class, 'updatePassword'])->name('admin.profile.password');

        // Chat — mọi nhân viên xác thực đều được dùng chat nội bộ
        Route::prefix('chat')->group(function () {
            Route::get('/', fn () => Inertia::render('Admin/Chat/Index'))->name('admin.chat.index');
            Route::get('/unread-notifications', [\App\Http\Controllers\ChatController::class, 'getUnreadNotifications'])->name('admin.chat.unread-notifications');
            Route::get('/conversations', [\App\Http\Controllers\ChatController::class, 'index'])->name('admin.chat.conversations');
            Route::get('/conversations/{id}/messages', [\App\Http\Controllers\ChatController::class, 'getMessages'])->name('admin.chat.messages');
            Route::post('/send', [\App\Http\Controllers\ChatController::class, 'sendMessage'])->name('admin.chat.send');
        });

        // Notifications — mọi nhân viên xác thực đều xem được thông báo của mình
        Route::prefix('notifications')->group(function () {
            Route::get('/', [\App\Http\Controllers\Admin\NotificationController::class, 'index'])->name('admin.notifications.index');
            Route::post('/{id}/mark-as-read', [\App\Http\Controllers\Admin\NotificationController::class, 'markAsRead'])->name('admin.notifications.mark-as-read');
            Route::post('/mark-all-as-read', [\App\Http\Controllers\Admin\NotificationController::class, 'markAllAsRead'])->name('admin.notifications.mark-all-as-read');
        });

        // ─── Nhóm 1: Sale & CSKH ─────────────────────────────────────
        // Permission: view_orders, update_orders, manage_cancel_requests
        Route::middleware('admin.permission:view_orders')->group(function () {
            Route::get('orders/{id}/print', [\App\Http\Controllers\Admin\OrderController::class, 'print'])->name('admin.orders.print');
            Route::resource('orders', \App\Http\Controllers\Admin\OrderController::class)->only(['index', 'show', 'create', 'store'])->names('admin.orders');
        });

        Route::middleware('admin.permission:view_orders,export_reports')->group(function () {
            Route::get('orders/export', [\App\Http\Controllers\Admin\OrderController::class, 'export'])->name('admin.orders.export');
        });

        Route::middleware('admin.permission:update_orders')->group(function () {
            Route::put('orders/{id}/update-status', [\App\Http\Controllers\Admin\OrderController::class, 'updateStatus'])->name('admin.orders.updateStatus');
            Route::delete('orders/{order}', [\App\Http\Controllers\Admin\OrderController::class, 'destroy'])->name('admin.orders.destroy');
        });

        Route::middleware('admin.permission:manage_cancel_requests')->group(function () {
            Route::resource('cancel-requests', \App\Http\Controllers\Admin\CancelRequestController::class)->only(['index'])->names('admin.cancel-requests');
            Route::post('cancel-requests/{id}/approve', [\App\Http\Controllers\Admin\CancelRequestController::class, 'approve'])->name('admin.cancel-requests.approve');
            Route::post('cancel-requests/{id}/reject', [\App\Http\Controllers\Admin\CancelRequestController::class, 'reject'])->name('admin.cancel-requests.reject');
        });

        // ─── Nhóm 2: Marketing & Content ─────────────────────────────
        Route::middleware('admin.permission:manage_banners')->group(function () {
            Route::post('banners/reorder', [\App\Http\Controllers\Admin\BannerController::class, 'reorder'])->name('admin.banners.reorder');
            Route::resource('banners', \App\Http\Controllers\Admin\BannerController::class)->names('admin.banners');
            Route::resource('banner-locations', \App\Http\Controllers\Admin\BannerLocationController::class)->except(['show', 'create', 'edit'])->names('admin.banner-locations');
        });

        Route::middleware('admin.permission:manage_vouchers')->group(function () {
            Route::resource('vouchers', \App\Http\Controllers\Admin\VoucherController::class)->names('admin.vouchers');
        });

        Route::middleware('admin.permission:manage_flash_sales')->group(function () {
            Route::get('flash-sales/search-products', [\App\Http\Controllers\Admin\FlashSaleController::class, 'searchProducts'])->name('admin.flash-sales.search-products');
            Route::get('flash-sales/product/{id}/variants', [\App\Http\Controllers\Admin\FlashSaleController::class, 'getProductVariants'])->name('admin.flash-sales.product-variants');
            Route::post('flash-sales/{id}/add-products', [\App\Http\Controllers\Admin\FlashSaleController::class, 'addMultipleProducts'])->name('admin.flash-sales.add-product');
            Route::delete('flash-sales/items/{itemId}', [\App\Http\Controllers\Admin\FlashSaleController::class, 'removeProduct'])->name('admin.flash-sales.remove-product');
            Route::resource('flash-sales', \App\Http\Controllers\Admin\FlashSaleController::class)->names('admin.flash-sales');
        });

        Route::middleware('admin.permission:manage_posts')->group(function () {
            Route::resource('posts', \App\Http\Controllers\Admin\PostController::class)->except(['show'])->names('admin.posts');
        });

        // ─── Nhóm 3: Kho Hàng ────────────────────────────────────────
        Route::middleware('admin.permission:view_inventory')->group(function () {
            Route::get('inventory', [\App\Http\Controllers\Admin\InventoryController::class, 'index'])->name('admin.inventory.index');
        });

        Route::middleware('admin.permission:update_stock')->group(function () {
            Route::get('inventory/{id}/edit', [\App\Http\Controllers\Admin\InventoryController::class, 'edit'])->name('admin.inventory.edit');
            Route::post('inventory/{id}/bulk-update', [\App\Http\Controllers\Admin\InventoryController::class, 'updateBulk'])->name('admin.inventory.bulk-update');
            Route::post('inventory/stock/{variantId}', [\App\Http\Controllers\Admin\InventoryController::class, 'updateStock'])->name('admin.inventory.updateStock');
        });

        Route::middleware('admin.permission:view_inventory,export_reports')->group(function () {
            Route::get('inventory/export', [\App\Http\Controllers\Admin\InventoryController::class, 'export'])->name('admin.inventory.export');
        });

        Route::middleware('admin.permission:manage_suppliers')->group(function () {
            Route::resource('suppliers', \App\Http\Controllers\Admin\SupplierController::class)->except(['show', 'create', 'edit'])->names('admin.suppliers');
        });

        Route::middleware('admin.permission:print_picking_slip')->group(function () {
            Route::get('orders/{id}/picking-slip', [\App\Http\Controllers\Admin\OrderController::class, 'pickingSlip'])->name('admin.orders.picking-slip');
        });

        // ─── Nhóm 4: Quản lý Danh mục & Sản phẩm ────────────────────
        Route::middleware('admin.permission:manage_products')->group(function () {
            Route::get('products/trashed', [\App\Http\Controllers\Admin\ProductController::class, 'trashed'])->name('admin.products.trashed');
            Route::post('products/{id}/restore', [\App\Http\Controllers\Admin\ProductController::class, 'restore'])->name('admin.products.restore');
            Route::delete('products/{id}/force-delete', [\App\Http\Controllers\Admin\ProductController::class, 'forceDelete'])->name('admin.products.force-delete');
            Route::resource('products', \App\Http\Controllers\Admin\ProductController::class)->names('admin.products');
        });

        Route::middleware('admin.permission:manage_categories')->group(function () {
            Route::get('categories/trashed', [\App\Http\Controllers\Admin\CategoryController::class, 'trashed'])->name('admin.categories.trashed');
            Route::post('categories/{id}/restore', [\App\Http\Controllers\Admin\CategoryController::class, 'restore'])->name('admin.categories.restore');
            Route::delete('categories/{id}/force-delete', [\App\Http\Controllers\Admin\CategoryController::class, 'forceDelete'])->name('admin.categories.force-delete');
            Route::resource('categories', \App\Http\Controllers\Admin\CategoryController::class)->names('admin.categories');

            Route::get('brands/trashed', [\App\Http\Controllers\Admin\BrandController::class, 'trashed'])->name('admin.brands.trashed');
            Route::post('brands/{id}/restore', [\App\Http\Controllers\Admin\BrandController::class, 'restore'])->name('admin.brands.restore');
            Route::delete('brands/{id}/force-delete', [\App\Http\Controllers\Admin\BrandController::class, 'forceDelete'])->name('admin.brands.force-delete');
            Route::resource('brands', \App\Http\Controllers\Admin\BrandController::class)->names('admin.brands');

            Route::get('attributes/trashed', [\App\Http\Controllers\Admin\AttributeController::class, 'trashed'])->name('admin.attributes.trashed');
            Route::post('attributes/{id}/restore', [\App\Http\Controllers\Admin\AttributeController::class, 'restore'])->name('admin.attributes.restore');
            Route::delete('attributes/{id}/force-delete', [\App\Http\Controllers\Admin\AttributeController::class, 'forceDelete'])->name('admin.attributes.force-delete');
            Route::resource('attributes', \App\Http\Controllers\Admin\AttributeController::class)->names('admin.attributes');
        });

        // ─── Nhóm 5: Hệ thống — Quản trị viên ───────────────────────
        Route::middleware('admin.permission:manage_users')->group(function () {
            Route::post('customers/{id}/toggle-status', [\App\Http\Controllers\Admin\CustomerController::class, 'toggleStatus'])->name('admin.customers.toggle-status');
            Route::resource('customers', \App\Http\Controllers\Admin\CustomerController::class)->only(['index', 'destroy'])->names('admin.customers');
            Route::resource('staff', \App\Http\Controllers\Admin\StaffController::class)->names('admin.staff');
        });

        // ─── Nhóm 5.1: Quản lý Nhân sự & Tính Lương ──────────────────
        Route::middleware('admin.permission:manage_payroll')->group(function () {
            Route::get('payroll', [\App\Http\Controllers\Admin\PayrollController::class, 'index'])->name('admin.payroll.index');
            Route::get('payroll/create', [\App\Http\Controllers\Admin\PayrollController::class, 'create'])->name('admin.payroll.create');
            Route::post('payroll', [\App\Http\Controllers\Admin\PayrollController::class, 'store'])->name('admin.payroll.store');
            Route::get('payroll/{id}', [\App\Http\Controllers\Admin\PayrollController::class, 'show'])->name('admin.payroll.show');
            Route::post('payroll/{id}/pay', [\App\Http\Controllers\Admin\PayrollController::class, 'pay'])->name('admin.payroll.pay');
            Route::get('payroll/{id}/export-pdf', [\App\Http\Controllers\Admin\PayrollController::class, 'exportPdf'])->name('admin.payroll.export-pdf');
        });

        Route::middleware('admin.permission:manage_settings')->group(function () {
            Route::get('/settings', [\App\Http\Controllers\Admin\SettingController::class, 'index'])->name('admin.settings.index');
            Route::post('/settings', [\App\Http\Controllers\Admin\SettingController::class, 'update'])->name('admin.settings.update');

            Route::resource('payment-methods', \App\Http\Controllers\Admin\PaymentMethodController::class)->except(['show'])->names('admin.payment-methods');
            Route::post('payment-methods/{payment_method}/toggle', [\App\Http\Controllers\Admin\PaymentMethodController::class, 'toggle'])->name('admin.payment-methods.toggle');
        });

        // ─── Nhóm 6: Kế toán & Audit Trail ───────────────────────────
        // Action Logs chỉ superadmin/admin (đã bị bypass) hoặc staff có manage_action_logs
        Route::middleware('admin.permission:manage_action_logs')->group(function () {
            Route::get('action-logs', [\App\Http\Controllers\Admin\ActionLogController::class, 'index'])->name('admin.action-logs.index');
        });

        // ─── Nhóm 7: Kế Toán Chuyên Sâu ──────────────────────────────
        Route::middleware('admin.permission:view_transactions')->group(function () {
            Route::get('accounting/transactions', [AccountingController::class, 'transactions'])->name('admin.accounting.transactions');
        });

        Route::middleware('admin.permission:view_voucher_usage')->group(function () {
            Route::get('accounting/voucher-usage', [AccountingController::class, 'voucherUsage'])->name('admin.accounting.voucher-usage');
        });

        Route::middleware('admin.permission:view_debt_report')->group(function () {
            Route::get('accounting/debt-report', [AccountingController::class, 'debtReport'])->name('admin.accounting.debt-report');
            Route::get('accounting/payment-reconciliation', [AccountingController::class, 'paymentReconciliation'])->name('admin.accounting.payment-reconciliation');
        });

        Route::middleware('admin.permission:view_inventory_valuation')->group(function () {
            Route::get('accounting/inventory-valuation', [AccountingController::class, 'inventoryValuation'])->name('admin.accounting.inventory-valuation');
        });

    }); // end auth:web
}); // end prefix admin

// ═══════════════════════════════════════════════════════════════════════
// DASHBOARD (Admin)
// ═══════════════════════════════════════════════════════════════════════
Route::get('/dashboard', [\App\Http\Controllers\DashboardController::class, 'index'])
    ->middleware(['auth:web', 'verified', 'admin.permission:view_analytics'])
    ->name('dashboard');

// ═══════════════════════════════════════════════════════════════════════
// CLIENT ROUTES
// ═══════════════════════════════════════════════════════════════════════
Route::middleware('guest:customer')->group(function () {
    Route::get('/login', [ClientAuthController::class, 'showLogin'])->name('login');
    Route::get('/login', [ClientAuthController::class, 'showLogin'])->name('client.login');
    Route::post('/login', [ClientAuthController::class, 'login'])->name('login.submit');
    Route::post('/login', [ClientAuthController::class, 'login'])->name('client.login.submit');
    Route::get('/register', [ClientAuthController::class, 'showRegisterForm'])->name('register');
    Route::get('/register', [ClientAuthController::class, 'showRegisterForm'])->name('client.register');
    Route::post('/register', [ClientAuthController::class, 'register'])->name('register.submit');
    Route::post('/register', [ClientAuthController::class, 'register'])->name('client.register.submit');

    Route::get('/auth/{provider}/redirect', [ClientAuthController::class, 'redirectToProvider'])->name('social.redirect');

    // Forgot Password
    Route::get('/forgot-password', [ClientAuthController::class, 'showForgotPassword'])->name('client.password.request');
    Route::post('/forgot-password', [ClientAuthController::class, 'sendResetLinkEmail'])->name('client.password.email');
    Route::get('/reset-password/{token}', [ClientAuthController::class, 'showResetPassword'])->name('client.password.reset');
    Route::post('/reset-password', [ClientAuthController::class, 'resetPassword'])->name('client.password.update');
});

// Socialite callback: accessible regardless of auth state
Route::get('/auth/{provider}/callback', [ClientAuthController::class, 'handleProviderCallback'])->name('social.callback');

Route::middleware('auth:customer')->group(function () {
    Route::post('/logout', [ClientAuthController::class, 'logout'])->name('client.logout');

    // Cart
    Route::get('/gio-hang', [\App\Http\Controllers\Client\CartController::class, 'index'])->name('cart.index');
    Route::post('/gio-hang/them', [\App\Http\Controllers\Client\CartController::class, 'add'])->name('cart.add');
    Route::put('/gio-hang/{id}', [\App\Http\Controllers\Client\CartController::class, 'update'])->name('cart.update');
    Route::delete('/gio-hang/{id}', [\App\Http\Controllers\Client\CartController::class, 'remove'])->name('cart.remove');

    // Favorites / Wishlist
    Route::post('/favorites/toggle/{productId}', [\App\Http\Controllers\Client\FavoriteController::class, 'toggle'])->name('client.favorites.toggle');

    // Reviews
    Route::post('/danh-gia/{productId}', [\App\Http\Controllers\Client\ReviewController::class, 'store'])->name('client.reviews.store');
    Route::put('/danh-gia/{id}', [\App\Http\Controllers\Client\ReviewController::class, 'update'])->name('client.reviews.update');
    Route::delete('/danh-gia/{id}', [\App\Http\Controllers\Client\ReviewController::class, 'destroy'])->name('client.reviews.destroy');

    // Checkout
    Route::get('/thanh-toan', [\App\Http\Controllers\Client\CheckoutController::class, 'checkout'])->name('checkout.index');
    Route::get('/thanh-toan', [\App\Http\Controllers\Client\CheckoutController::class, 'checkout'])->name('client.checkout');
    Route::post('/thanh-toan', [\App\Http\Controllers\Client\CheckoutController::class, 'store'])->name('checkout.store');
    Route::post('/dat-hang', [\App\Http\Controllers\Client\CheckoutController::class, 'store'])->name('client.order.store');

    // Order success
    Route::get('/dat-hang-thanh-cong/{orderId}', [\App\Http\Controllers\Client\CheckoutController::class, 'success'])->name('order.success');
    Route::get('/dat-hang-thanh-cong/{orderId}', [\App\Http\Controllers\Client\CheckoutController::class, 'success'])->name('client.order.success');

    // Orders
    Route::get('/don-hang', [\App\Http\Controllers\Client\OrderController::class, 'index'])->name('order.index');
    Route::get('/don-hang', [\App\Http\Controllers\Client\OrderController::class, 'index'])->name('client.order.index');
    Route::get('/don-hang/{id}', [\App\Http\Controllers\Client\OrderController::class, 'show'])->name('client.order.show');
    Route::post('/don-hang/{id}/cancel', [\App\Http\Controllers\Client\OrderController::class, 'cancel'])->name('client.order.cancel');
    Route::post('/don-hang/{id}/rebuy', [\App\Http\Controllers\Client\OrderController::class, 'rebuy'])->name('client.order.rebuy');

    // Payments
    Route::get('/don-hang/{id}/payment-qr', [\App\Http\Controllers\Client\PaymentController::class, 'paymentQr'])->name('client.order.payment_qr');
    Route::post('/don-hang/{id}/confirm-paid', [\App\Http\Controllers\Client\PaymentController::class, 'confirmPaid'])->name('client.order.confirm_paid');
    Route::post('/don-hang/{id}/retry-payment', [\App\Http\Controllers\Client\PaymentController::class, 'retryPayment'])->name('client.order.retry_payment');

    // Vouchers
    Route::post('/voucher/apply', [\App\Http\Controllers\Client\VoucherController::class, 'applyVoucher'])->name('client.voucher.apply');
    Route::post('/voucher/remove', [\App\Http\Controllers\Client\VoucherController::class, 'removeVoucher'])->name('client.voucher.remove');

    // Chat
    Route::post('/chat/start', [\App\Http\Controllers\ChatController::class, 'startOrGetConversation'])->name('client.chat.start');
    Route::post('/chat/send', [\App\Http\Controllers\ChatController::class, 'customerSendMessage'])->name('client.chat.send');

    // Profile
    Route::get('/tai-khoan', [\App\Http\Controllers\Client\ProfileController::class, 'index'])->name('client.profile');
    Route::post('/tai-khoan/cap-nhat', [\App\Http\Controllers\Client\ProfileController::class, 'updateInfo'])->name('client.profile.update');
    Route::post('/tai-khoan/dia-chi', [\App\Http\Controllers\Client\ProfileController::class, 'storeAddress'])->name('client.address.store');
    Route::post('/tai-khoan/doi-mat-khau', [\App\Http\Controllers\Client\ProfileController::class, 'updatePassword'])->name('client.profile.password');
});

// ═══════════════════════════════════════════════════════════════════════
// PUBLIC CLIENT ROUTES
// ═══════════════════════════════════════════════════════════════════════
Route::get('/', [\App\Http\Controllers\Client\HomeController::class, 'index'])->name('home');
Route::get('/', [\App\Http\Controllers\Client\HomeController::class, 'index'])->name('client.home');
Route::get('/api/search-suggestions', [\App\Http\Controllers\Client\HomeController::class, 'searchSuggestions'])->name('client.search.suggestions');
Route::post('/recently-viewed', [\App\Http\Controllers\Client\HomeController::class, 'getRecentlyViewed'])->name('client.recently-viewed');

Route::get('/shop', [\App\Http\Controllers\Client\ProductController::class, 'index'])->name('client.shop');
Route::get('/san-pham/{slug}', [\App\Http\Controllers\Client\ProductController::class, 'show'])->name('client.product.detail');
Route::post('/products/{id}/increment-views', [\App\Http\Controllers\Client\ProductController::class, 'incrementViews'])->name('client.product.views');


Route::get('/vnpay/return', [\App\Http\Controllers\Client\PaymentController::class, 'vnpayReturn'])->name('client.vnpay.return');

Route::get('/tin-tuc', [\App\Http\Controllers\Client\NewsController::class, 'index'])->name('client.news.index');
Route::get('/tin-tuc/{slug}', [\App\Http\Controllers\Client\NewsController::class, 'show'])->name('client.news.show');

Route::get('/lien-he', [\App\Http\Controllers\Client\ContactController::class, 'index'])->name('client.contact.index');
