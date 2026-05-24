<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    public function run(): void
    {
        $settings = [
            ['key' => 'contact_phone', 'value' => '1900 1234'],
            ['key' => 'contact_email', 'value' => 'support@omnicommerce.vn'],
            ['key' => 'contact_address', 'value' => '123 Đường Công Nghệ, Quận 1, TP. HCM'],
            ['key' => 'google_maps_iframe', 'value' => '<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.424167419729!2d106.698426015334!3d10.7788193620959!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f4007b8eb55%3A0xc32dc48d795b6c!2sBitexco%20Financial%20Tower!5e0!3m2!1sen!2s!4v1620000000000!5m2!1sen!2s" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>'],
        ];

        foreach ($settings as $setting) {
            Setting::updateOrCreate(['key' => $setting['key']], ['value' => $setting['value']]);
        }
    }
}
