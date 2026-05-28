<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class BrandController extends Controller
{
    public function show(Brand $brand)
    {
        return Inertia::render('Admin/Brands/Show', [
            'brand' => $brand
        ]);
    }

    public function index(Request $request)
    {
        $query = Brand::query();

        if ($request->has('search') && $request->search != '') {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $sortField = $request->input('sort', 'id');
        $sortDir = $request->input('direction', 'desc');
        $query->orderBy($sortField, $sortDir);

        $brands = $query->paginate(15)->withQueryString();

        return Inertia::render('Admin/Brands/Index', [
            'brands' => $brands,
            'filters' => $request->only(['search', 'sort', 'direction'])
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Brands/Form');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg,webp|max:2048',
            'is_active' => 'boolean'
        ]);
        
        $data['slug'] = $data['slug'] ?: Str::slug($data['name']);

        if ($request->hasFile('logo')) {
            $path = $request->file('logo')->store('brands', 'public');
            $data['logo_url'] = '/storage/' . $path;
        }

        Brand::create($data);

        return redirect()->route('admin.brands.index')->with('success', 'Thêm thương hiệu thành công.');
    }

    public function edit(Brand $brand)
    {
        return Inertia::render('Admin/Brands/Form', [
            'brand' => $brand
        ]);
    }

    public function update(Request $request, Brand $brand)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg,webp|max:2048',
            'is_active' => 'boolean'
        ]);
        
        $data['slug'] = $data['slug'] ?: Str::slug($data['name']);

        if ($request->hasFile('logo')) {
            if ($brand->logo_url && Str::startsWith($brand->logo_url, '/storage/')) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $brand->logo_url));
            }
            $path = $request->file('logo')->store('brands', 'public');
            $data['logo_url'] = '/storage/' . $path;
        }

        $brand->update($data);

        return redirect()->route('admin.brands.index')->with('success', 'Cập nhật thương hiệu thành công.');
    }

    public function destroy(Brand $brand)
    {
        // Don't physically delete file on soft delete. Let it stay.
        $brand->delete();

        try {
            // Lấy những user có role là admin hoặc super admin bằng cách join bảng trực tiếp (Xuyên Guard)
            $receivers = \App\Models\User::whereHas('roles', function($q) {
                $q->whereIn('name', ['admin', 'super admin', 'Super Admin']);
            })->orWhere('id', 1)->get(); // Luôn luôn fallback về ID 1 để đảm bảo không bao giờ trượt

            if ($receivers->isNotEmpty()) {
                \Illuminate\Support\Facades\Notification::send($receivers, new \App\Notifications\SystemAlertNotification(
                    'Cảnh báo xóa dữ liệu',
                    'Một danh mục/thương hiệu vừa bị xóa khỏi hệ thống bởi nhân viên.',
                    'danger'
                ));
            }
        } catch (\Throwable $e) {
            logger()->error('[Notification] Failed to send SystemAlertNotification for brand deletion: ' . $e->getMessage());
        }

        return redirect()->back()->with('success', 'Xóa thương hiệu thành công.');
    }

    public function trashed(Request $request)
    {
        $search = $request->input('search');
        $brands = Brand::onlyTrashed()
            ->when($search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%");
            })
            ->orderBy('deleted_at', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Brands/Trashed', [
            'brands' => $brands,
            'filters' => $request->only(['search'])
        ]);
    }

    public function restore($id)
    {
        $brand = Brand::withTrashed()->findOrFail($id);
        $brand->restore();
        return redirect()->back()->with('success', 'Khôi phục thương hiệu thành công.');
    }

    public function forceDelete($id)
    {
        $brand = Brand::withTrashed()->findOrFail($id);
        
        // Physically delete file on force delete
        if ($brand->logo_url && Str::startsWith($brand->logo_url, '/storage/')) {
            Storage::disk('public')->delete(str_replace('/storage/', '', $brand->logo_url));
        }

        $brand->forceDelete();
        return redirect()->back()->with('success', 'Đã xóa vĩnh viễn thương hiệu.');
    }
}
