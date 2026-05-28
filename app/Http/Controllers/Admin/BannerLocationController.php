<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\BannerLocation;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BannerLocationController extends Controller
{
    public function index()
    {
        $locations = BannerLocation::orderBy('id', 'desc')->get();

        return Inertia::render('Admin/BannerLocations/Index', [
            'locations' => $locations,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:255|unique:banner_locations,code',
            'description' => 'nullable|string|max:255',
            'is_active' => 'boolean',
        ]);

        $data['is_active'] = $request->is_active ?? true;

        BannerLocation::create($data);

        return redirect()->route('admin.banner-locations.index')->with('success', 'Đã thêm Vị trí Banner thành công!');
    }

    public function update(Request $request, BannerLocation $bannerLocation)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:255|unique:banner_locations,code,'.$bannerLocation->id,
            'description' => 'nullable|string|max:255',
            'is_active' => 'boolean',
        ]);

        $bannerLocation->update($data);

        return redirect()->route('admin.banner-locations.index')->with('success', 'Vị trí Banner đã được cập nhật!');
    }

    public function destroy(BannerLocation $bannerLocation)
    {
        $bannerLocation->delete();

        return redirect()->route('admin.banner-locations.index')->with('success', 'Vị trí Banner đã được xóa!');
    }
}
