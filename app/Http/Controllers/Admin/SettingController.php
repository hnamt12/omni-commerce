<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SettingController extends Controller
{
    public function index()
    {
        // Safe fallback: Ensure default settings exist
        $defaultKeys = [
            'contact_phone' => '', 
            'contact_email' => '', 
            'contact_address' => '', 
            'map_embed_code' => ''
        ];
        
        foreach ($defaultKeys as $key => $val) {
            Setting::firstOrCreate(['key' => $key], ['value' => $val]);
        }

        $settings = Setting::all()->pluck('value', 'key');
        
        return Inertia::render('Admin/Settings/Index', [
            'settings' => $settings
        ]);
    }

    public function update(Request $request)
    {
        $data = $request->validate([
            'contact_phone' => 'nullable|string',
            'contact_email' => 'nullable|email',
            'contact_address' => 'nullable|string',
            'map_embed_code' => 'nullable|string',
        ]);

        foreach ($data as $key => $value) {
            Setting::updateOrCreate(['key' => $key], ['value' => $value]);
        }

        return redirect()->back()->with('success', 'Cập nhật cấu hình thành công.');
    }
}
