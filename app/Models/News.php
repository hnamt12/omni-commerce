<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class News extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'title',
        'slug',
        'content',
        'short_content',
        'category_news_id',
        'author_id',
        'thumbnail',
        'status',
        'views',
        'published_at',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'status' => 'boolean',
            'views' => 'integer',
            'published_at' => 'datetime',
        ];
    }

    public function categoryNews(): BelongsTo
    {
        return $this->belongsTo(CategoryNews::class);
    }

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'author_id');
    }
}
