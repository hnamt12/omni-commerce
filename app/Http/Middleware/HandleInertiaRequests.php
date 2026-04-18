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
        // Cart count: distinct cart rows = number of different items in bag
        $cartCount = 0;
        if ($customerId = auth('customer')->id()) {
            $cartCount = Cart::where('customer_id', '=', $customerId)->count();
        }

        return [
            'auth' => [
                // Admin (guard: web) — getRoleNames only for Spatie users, never for customers
                'user' => function () use ($request) {
                    $user = $request->user(); // web guard only
                    if (!$user) return null;
                    return [
                        'id'          => $user->id,
                        'name'        => $user->name,
                        'email'       => $user->email,
                        'roles'       => method_exists($user, 'getRoleNames') ? $user->getRoleNames() : [],
                        'permissions' => method_exists($user, 'getAllPermissions') ? $user->getAllPermissions()->pluck('name') : [],
                    ];
                },
                // Client (guard: customer) — plain data, no Spatie methods
                'customer' => fn () => auth('customer')->user()
                    ? auth('customer')->user()->only(['id', 'name', 'email', 'avatar'])
                    : null,
            ],
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error'   => fn () => $request->session()->get('error'),
            ],
            'cartCount' => $cartCount,
        ];
    }
}
