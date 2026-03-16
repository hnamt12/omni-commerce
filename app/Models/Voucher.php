<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Voucher extends Model
{
    protected $fillable = [
        'code',
        'scope',
        'type',
        'discount_percentage',
        'discount_amount_fixed',
        'max_discount_amount',
        'min_order_value',
        'usage_limit',
        'start_date',
        'end_date',
        'is_active',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'discount_percentage' => 'decimal:2',
            'discount_amount_fixed' => 'decimal:2',
            'max_discount_amount' => 'decimal:2',
            'min_order_value' => 'decimal:2',
            'usage_limit' => 'integer',
            'start_date' => 'datetime',
            'end_date' => 'datetime',
            'is_active' => 'boolean',
        ];
    }
}
