<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Voucher;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Validation\Rule;

class VoucherController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');

        $query = Voucher::query();
        if ($search) {
            $query->where('code', 'LIKE', "%{$search}%");
        }
        $vouchers = $query->orderBy('created_at', 'desc')->paginate(10)->withQueryString();

        return Inertia::render('Admin/Vouchers/Index', [
            'vouchers' => $vouchers,
            'filters'  => ['search' => $search],
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Vouchers/Form', [
            'voucher' => null,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'                  => 'required|string|max:255',
            'code'                  => 'required|string|unique:vouchers,code|max:50',
            'scope'                 => ['required', Rule::in(['order', 'shipping'])],
            'type'                  => ['required', Rule::in(['percent', 'fixed'])],
            'discount_percentage'   => 'nullable|numeric|min:0|max:100',
            'discount_amount_fixed' => 'nullable|numeric|min:0',
            'max_discount_amount'   => 'nullable|numeric|min:0',
            'min_order_value'       => 'nullable|numeric|min:0',
            'usage_limit'           => 'nullable|integer|min:0',
            'limit_per_user'        => 'nullable|integer|min:0',
            'start_date'            => 'required|date',
            'end_date'              => 'required|date|after_or_equal:start_date',
            'is_active'             => 'boolean',
        ]);

        $data['code'] = strtoupper($data['code']);
        $data['is_active'] = $data['is_active'] ?? true;
        
        Voucher::create($data);

        return redirect()->route('admin.vouchers.index')->with('success', 'Đã tạo Voucher thành công!');
    }

    public function edit(Voucher $voucher)
    {
        return Inertia::render('Admin/Vouchers/Form', [
            'voucher' => $voucher,
        ]);
    }

    public function update(Request $request, Voucher $voucher)
    {
        $data = $request->validate([
            'name'                  => 'required|string|max:255',
            'code'                  => ['required','string','max:50', Rule::unique('vouchers', 'code')->ignore($voucher->id)],
            'scope'                 => ['required', Rule::in(['order', 'shipping'])],
            'type'                  => ['required', Rule::in(['percent', 'fixed'])],
            'discount_percentage'   => 'nullable|numeric|min:0|max:100',
            'discount_amount_fixed' => 'nullable|numeric|min:0',
            'max_discount_amount'   => 'nullable|numeric|min:0',
            'min_order_value'       => 'nullable|numeric|min:0',
            'usage_limit'           => 'nullable|integer|min:0',
            'limit_per_user'        => 'nullable|integer|min:0',
            'start_date'            => 'required|date',
            'end_date'              => 'required|date|after_or_equal:start_date',
            'is_active'             => 'boolean',
        ]);

        $data['code'] = strtoupper($data['code']);

        $voucher->update($data);

        return redirect()->route('admin.vouchers.index')->with('success', 'Cập nhật Voucher thành công!');
    }

    public function destroy(Voucher $voucher)
    {
        $voucher->delete();
        return redirect()->back()->with('success', 'Đã xóa Voucher!');
    }
}
