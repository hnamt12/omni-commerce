<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Models\Cart;

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
        // Cart count & Favorites:
        $cartCount = 0;
        $favoriteProductIds = [];
        if ($customerId = auth('customer')->id()) {
            $cartCount = Cart::where('customer_id', '=', $customerId)->count();
            $favoriteProductIds = \App\Models\Favorite::where('customer_id', $customerId)->pluck('product_id')->toArray();
        }

        // BẮT BUỘC PHẢI DÙNG array_merge VỚI parent::share
        return array_merge(parent::share($request), [
            'auth' => [
                // Admin (guard: web)
                'user' => function () use ($request) {
                    $user = $request->user(); // web guard only
                    if (!$user) return null;
                    return [
                        'id'          => $user->id,
                        'name'        => $user->name,
                        'email'       => $user->email,
                        'avatar'      => $user->avatar ?? null,
                        'roles'       => method_exists($user, 'getRoleNames') ? $user->getRoleNames() : [],
                        'permissions' => method_exists($user, 'getAllPermissions') ? $user->getAllPermissions()->pluck('name') : [],
                        
                        // Đếm số lượng thông báo chưa đọc cho Badge đỏ (loại trừ thông báo chat)
                        'unread_notifications_count' => $user->unreadNotifications()->where('type', '!=', 'App\\Notifications\\NewChatMessageNotification')->count(),
                        'unread_chat_count' => \App\Models\Conversation::whereHas('messages', function ($query) {
                            $query->where('sender_type', 'customer')->where('status', 'unread');
                        })->count(),
                        
                        // Lấy 5 thông báo mới nhất (đã đọc và chưa đọc) để hiển thị trong Dropdown cái chuông (loại trừ thông báo chat)
                        'notifications' => $user->notifications()->where('type', '!=', 'App\\Notifications\\NewChatMessageNotification')->take(5)->get(),
                    ];
                },
                // Client (guard: customer)
                'customer' => fn () => auth('customer')->user()
                    ? auth('customer')->user()->only(['id', 'name', 'email', 'avatar'])
                    : null,
            ],
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error'   => fn () => $request->session()->get('error'),
            ],
            'cartCount' => $cartCount,
            'favoriteProductIds' => $favoriteProductIds,
        ]);
    }
}
