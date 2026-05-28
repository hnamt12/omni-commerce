<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Traits\Auditable;

class PaymentMethod extends Model
{
    use HasFactory, Auditable;

    protected $fillable = [
        'name',
        'code',
        'description',
        'type',
        'logo_url',
        'config',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'config'    => 'encrypted:json',   // Tự động mã hóa JSON khi lưu vào DB (CRITICAL-3)
        'is_active' => 'boolean',
    ];
}
