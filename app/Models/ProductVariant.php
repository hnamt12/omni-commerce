<?php

namespace App\Models;

use App\Notifications\SystemAlertNotification;
use App\Traits\Auditable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Notification;

class ProductVariant extends Model
{
    use Auditable, SoftDeletes;

    protected static function booted()
    {
        static::updating(function ($variant) {
            if ($variant->isDirty('stock')) {
                $oldStock = (int) $variant->getOriginal('stock');
                $newStock = (int) $variant->stock;
                if ($newStock < $oldStock) {
                    // Stock was decremented (sale or subtraction) -> Apply FIFO logic
                    $qtyToDeduct = $oldStock - $newStock;
                    $lots = $variant->lots()->where('quantity', '>', 0)->orderBy('id', 'asc')->get();
                    foreach ($lots as $lot) {
                        if ($qtyToDeduct <= 0) {
                            break;
                        }
                        if ($lot->quantity >= $qtyToDeduct) {
                            $lot->decrement('quantity', $qtyToDeduct);
                            $qtyToDeduct = 0;
                        } else {
                            $qtyToDeduct -= $lot->quantity;
                            $lot->update(['quantity' => 0]);
                        }
                    }
                }
            }
        });

        static::updated(function ($variant) {
            if ($variant->isDirty('stock')) {
                $threshold = (int) Setting::get('min_stock_threshold', 10);
                $newStock = (int) $variant->stock;
                $oldStock = (int) $variant->getOriginal('stock');

                if ($newStock < $threshold && $oldStock >= $threshold) {
                    try {
                        $receivers = User::whereHas('roles', function ($q) {
                            $q->whereIn('name', ['admin', 'superadmin', 'super admin', 'Super Admin']);
                        })->orWhereHas('permissions', function ($q) {
                            $q->where('name', 'view_inventory');
                        })->orWhere('id', 1)->get();

                        if ($receivers->isNotEmpty()) {
                            $productName = $variant->product ? $variant->product->name : 'Sản phẩm';
                            $options = $variant->options;
                            $variantLabel = $options ? implode(' - ', array_values($options)) : 'Mặc định';

                            Notification::send(
                                $receivers,
                                new SystemAlertNotification(
                                    'Cảnh báo tồn kho thấp ⚠️',
                                    "Biến thể [{$variant->sku}] {$productName} ({$variantLabel}) đã giảm xuống {$newStock} sản phẩm (dưới ngưỡng tối thiểu {$threshold}). Vui lòng bổ sung kho hàng!",
                                    route('admin.inventory.edit', $variant->product_id),
                                    'low_stock'
                                )
                            );
                        }
                    } catch (\Throwable $e) {
                        logger()->error('[Notification] Failed to send SystemAlertNotification for low stock: '.$e->getMessage());
                    }
                }
            }
        });
    }

    protected $fillable = [
        'product_id',
        'sku',
        'price',
        'original_price',
        'sale_price',
        'cost_price',
        'stock',
        'image',
        'options',
    ];

    protected $appends = ['final_price'];

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'original_price' => 'decimal:2',
            'sale_price' => 'decimal:2',
            'cost_price' => 'decimal:2',
            'options' => 'array',
        ];
    }

    public function getFinalPriceAttribute()
    {
        return $this->sale_price > 0 ? $this->sale_price : $this->price;
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function attributeValues(): HasMany
    {
        return $this->hasMany(ProductVariantAttribute::class);
    }

    public function lots(): HasMany
    {
        return $this->hasMany(ProductLot::class, 'product_variant_id');
    }
}
