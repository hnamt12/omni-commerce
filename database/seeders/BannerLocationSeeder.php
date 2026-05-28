<?php

namespace Database\Seeders;

use App\Models\BannerLocation;
use Illuminate\Database\Seeder;

class BannerLocationSeeder extends Seeder
{
    public function run(): void
    {
        $locations = [
            ['code' => 'home_hero', 'name' => 'Slider Chính', 'description' => 'Banner to ở giữa. Nên dùng ảnh tỉ lệ 16:9.'],
            ['code' => 'home_hero_right', 'name' => '2 Banner Phải', 'description' => 'Nằm bên phải Slider. Tỉ lệ phù hợp: Chữ nhật ngang nhỏ.'],
            ['code' => 'home_hero_bottom', 'name' => 'Hàng Banner Dưới', 'description' => 'Nằm ngay dưới cụm Slider. Tối đa 4 cái xếp ngang.'],
            ['code' => 'home_mid', 'name' => 'Giữa Trang', 'description' => 'Banner ngang dài quảng cáo giữa các mục sản phẩm.'],
        ];

        foreach ($locations as $loc) {
            BannerLocation::updateOrCreate(
                ['code' => $loc['code']],
                ['name' => $loc['name'], 'description' => $loc['description']]
            );
        }
    }
}
