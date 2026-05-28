<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Banner;
use App\Models\BannerLocation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class BannerController extends Controller
{
    public function index()
    {
        $locations = BannerLocation::where('is_active', true)->get();
        $banners = Banner::orderBy('sort_order', 'asc')->get();

        // Nhóm banner theo mã code của location
        $groupedBanners = [];
        foreach ($locations as $loc) {
            $groupedBanners[$loc->code] = $banners->where('position', $loc->code)->values()->all();
        }

        return Inertia::render('Admin/Banners/Index', [
            'locations' => $locations,
            'groupedBanners' => $groupedBanners,
        ]);
    }

    public function create()
    {
        $locations = BannerLocation::where('is_active', true)->get();

        return Inertia::render('Admin/Banners/Form', [
            'banner' => null,
            'locations' => $locations,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'images' => 'required|array',
            'images.*' => 'image|max:2048',
            'position' => 'required|string',
            'title' => 'nullable|string',
            'link_url' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        foreach ($request->file('images') as $file) {
            $path = $file->store('banners', 'public');
            Banner::create([
                'title' => $request->title ?? 'Banner',
                'image_url' => '/storage/'.$path,
                'link_url' => $request->link_url,
                'position' => $request->position,
                'sort_order' => Banner::where('position', '=', $request->position)->max('sort_order') + 1,
                'is_active' => $request->is_active ?? true,
            ]);
        }

        return redirect()->route('admin.banners.index')->with('success', 'Đã thêm banner thành công!');
    }

    public function edit($id)
    {
        $banner = Banner::findOrFail($id);
        $locations = BannerLocation::where('is_active', true)->get();

        return Inertia::render('Admin/Banners/Form', [
            'banner' => $banner,
            'locations' => $locations,
        ]);
    }

    public function update(Request $request, Banner $banner)
    {
        // When using method spoofing (POST with _method=PUT) in Inertia for file uploads, we can still validate the request
        $data = $request->validate([
            'title' => 'nullable|string|max:255',
            'images' => 'nullable|array',
            'images.*' => 'image|max:2048',
            'link_url' => 'nullable|string',
            'position' => 'required|string',
            'sort_order' => 'integer',
            'is_active' => 'boolean',
        ]);

        if ($request->hasFile('images')) {
            // Edit usually replaces with one single image even if the form allows multiple
            $file = $request->file('images')[0];
            // Delete old image
            if ($banner->image_url && str_starts_with($banner->image_url, '/storage/')) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $banner->image_url));
            }
            $path = $file->store('banners', 'public');
            $data['image_url'] = '/storage/'.$path;
            unset($data['images']);
        }

        $data['title'] = $request->title ?? 'Banner';

        $banner->update($data);

        return redirect()->route('admin.banners.index')->with('success', 'Banner đã được cập nhật!');
    }

    public function destroy(Banner $banner)
    {
        if ($banner->image_url && str_starts_with($banner->image_url, '/storage/')) {
            Storage::disk('public')->delete(str_replace('/storage/', '', $banner->image_url));
        }
        $banner->delete();

        return back()->with('success', 'Banner đã xóa!');
    }

    public function reorder(Request $request)
    {
        $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required|exists:banners,id',
            'items.*.sort_order' => 'required|integer',
        ]);

        foreach ($request->items as $item) {
            Banner::where('id', $item['id'])->update(['sort_order' => $item['sort_order']]);
        }

        return back()->with('success', 'Thứ tự banner đã được cập nhật.');
    }
}
