<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CustomerController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $status = $request->input('status'); // 'active', 'inactive'

        $query = Customer::query();

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        if ($status !== null && $status !== '') {
            $isActive = $status === 'active';
            $query->where('is_active', $isActive);
        }

        $customers = $query->latest()
            ->paginate(15)
            ->withQueryString();

        // Simple aggregation stats
        $totalCustomers = Customer::count();
        $activeCustomers = Customer::where('is_active', true)->count();
        $inactiveCustomers = Customer::where('is_active', false)->count();

        return Inertia::render('Admin/Customers/Index', [
            'customers' => $customers,
            'stats' => [
                'total' => $totalCustomers,
                'active' => $activeCustomers,
                'inactive' => $inactiveCustomers,
            ],
            'filters' => $request->only(['search', 'status']),
        ]);
    }

    public function toggleStatus($id)
    {
        $customer = Customer::findOrFail($id);
        $customer->is_active = ! $customer->is_active;
        $customer->save();

        return redirect()->back()->with('success', 'Đã cập nhật trạng thái khách hàng.');
    }

    public function destroy($id)
    {
        $customer = Customer::findOrFail($id);
        $customer->delete();

        return redirect()->back()->with('success', 'Đã xóa khách hàng thành công.');
    }
}
