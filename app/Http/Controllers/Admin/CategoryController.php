<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\User;
use App\Notifications\SystemAlertNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CategoryController extends Controller
{
    public function show(Category $category)
    {
        return Inertia::render('Admin/Categories/Show', [
            'category' => $category->load('parent'),
        ]);
    }

    public function index(Request $request)
    {
        $query = Category::with('parent');

        if ($request->has('search') && $request->search != '') {
            $query->where('name', 'like', '%'.$request->search.'%');
        }

        $sortField = $request->input('sort', 'id');
        $sortDir = $request->input('direction', 'desc');
        $query->orderBy($sortField, $sortDir);

        $categories = $query->paginate(15)->withQueryString();

        return Inertia::render('Admin/Categories/Index', [
            'categories' => $categories,
            'filters' => $request->only(['search', 'sort', 'direction']),
        ]);
    }

    public function create()
    {
        $parentCategories = Category::whereNull('parent_id')->orWhere('parent_id', 0)->get();

        return Inertia::render('Admin/Categories/Form', [
            'parentCategories' => $parentCategories,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'parent_id' => 'nullable|exists:categories,id',
            'is_active' => 'boolean',
        ]);

        $data['slug'] = Str::slug($data['name']);
        if (empty($data['parent_id'])) {
            $data['parent_id'] = null;
        }

        Category::create($data);

        return redirect()->route('admin.categories.index')->with('success', 'Thêm danh mục thành công.');
    }

    public function edit(Category $category)
    {
        $parentCategories = Category::whereNull('parent_id')->orWhere('parent_id', 0)->get();

        return Inertia::render('Admin/Categories/Form', [
            'category' => $category,
            'parentCategories' => $parentCategories,
        ]);
    }

    public function update(Request $request, Category $category)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'parent_id' => 'nullable|exists:categories,id',
            'is_active' => 'boolean',
        ]);

        $data['slug'] = Str::slug($data['name']);
        if (empty($data['parent_id'])) {
            $data['parent_id'] = null;
        }

        $category->update($data);

        return redirect()->route('admin.categories.index')->with('success', 'Cập nhật danh mục thành công.');
    }

    public function destroy(Category $category)
    {
        $category->delete();

        try {
            // Lấy những user có role là admin hoặc super admin bằng cách join bảng trực tiếp (Xuyên Guard)
            $receivers = User::whereHas('roles', function ($q) {
                $q->whereIn('name', ['admin', 'super admin', 'Super Admin']);
            })->orWhere('id', 1)->get(); // Luôn luôn fallback về ID 1 để đảm bảo không bao giờ trượt

            if ($receivers->isNotEmpty()) {
                Notification::send($receivers, new SystemAlertNotification(
                    'Cảnh báo xóa dữ liệu',
                    'Một danh mục/thương hiệu vừa bị xóa khỏi hệ thống bởi nhân viên.',
                    'danger'
                ));
            }
        } catch (\Throwable $e) {
            logger()->error('[Notification] Failed to send SystemAlertNotification for category deletion: '.$e->getMessage());
        }

        return redirect()->back()->with('success', 'Xóa danh mục thành công.');
    }

    public function trashed(Request $request)
    {
        $search = $request->input('search');
        $categories = Category::onlyTrashed()
            ->when($search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%");
            })
            ->orderBy('deleted_at', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Categories/Trashed', [
            'categories' => $categories,
            'filters' => $request->only(['search']),
        ]);
    }

    public function restore($id)
    {
        $category = Category::withTrashed()->findOrFail($id);
        $category->restore();

        return redirect()->back()->with('success', 'Khôi phục danh mục thành công.');
    }

    public function forceDelete($id)
    {
        $category = Category::withTrashed()->findOrFail($id);
        $category->forceDelete();

        return redirect()->back()->with('success', 'Đã xóa vĩnh viễn danh mục.');
    }
}
