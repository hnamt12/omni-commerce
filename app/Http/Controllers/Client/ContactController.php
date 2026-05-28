<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Inertia\Inertia;

class ContactController extends Controller
{
    public function index()
    {
        $keys = ['contact_phone', 'contact_email', 'contact_address', 'google_maps_iframe'];
        $settings = Setting::whereIn('key', $keys)->pluck('value', 'key');

        return Inertia::render('Client/Contact/Index', [
            'settings' => $settings,
        ]);
    }
}
