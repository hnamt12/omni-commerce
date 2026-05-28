<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductLot extends Model
{
    protected $fillable = [
        'product_variant_id',
        'supplier_id',
        'lot_number',
        'expiry_date',
        'quantity',
        'initial_quantity',
    ];

    protected $casts = [
        'expiry_date' => 'date',
        'quantity' => 'integer',
        'initial_quantity' => 'integer',
    ];

    public function variant()
    {
        return $this->belongsTo(ProductVariant::class, 'product_variant_id');
    }

    public function supplier()
    {
        return $this->belongsTo(Supplier::class);
    }
}
