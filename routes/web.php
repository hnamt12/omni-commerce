<?php

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Client\AuthController as ClientAuthController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// Admin Routes
Route::prefix('admin')->group(function () {
    // Guest routes for Admin
    Route::middleware('guest:web')->group(function () {
        Route::get('/login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
        Route::post('/login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
    });

    // Protected routes for Admin
    Route::middleware('auth:web')->group(function () {
        Route::post('/logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
        Route::get('categories/trashed', [\App\Http\Controllers\Admin\CategoryController::class, 'trashed'])->name('admin.categories.trashed');
        Route::post('categories/{id}/restore', [\App\Http\Controllers\Admin\CategoryController::class, 'restore'])->name('admin.categories.restore');
        Route::delete('categories/{id}/force-delete', [\App\Http\Controllers\Admin\CategoryController::class, 'forceDelete'])->name('admin.categories.force-delete');

        Route::get('brands/trashed', [\App\Http\Controllers\Admin\BrandController::class, 'trashed'])->name('admin.brands.trashed');
        Route::post('brands/{id}/restore', [\App\Http\Controllers\Admin\BrandController::class, 'restore'])->name('admin.brands.restore');
        Route::delete('brands/{id}/force-delete', [\App\Http\Controllers\Admin\BrandController::class, 'forceDelete'])->name('admin.brands.force-delete');

        Route::get('attributes/trashed', [\App\Http\Controllers\Admin\AttributeController::class, 'trashed'])->name('admin.attributes.trashed');
        Route::post('attributes/{id}/restore', [\App\Http\Controllers\Admin\AttributeController::class, 'restore'])->name('admin.attributes.restore');
        Route::delete('attributes/{id}/force-delete', [\App\Http\Controllers\Admin\AttributeController::class, 'forceDelete'])->name('admin.attributes.force-delete');

        // Inventory Routes
        Route::get('inventory', [\App\Http\Controllers\Admin\InventoryController::class, 'index'])->name('admin.inventory.index');
        Route::get('inventory/export', [\App\Http\Controllers\Admin\InventoryController::class, 'export'])->name('admin.inventory.export');
        Route::get('inventory/{id}/edit', [\App\Http\Controllers\Admin\InventoryController::class, 'edit'])->name('admin.inventory.edit');
        Route::post('inventory/{id}/bulk-update', [\App\Http\Controllers\Admin\InventoryController::class, 'updateBulk'])->name('admin.inventory.bulk-update');
        Route::post('inventory/stock/{variantId}', [\App\Http\Controllers\Admin\InventoryController::class, 'updateStock'])->name('admin.inventory.updateStock');

        Route::resource('categories', \App\Http\Controllers\Admin\CategoryController::class)->names('admin.categories');
        Route::resource('brands', \App\Http\Controllers\Admin\BrandController::class)->names('admin.brands');
        Route::resource('attributes', \App\Http\Controllers\Admin\AttributeController::class)->names('admin.attributes');
        Route::resource('products', \App\Http\Controllers\Admin\ProductController::class)->names('admin.products');
        Route::put('orders/{id}/update-status', [\App\Http\Controllers\Admin\OrderController::class, 'updateStatus'])->name('admin.orders.updateStatus');
        Route::resource('orders', \App\Http\Controllers\Admin\OrderController::class)->names('admin.orders');
        Route::resource('vouchers', \App\Http\Controllers\Admin\VoucherController::class)->names('admin.vouchers');
        Route::resource('cancel-requests', \App\Http\Controllers\Admin\CancelRequestController::class)->only(['index'])->names('admin.cancel-requests');
        Route::post('cancel-requests/{id}/approve', [\App\Http\Controllers\Admin\CancelRequestController::class, 'approve'])->name('admin.cancel-requests.approve');
        Route::post('cancel-requests/{id}/reject', [\App\Http\Controllers\Admin\CancelRequestController::class, 'reject'])->name('admin.cancel-requests.reject');
        Route::get('flash-sales/search-products', [\App\Http\Controllers\Admin\FlashSaleController::class, 'searchProducts'])->name('admin.flash-sales.search-products');
        Route::get('flash-sales/product/{id}/variants', [\App\Http\Controllers\Admin\FlashSaleController::class, 'getProductVariants'])->name('admin.flash-sales.product-variants');
        Route::post('flash-sales/{id}/add-products', [\App\Http\Controllers\Admin\FlashSaleController::class, 'addMultipleProducts'])->name('admin.flash-sales.add-product');
        Route::delete('flash-sales/items/{itemId}', [\App\Http\Controllers\Admin\FlashSaleController::class, 'removeProduct'])->name('admin.flash-sales.remove-product');
        Route::resource('flash-sales', \App\Http\Controllers\Admin\FlashSaleController::class)->names('admin.flash-sales');
        
        // Staff Routes
        Route::resource('staff', \App\Http\Controllers\Admin\StaffController::class)->names('admin.staff');

        // Banner Routes
        Route::post('banners/reorder', [\App\Http\Controllers\Admin\BannerController::class, 'reorder'])->name('admin.banners.reorder');
        Route::resource('banners', \App\Http\Controllers\Admin\BannerController::class)->names('admin.banners');

        // Payment Methods (new - database-driven)
        Route::resource('payment-methods', \App\Http\Controllers\Admin\PaymentMethodController::class)
            ->except(['show'])
            ->names('admin.payment-methods');
        Route::post('payment-methods/{payment_method}/toggle', [\App\Http\Controllers\Admin\PaymentMethodController::class, 'toggle'])
            ->name('admin.payment-methods.toggle');
    });
});

Route::get('/dashboard', [\App\Http\Controllers\DashboardController::class, 'index'])
    ->middleware(['auth:web', 'verified'])->name('dashboard');

// Client Routes
Route::middleware('guest:customer')->group(function () {
    Route::get('/login',    [ClientAuthController::class, 'showLogin'])->name('login');
    Route::get('/login',    [ClientAuthController::class, 'showLogin'])->name('client.login');   // alias for Ziggy
    Route::post('/login',   [ClientAuthController::class, 'login'])->name('login.submit');
    Route::post('/login',   [ClientAuthController::class, 'login'])->name('client.login.submit'); // alias
    Route::get('/register', [ClientAuthController::class, 'showRegisterForm'])->name('register');
    Route::get('/register', [ClientAuthController::class, 'showRegisterForm'])->name('client.register'); // alias
    Route::post('/register',[ClientAuthController::class, 'register'])->name('register.submit');

    // Socialite: redirect to provider
    Route::get('/auth/{provider}/redirect', [ClientAuthController::class, 'redirectToProvider'])->name('social.redirect');
    // Socialite: handle callback (outside guest so that existing logged-in users can link accounts)
});

// Socialite callback: accessible regardless of auth state
Route::get('/auth/{provider}/callback', [ClientAuthController::class, 'handleProviderCallback'])->name('social.callback');

Route::middleware('auth:customer')->group(function () {
    Route::post('/logout', [ClientAuthController::class, 'logout'])->name('client.logout');

    // Cart
    Route::get('/gio-hang',          [\App\Http\Controllers\Client\CartController::class, 'index'])->name('cart.index');
    Route::post('/gio-hang/them',    [\App\Http\Controllers\Client\CartController::class, 'add'])->name('cart.add');
    Route::put('/gio-hang/{id}',     [\App\Http\Controllers\Client\CartController::class, 'update'])->name('cart.update');
    Route::delete('/gio-hang/{id}',  [\App\Http\Controllers\Client\CartController::class, 'remove'])->name('cart.remove');

    // ── Checkout ──────────────────────────────────────────────────────────────
    Route::get('/thanh-toan',  [\App\Http\Controllers\Client\CheckoutController::class, 'checkout'])->name('checkout.index');
    Route::get('/thanh-toan',  [\App\Http\Controllers\Client\CheckoutController::class, 'checkout'])->name('client.checkout');
    Route::post('/thanh-toan', [\App\Http\Controllers\Client\CheckoutController::class, 'store'])->name('checkout.store');
    Route::post('/dat-hang',   [\App\Http\Controllers\Client\CheckoutController::class, 'store'])->name('client.order.store');

    // Order success page
    Route::get('/dat-hang-thanh-cong/{orderId}', [\App\Http\Controllers\Client\CheckoutController::class, 'success'])->name('order.success');
    Route::get('/dat-hang-thanh-cong/{orderId}', [\App\Http\Controllers\Client\CheckoutController::class, 'success'])->name('client.order.success');

    // ── Orders (index / detail / cancel) ─────────────────────────────────────
    Route::get('/don-hang',          [\App\Http\Controllers\Client\OrderController::class, 'index'])->name('order.index');
    Route::get('/don-hang',          [\App\Http\Controllers\Client\OrderController::class, 'index'])->name('client.order.index');
    Route::get('/don-hang/{id}',     [\App\Http\Controllers\Client\OrderController::class, 'show'])->name('client.order.show');
    Route::post('/don-hang/{id}/cancel', [\App\Http\Controllers\Client\OrderController::class, 'cancel'])->name('client.order.cancel');
    Route::post('/don-hang/{id}/rebuy',  [\App\Http\Controllers\Client\OrderController::class, 'rebuy'])->name('client.order.rebuy');

    // ── Payments ──────────────────────────────────────────────────────────────
    Route::get('/don-hang/{id}/payment-qr',    [\App\Http\Controllers\Client\PaymentController::class, 'paymentQr'])->name('client.order.payment_qr');
    Route::post('/don-hang/{id}/confirm-paid', [\App\Http\Controllers\Client\PaymentController::class, 'confirmPaid'])->name('client.order.confirm_paid');
    Route::post('/don-hang/{id}/retry-payment',[\App\Http\Controllers\Client\PaymentController::class, 'retryPayment'])->name('client.order.retry_payment');

    // ── Vouchers ──────────────────────────────────────────────────────────────
    Route::post('/voucher/apply',  [\App\Http\Controllers\Client\VoucherController::class, 'applyVoucher'])->name('client.voucher.apply');
    Route::post('/voucher/remove', [\App\Http\Controllers\Client\VoucherController::class, 'removeVoucher'])->name('client.voucher.remove');

    // Profile
    Route::get('/tai-khoan',               [\App\Http\Controllers\Client\ProfileController::class, 'index'])->name('client.profile');
    Route::post('/tai-khoan/cap-nhat',     [\App\Http\Controllers\Client\ProfileController::class, 'updateInfo'])->name('client.profile.update');
    Route::post('/tai-khoan/dia-chi',      [\App\Http\Controllers\Client\ProfileController::class, 'storeAddress'])->name('client.address.store');
});

Route::get('/', [\App\Http\Controllers\Client\HomeController::class, 'index'])->name('home');

// Shop & Products (public)
Route::get('/shop',                  [\App\Http\Controllers\Client\ProductController::class, 'index'])->name('client.shop');
Route::get('/san-pham/{slug}',       [\App\Http\Controllers\Client\ProductController::class, 'show'])->name('client.product.detail');
Route::post('/products/{id}/increment-views', [\App\Http\Controllers\Client\ProductController::class, 'incrementViews'])->name('client.product.views');

// VNPay Callback (outside auth middleware — VNPay server hits this directly)
Route::get('/vnpay/return', [\App\Http\Controllers\Client\PaymentController::class, 'vnpayReturn'])->name('client.vnpay.return');
