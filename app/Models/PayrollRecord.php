<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Traits\Auditable;

class PayrollRecord extends Model
{
    use HasFactory, Auditable;

    protected $table = 'payroll_records';

    protected $fillable = [
        'user_id',
        'period_month',
        'period_year',
        'base_salary',
        'commission_amount',
        'bonus_amount',
        'deductions',
        'net_salary',
        'note',
        'paid_at',
        'created_by',
    ];

    protected $casts = [
        'period_month' => 'integer',
        'period_year' => 'integer',
        'base_salary' => 'decimal:2',
        'commission_amount' => 'decimal:2',
        'bonus_amount' => 'decimal:2',
        'deductions' => 'decimal:2',
        'net_salary' => 'decimal:2',
        'paid_at' => 'datetime',
    ];

    /**
     * Get the user who owns this payroll record.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Get the admin who created/approved this payroll record.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
