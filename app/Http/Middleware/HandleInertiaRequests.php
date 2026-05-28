<?php

namespace App\Http\Middleware;

use App\Models\Cart;
use App\Models\Conversation;
use App\Models\Favorite;
use Illuminate\Http\Request;
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determines the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @see https://inertiajs.com/shared-data
     *
     * @return array<string, mixed>
     */
   public function share(Request $request): array
    {
        return array_merge(parent::share($request), [
            'auth' => [
                // Tách logic Admin phức tạp ra phương thức chuyên biệt
                'user' => fn () => $this->shareAdminData($request),
                
                // Giữ lại Client động
                'customer' => fn () => auth('customer')->user()
                    ? auth('customer')->user()->only(['id', 'name', 'email', 'avatar'])
                    : null,
            ],
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error' => fn () => $request->session()->get('error'),
            ],
            // CLEAN & OPTIMIZED: Ép dữ liệu Cart & Favorites chạy Lazy qua Closure
            'cartCount' => fn () => auth('customer')->check() 
                ? Cart::where('customer_id', auth('customer')->id())->count() 
                : 0,
                
            'favoriteProductIds' => fn () => auth('customer')->check()
                ? Favorite::where('customer_id', auth('customer')->id())->pluck('product_id')->toArray()
                : [],
        ]);
    }

    /**
     * Định dạng dữ liệu và xử lý logic riêng cho Admin Guard
     */
    protected function shareAdminData(Request $request): ?array
    {
        $user = $request->user(); // web guard mặc định
        
        if (! $user) {
            return null;
        }

        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'avatar' => $user->avatar ?? null,
            'roles' => method_exists($user, 'getRoleNames') ? $user->getRoleNames() : [],
            'permissions' => method_exists($user, 'getAllPermissions') ? $user->getAllPermissions()->pluck('name') : [],
            
            // Xử lý thông báo chưa đọc
            'unread_notifications_count' => $user->unreadNotifications()
                ->where('type', '!=', 'App\\Notifications\\NewChatMessageNotification')
                ->count(),
                
            'unread_chat_count' => Conversation::whereHas('messages', function ($query) {
                $query->where('sender_type', 'customer')->where('status', 'unread');
            })->count(),

            // Nạp top 5 thông báo mới nhất
            'notifications' => $user->notifications()
                ->where('type', '!=', 'App\\Notifications\\NewChatMessageNotification')
                ->take(5)
                ->get(),
        ];
    }
}
