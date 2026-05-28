<?php

namespace Database\Factories;

use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<Product>
 */
class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = $this->faker->unique()->sentence(3);

        return [
            'name' => rtrim($name, '.'),
            'slug' => Str::slug($name),
            'sku' => $this->faker->unique()->bothify('PROD-####-????'),
            'base_price' => $this->faker->randomFloat(2, 1000000, 50000000),
            'description' => $this->faker->paragraph(3),
            'is_active' => true,
            'specifications' => [
                'RAM' => $this->faker->randomElement(['4GB', '8GB', '16GB', '32GB']),
                'Storage' => $this->faker->randomElement(['128GB', '256GB', '512GB', '1TB']),
                'Color' => $this->faker->colorName(),
                'Screen' => $this->faker->randomElement(['6.1 inch', '6.5 inch', '6.7 inch']),
            ],
        ];
    }
}
