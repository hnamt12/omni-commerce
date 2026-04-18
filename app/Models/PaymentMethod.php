<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PaymentMethod extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'code',
        'type',
        'logo_url',
        'config',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'config'    => 'array',   // JSON → PHP array automatically
        'is_active' => 'boolean',
    ];
}
