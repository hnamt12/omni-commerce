<?php

use App\Http\Controllers\Admin\AccountingController;
use App\Http\Controllers\Admin\ActionLogController;
use App\Http\Controllers\Admin\AttributeController;
use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\BannerController;
use App\Http\Controllers\Admin\BannerLocationController;
use App\Http\Controllers\Admin\BrandController;
use App\Http\Controllers\Admin\CancelRequestController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\CustomerController;
use App\Http\Controllers\Admin\FlashSaleController;
use App\Http\Controllers\Admin\InventoryController;
use App\Http\Controllers\Admin\NotificationController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\PaymentMethodController;
use App\Http\Controllers\Admin\PayrollController;
use App\Http\Controllers\Admin\PostController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\ProfileController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\StaffController;
use App\Http\Controllers\Admin\SupplierController;
use App\Http\Controllers\Admin\VoucherController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\Client\AuthController as ClientAuthController;
use App\Http\Controllers\Client\CartController;
use App\Http\Controllers\Client\CheckoutController;
use App\Http\Controllers\Client\ContactController;
use App\Http\Controllers\Client\FavoriteController;
use App\Http\Controllers\Client\HomeController;
use App\Http\Controllers\Client\NewsController;
use App\Http\Controllers\Client\PaymentController;
use App\Http\Controllers\Client\ReviewController;
use App\Http\Controllers\DashboardController;
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

    // ─── Root /admin — redirect theo trạng thái đăng nhập ────────────
    Route::get('/', function () {
        if (auth('web')->check()) {
            return redirect()->route('dashboard');
        }
        return redirect()->route('admin.login');
    })->name('admin.home');

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
        Route::get('/profile', [ProfileController::class, 'index'])->name('admin.profile.index');
        Route::post('/profile', [ProfileController::class, 'update'])->name('admin.profile.update');
        Route::post('/profile/password', [ProfileController::class, 'updatePassword'])->name('admin.profile.password');

        // Chat — mọi nhân viên xác thực đều được dùng chat nội bộ
        Route::prefix('chat')->group(function () {
            Route::get('/', fn () => Inertia::render('Admin/Chat/Index'))->name('admin.chat.index');
            Route::get('/unread-notifications', [ChatController::class, 'getUnreadNotifications'])->name('admin.chat.unread-notifications');
            Route::get('/conversations', [ChatController::class, 'index'])->name('admin.chat.conversations');
            Route::get('/conversations/{id}/messages', [ChatController::class, 'getMessages'])->name('admin.chat.messages');
            Route::post('/send', [ChatController::class, 'sendMessage'])->name('admin.chat.send');
        });

        // Notifications — mọi nhân viên xác thực đều xem được thông báo của mình
        Route::prefix('notifications')->group(function () {
            Route::get('/', [NotificationController::class, 'index'])->name('admin.notifications.index');
            Route::post('/{id}/mark-as-read', [NotificationController::class, 'markAsRead'])->name('admin.notifications.mark-as-read');
            Route::post('/mark-all-as-read', [NotificationController::class, 'markAllAsRead'])->name('admin.notifications.mark-all-as-read');
        });

        // ─── Nhóm 1: Sale & CSKH ─────────────────────────────────────
        // Permission: view_orders, update_orders, manage_cancel_requests
        Route::middleware('admin.permission:view_orders')->group(function () {
            Route::get('orders/{id}/print', [OrderController::class, 'print'])->name('admin.orders.print');
            Route::resource('orders', OrderController::class)->only(['index', 'show', 'create', 'store'])->names('admin.orders');
        });

        Route::middleware('admin.permission:view_orders,export_reports')->group(function () {
            Route::get('orders/export', [OrderController::class, 'export'])->name('admin.orders.export');
        });

        Route::middleware('admin.permission:update_orders')->group(function () {
            Route::put('orders/{id}/update-status', [OrderController::class, 'updateStatus'])->name('admin.orders.updateStatus');
            Route::delete('orders/{order}', [OrderController::class, 'destroy'])->name('admin.orders.destroy');
        });

        Route::middleware('admin.permission:manage_cancel_requests')->group(function () {
            Route::resource('cancel-requests', CancelRequestController::class)->only(['index'])->names('admin.cancel-requests');
            Route::post('cancel-requests/{id}/approve', [CancelRequestController::class, 'approve'])->name('admin.cancel-requests.approve');
            Route::post('cancel-requests/{id}/reject', [CancelRequestController::class, 'reject'])->name('admin.cancel-requests.reject');
        });

        // ─── Nhóm 2: Marketing & Content ─────────────────────────────
        Route::middleware('admin.permission:manage_banners')->group(function () {
            Route::post('banners/reorder', [BannerController::class, 'reorder'])->name('admin.banners.reorder');
            Route::resource('banners', BannerController::class)->names('admin.banners');
            Route::resource('banner-locations', BannerLocationController::class)->except(['show', 'create', 'edit'])->names('admin.banner-locations');
        });

        Route::middleware('admin.permission:manage_vouchers')->group(function () {
            Route::resource('vouchers', VoucherController::class)->names('admin.vouchers');
        });

        Route::middleware('admin.permission:manage_flash_sales')->group(function () {
            Route::get('flash-sales/search-products', [FlashSaleController::class, 'searchProducts'])->name('admin.flash-sales.search-products');
            Route::get('flash-sales/product/{id}/variants', [FlashSaleController::class, 'getProductVariants'])->name('admin.flash-sales.product-variants');
            Route::post('flash-sales/{id}/add-products', [FlashSaleController::class, 'addMultipleProducts'])->name('admin.flash-sales.add-product');
            Route::delete('flash-sales/items/{itemId}', [FlashSaleController::class, 'removeProduct'])->name('admin.flash-sales.remove-product');
            Route::resource('flash-sales', FlashSaleController::class)->names('admin.flash-sales');
        });

        Route::middleware('admin.permission:manage_posts')->group(function () {
            Route::resource('posts', PostController::class)->except(['show'])->names('admin.posts');
        });

        // ─── Nhóm 3: Kho Hàng ────────────────────────────────────────
        Route::middleware('admin.permission:view_inventory')->group(function () {
            Route::get('inventory', [InventoryController::class, 'index'])->name('admin.inventory.index');
        });

        Route::middleware('admin.permission:update_stock')->group(function () {
            Route::get('inventory/{id}/edit', [InventoryController::class, 'edit'])->name('admin.inventory.edit');
            Route::post('inventory/{id}/bulk-update', [InventoryController::class, 'updateBulk'])->name('admin.inventory.bulk-update');
            Route::post('inventory/stock/{variantId}', [InventoryController::class, 'updateStock'])->name('admin.inventory.updateStock');
        });

        Route::middleware('admin.permission:view_inventory,export_reports')->group(function () {
            Route::get('inventory/export', [InventoryController::class, 'export'])->name('admin.inventory.export');
        });

        Route::middleware('admin.permission:manage_suppliers')->group(function () {
            Route::resource('suppliers', SupplierController::class)->except(['show', 'create', 'edit'])->names('admin.suppliers');
        });

        Route::middleware('admin.permission:print_picking_slip')->group(function () {
            Route::get('orders/{id}/picking-slip', [OrderController::class, 'pickingSlip'])->name('admin.orders.picking-slip');
        });

        // ─── Nhóm 4: Quản lý Danh mục & Sản phẩm ────────────────────
        Route::middleware('admin.permission:manage_products')->group(function () {
            Route::get('products/trashed', [ProductController::class, 'trashed'])->name('admin.products.trashed');
            Route::post('products/{id}/restore', [ProductController::class, 'restore'])->name('admin.products.restore');
            Route::delete('products/{id}/force-delete', [ProductController::class, 'forceDelete'])->name('admin.products.force-delete');
            Route::resource('products', ProductController::class)->names('admin.products');
        });

        Route::middleware('admin.permission:manage_categories')->group(function () {
            Route::get('categories/trashed', [CategoryController::class, 'trashed'])->name('admin.categories.trashed');
            Route::post('categories/{id}/restore', [CategoryController::class, 'restore'])->name('admin.categories.restore');
            Route::delete('categories/{id}/force-delete', [CategoryController::class, 'forceDelete'])->name('admin.categories.force-delete');
            Route::resource('categories', CategoryController::class)->names('admin.categories');

            Route::get('brands/trashed', [BrandController::class, 'trashed'])->name('admin.brands.trashed');
            Route::post('brands/{id}/restore', [BrandController::class, 'restore'])->name('admin.brands.restore');
            Route::delete('brands/{id}/force-delete', [BrandController::class, 'forceDelete'])->name('admin.brands.force-delete');
            Route::resource('brands', BrandController::class)->names('admin.brands');

            Route::get('attributes/trashed', [AttributeController::class, 'trashed'])->name('admin.attributes.trashed');
            Route::post('attributes/{id}/restore', [AttributeController::class, 'restore'])->name('admin.attributes.restore');
            Route::delete('attributes/{id}/force-delete', [AttributeController::class, 'forceDelete'])->name('admin.attributes.force-delete');
            Route::resource('attributes', AttributeController::class)->names('admin.attributes');
        });

        // ─── Nhóm 5: Hệ thống — Quản trị viên ───────────────────────
        Route::middleware('admin.permission:manage_users')->group(function () {
            Route::post('customers/{id}/toggle-status', [CustomerController::class, 'toggleStatus'])->name('admin.customers.toggle-status');
            Route::resource('customers', CustomerController::class)->only(['index', 'destroy'])->names('admin.customers');
            Route::resource('staff', StaffController::class)->names('admin.staff');
        });

        // ─── Nhóm 5.1: Quản lý Nhân sự & Tính Lương ──────────────────
        Route::middleware('admin.permission:manage_payroll')->group(function () {
            Route::get('payroll', [PayrollController::class, 'index'])->name('admin.payroll.index');
            Route::get('payroll/create', [PayrollController::class, 'create'])->name('admin.payroll.create');
            Route::post('payroll', [PayrollController::class, 'store'])->name('admin.payroll.store');
            Route::get('payroll/{id}', [PayrollController::class, 'show'])->name('admin.payroll.show');
            Route::post('payroll/{id}/pay', [PayrollController::class, 'pay'])->name('admin.payroll.pay');
            Route::get('payroll/{id}/export-pdf', [PayrollController::class, 'exportPdf'])->name('admin.payroll.export-pdf');
        });

        Route::middleware('admin.permission:manage_settings')->group(function () {
            Route::get('/settings', [SettingController::class, 'index'])->name('admin.settings.index');
            Route::post('/settings', [SettingController::class, 'update'])->name('admin.settings.update');

            Route::resource('payment-methods', PaymentMethodController::class)->except(['show'])->names('admin.payment-methods');
            Route::post('payment-methods/{payment_method}/toggle', [PaymentMethodController::class, 'toggle'])->name('admin.payment-methods.toggle');
        });

        // ─── Nhóm 6: Kế toán & Audit Trail ───────────────────────────
        // Action Logs chỉ superadmin/admin (đã bị bypass) hoặc staff có manage_action_logs
        Route::middleware('admin.permission:manage_action_logs')->group(function () {
            Route::get('action-logs', [ActionLogController::class, 'index'])->name('admin.action-logs.index');
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
Route::get('/dashboard', [DashboardController::class, 'index'])
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
    Route::get('/gio-hang', [CartController::class, 'index'])->name('cart.index');
    Route::post('/gio-hang/them', [CartController::class, 'add'])->name('cart.add');
    Route::put('/gio-hang/{id}', [CartController::class, 'update'])->name('cart.update');
    Route::delete('/gio-hang/{id}', [CartController::class, 'remove'])->name('cart.remove');

    // Favorites / Wishlist
    Route::post('/favorites/toggle/{productId}', [FavoriteController::class, 'toggle'])->name('client.favorites.toggle');

    // Reviews
    Route::post('/danh-gia/{productId}', [ReviewController::class, 'store'])->name('client.reviews.store');
    Route::put('/danh-gia/{id}', [ReviewController::class, 'update'])->name('client.reviews.update');
    Route::delete('/danh-gia/{id}', [ReviewController::class, 'destroy'])->name('client.reviews.destroy');

    // Checkout
    Route::get('/thanh-toan', [CheckoutController::class, 'checkout'])->name('checkout.index');
    Route::get('/thanh-toan', [CheckoutController::class, 'checkout'])->name('client.checkout');
    Route::post('/thanh-toan', [CheckoutController::class, 'store'])->name('checkout.store');
    Route::post('/dat-hang', [CheckoutController::class, 'store'])->name('client.order.store');

    // Order success
    Route::get('/dat-hang-thanh-cong/{orderId}', [CheckoutController::class, 'success'])->name('order.success');
    Route::get('/dat-hang-thanh-cong/{orderId}', [CheckoutController::class, 'success'])->name('client.order.success');

    // Orders
    Route::get('/don-hang', [App\Http\Controllers\Client\OrderController::class, 'index'])->name('order.index');
    Route::get('/don-hang', [App\Http\Controllers\Client\OrderController::class, 'index'])->name('client.order.index');
    Route::get('/don-hang/{id}', [App\Http\Controllers\Client\OrderController::class, 'show'])->name('client.order.show');
    Route::post('/don-hang/{id}/cancel', [App\Http\Controllers\Client\OrderController::class, 'cancel'])->name('client.order.cancel');
    Route::post('/don-hang/{id}/rebuy', [App\Http\Controllers\Client\OrderController::class, 'rebuy'])->name('client.order.rebuy');

    // Payments
    Route::get('/don-hang/{id}/payment-qr', [PaymentController::class, 'paymentQr'])->name('client.order.payment_qr');
    Route::post('/don-hang/{id}/confirm-paid', [PaymentController::class, 'confirmPaid'])->name('client.order.confirm_paid');
    Route::post('/don-hang/{id}/retry-payment', [PaymentController::class, 'retryPayment'])->name('client.order.retry_payment');

    // Vouchers
    Route::post('/voucher/apply', [App\Http\Controllers\Client\VoucherController::class, 'applyVoucher'])->name('client.voucher.apply');
    Route::post('/voucher/remove', [App\Http\Controllers\Client\VoucherController::class, 'removeVoucher'])->name('client.voucher.remove');

    // Chat
    Route::post('/chat/start', [ChatController::class, 'startOrGetConversation'])->name('client.chat.start');
    Route::post('/chat/send', [ChatController::class, 'customerSendMessage'])->name('client.chat.send');

    // Profile
    Route::get('/tai-khoan', [App\Http\Controllers\Client\ProfileController::class, 'index'])->name('client.profile');
    Route::post('/tai-khoan/cap-nhat', [App\Http\Controllers\Client\ProfileController::class, 'updateInfo'])->name('client.profile.update');
    Route::post('/tai-khoan/dia-chi', [App\Http\Controllers\Client\ProfileController::class, 'storeAddress'])->name('client.address.store');
    Route::post('/tai-khoan/doi-mat-khau', [App\Http\Controllers\Client\ProfileController::class, 'updatePassword'])->name('client.profile.password');
});

