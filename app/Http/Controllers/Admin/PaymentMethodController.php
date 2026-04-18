<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PaymentMethod;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PaymentMethodController extends Controller
{
    // ─────────────────────────────────────────────
    //  List all payment methods
    // ─────────────────────────────────────────────
    public function index()
    {
        $methods = PaymentMethod::orderBy('sort_order')->get();
        return Inertia::render('Admin/PaymentMethod/Index', ['methods' => $methods]);
    }

    // ─────────────────────────────────────────────
    //  Create new payment method
    // ─────────────────────────────────────────────
    public function store(Request $request)
    {
        $data = $request->validate([
            'name'      => 'required|string',
            'code'      => 'required|string|unique:payment_methods,code',
            'type'      => 'required|in:gateway,manual,cod',
            'logo_url'  => 'nullable|string',
            'config'    => 'nullable|array',
            'is_active' => 'boolean',
        ]);

        PaymentMethod::create($data);
        return back()->with('success', 'Đã thêm phương thức thanh toán!');
    }

    // ─────────────────────────────────────────────
    //  Update existing payment method
    // ─────────────────────────────────────────────
    public function update(Request $request, PaymentMethod $paymentMethod)
    {
        $data = $request->validate([
            'name'      => 'required|string',
            'code'      => 'required|string|unique:payment_methods,code,' . $paymentMethod->id,
            'type'      => 'required|in:gateway,manual,cod',
            'logo_url'  => 'nullable|string',
            'config'    => 'nullable|array',
        ]);

        $paymentMethod->update($data);
        return back()->with('success', 'Đã cập nhật cấu hình!');
    }

    // ─────────────────────────────────────────────
    //  Toggle active/inactive
    // ─────────────────────────────────────────────
    public function toggle(PaymentMethod $paymentMethod)
    {
        $paymentMethod->update(['is_active' => !$paymentMethod->is_active]);
        return back()->with('success', 'Đã thay đổi trạng thái hoạt động!');
    }

    // ─────────────────────────────────────────────
    //  Delete payment method
    // ─────────────────────────────────────────────
    public function destroy(PaymentMethod $paymentMethod)
    {
        $paymentMethod->delete();
        return back()->with('success', 'Đã xóa phương thức thanh toán!');
    }
}
