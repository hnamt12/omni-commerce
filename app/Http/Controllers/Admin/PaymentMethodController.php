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
        // Safe fallback: Ensure COD exists as a basic default method
        PaymentMethod::firstOrCreate(
            ['code' => 'cod'],
            ['name' => 'Thanh toán khi nhận hàng (COD)', 'type' => 'cod', 'is_active' => true]
        );

        // Safe fallback sorting to prevent database exceptions if sort_order column is missing
        $methods = PaymentMethod::query()->orderBy('id', 'asc')->get();

        // dd($methods->toArray());
        return Inertia::render('Admin/PaymentMethod/Index', [
            'methods' => $methods,
        ]);
    }

    // ─────────────────────────────────────────────
    //  Create new payment method
    // ─────────────────────────────────────────────
    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
            'code' => 'required|string|unique:payment_methods,code',
            'description' => 'nullable|string',
            'type' => 'required|in:gateway,manual,cod',
            'logo_url' => 'nullable|string',
            'config' => 'nullable|array',
            'is_active' => 'boolean',
        ]);

        try {
            PaymentMethod::create($data);

            return back()->with('success', 'Đã thêm phương thức thanh toán!');
        } catch (\Exception $e) {
            return back()->withErrors(['error' => 'Lỗi DB: '.$e->getMessage()]);
        }
    }

    // ─────────────────────────────────────────────
    //  Update existing payment method
    // ─────────────────────────────────────────────
    public function update(Request $request, PaymentMethod $paymentMethod)
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'code' => 'sometimes|string|unique:payment_methods,code,'.$paymentMethod->id,
            'type' => 'sometimes|in:gateway,manual,cod',
            'logo_url' => 'nullable|string|max:500',
            'is_active' => 'sometimes|boolean',
            'config' => 'nullable|array',
        ]);

        $updateData = [];
        if ($request->has('name')) {
            $updateData['name'] = $request->input('name');
        }
        if ($request->has('code')) {
            $updateData['code'] = $request->input('code');
        }
        if ($request->has('type')) {
            $updateData['type'] = $request->input('type');
        }
        if ($request->has('logo_url')) {
            $updateData['logo_url'] = $request->input('logo_url');
        }
        if ($request->has('is_active')) {
            $updateData['is_active'] = $request->boolean('is_active');
        }
        if ($request->has('config')) {
            $updateData['config'] = $request->input('config', []);
        }

        try {
            $paymentMethod->update($updateData);

            return back()->with('success', 'Cập nhật cấu hình thanh toán thành công.');
        } catch (\Exception $e) {
            return back()->withErrors(['error' => 'Lỗi DB: '.$e->getMessage()]);
        }
    }

    // ─────────────────────────────────────────────
    //  Toggle active/inactive
    // ─────────────────────────────────────────────
    public function toggle(PaymentMethod $paymentMethod)
    {
        $paymentMethod->update(['is_active' => ! $paymentMethod->is_active]);

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