// ═══════════════════════════════════════════════════════════════════════
// PUBLIC CLIENT ROUTES
// ═══════════════════════════════════════════════════════════════════════
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/', [HomeController::class, 'index'])->name('client.home');
Route::get('/api/search-suggestions', [HomeController::class, 'searchSuggestions'])->name('client.search.suggestions');
Route::post('/recently-viewed', [HomeController::class, 'getRecentlyViewed'])->name('client.recently-viewed');

Route::get('/shop', [App\Http\Controllers\Client\ProductController::class, 'index'])->name('client.shop');
Route::get('/san-pham/{slug}', [App\Http\Controllers\Client\ProductController::class, 'show'])->name('client.product.detail');
Route::post('/products/{id}/increment-views', [App\Http\Controllers\Client\ProductController::class, 'incrementViews'])->name('client.product.views');

Route::get('/vnpay/return', [PaymentController::class, 'vnpayReturn'])->name('client.vnpay.return');

Route::get('/tin-tuc', [NewsController::class, 'index'])->name('client.news.index');
Route::get('/tin-tuc/{slug}', [NewsController::class, 'show'])->name('client.news.show');

Route::get('/lien-he', [ContactController::class, 'index'])->name('client.contact.index');

// ═══════════════════════════════════════════════════════════════════════
// MAINTENANCE: Dọn dẹp cache & file hot trên Production
// Truy cập 1 lần sau deploy, sau đó có thể xóa route này đi
// ═══════════════════════════════════════════════════════════════════════
Route::get('/clear-cache', function () {
    // Xóa file public/hot nếu vô tình bị đẩy lên hosting
    // (file này khiến Laravel cố gọi Vite dev server thay vì đọc build tĩnh)
    if (file_exists(public_path('hot'))) {
        unlink(public_path('hot'));
    }

    Illuminate\Support\Facades\Artisan::call('view:clear');
    Illuminate\Support\Facades\Artisan::call('config:clear');
    Illuminate\Support\Facades\Artisan::call('cache:clear');
    Illuminate\Support\Facades\Artisan::call('route:clear');

    return response()->json([
        'status'  => 'ok',
        'message' => 'Đã xóa file hot (nếu có) và clear toàn bộ cache.',
    ]);
})->name('clear-cache');
