<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Traits\Auditable;

class Supplier extends Model
{
    use SoftDeletes, Auditable;

    protected $fillable = [
        'code',
        'name',
        'phone',
        'email',
        'address',
        'description',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function lots()
    {
        return $this->hasMany(ProductLot::class);
    }

    public function history()
    {
        return $this->hasMany(InventoryHistory::class);
    }
}
