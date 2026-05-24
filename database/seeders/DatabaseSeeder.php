<?php

namespace Database\Seeders;

use App\Models\Brand;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Require role permissions to be seeded first
        $this->call(RolePermissionSeeder::class);
        $this->call(PaymentMethodSeeder::class);

        // Generate Dummy Data
        $brands = Brand::factory(5)->create();
        $categories = Category::factory(10)->create();

        // Generate 50 Products
        Product::factory(50)->make()->each(function (Product $product) use ($brands, $categories) {
            $product->brand_id = $brands->random()->id;
            $product->category_id = $categories->random()->id;
            $product->save();
        });
    }
}
