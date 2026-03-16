<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderItem extends Model
{
    protected $fillable = [
        'order_id',
        'product_id',
        'variant_id',
        'name',
        'sku_code',
        'image_url',
        'variant_options',
        'quantity',
        'price',
        'total_price',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'variant_options' => 'array',
            'quantity' => 'integer',
            'price' => 'decimal:2',
            'total_price' => 'decimal:2',
        ];
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function variant(): BelongsTo
    {
        return $this->belongsTo(ProductVariant::class, 'variant_id');
    }
}
