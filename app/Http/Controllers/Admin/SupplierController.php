<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Supplier;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SupplierController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');

        $query = Supplier::query();

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('code', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $suppliers = $query->orderByDesc('id')->paginate(15)->withQueryString();

        return Inertia::render('Admin/Suppliers/Index', [
            'suppliers' => $suppliers,
            'filters' => $request->only(['search']),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'code' => 'required|string|max:50|unique:suppliers,code',
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'address' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        Supplier::create($data);

        return redirect()->route('admin.suppliers.index')->with('success', 'Thêm nhà cung cấp thành công!');
    }

    public function update(Request $request, $id)
    {
        $supplier = Supplier::findOrFail($id);

        $data = $request->validate([
            'code' => 'required|string|max:50|unique:suppliers,code,'.$supplier->id,
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'address' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $supplier->update($data);

        return redirect()->route('admin.suppliers.index')->with('success', 'Cập nhật nhà cung cấp thành công!');
    }

    public function destroy($id)
    {
        $supplier = Supplier::findOrFail($id);
        $supplier->delete();

        return redirect()->route('admin.suppliers.index')->with('success', 'Xóa nhà cung cấp thành công!');
    }
}
