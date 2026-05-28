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
            'map_embed_code' => '',
            'min_stock_threshold' => '10',
            'company_name' => 'Công ty TNHH OmniCommerce',
            'company_address' => '123 Nguyễn Huệ, Q.1, TP. Hồ Chí Minh',
            'company_phone' => '1800 9999',
            'company_email' => 'hi@omnicommerce.vn',
            'company_mst' => '0312345678',
            'invoice_serial_prefix' => 'AA/22E',
            'invoice_template_code' => '01GTKT0/001',
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
            'min_stock_threshold' => 'nullable|numeric|min:0',
            'company_name' => 'nullable|string|max:255',
            'company_address' => 'nullable|string|max:255',
            'company_phone' => 'nullable|string|max:50',
            'company_email' => 'nullable|email|max:255',
            'company_mst' => 'nullable|string|max:50',
            'invoice_serial_prefix' => 'nullable|string|max:50',
            'invoice_template_code' => 'nullable|string|max:50',
        ]);

        foreach ($data as $key => $value) {
            Setting::updateOrCreate(['key' => $key], ['value' => $value]);
        }

        return redirect()->back()->with('success', 'Cập nhật cấu hình thành công.');
    }
}
