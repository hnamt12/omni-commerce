<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'slug',
        'thumbnail',
        'summary',
        'content',
        'status',
        'views',
        'ai_model_source',
        'published_at',
        'meta_title',
        'meta_description',
    ];

    // Treat published_at as a Carbon object instance
    protected $casts = [
        'published_at' => 'datetime',
        'views' => 'integer',
    ];

    /** Valid values for the status column. */
    const STATUS_DRAFT = 'draft';

    const STATUS_AI_GENERATED = 'ai_generated';

    const STATUS_PUBLISHED = 'published';

    /**
     * Scope: only live posts (status=published AND published_at <= now or null).
     * Used by NewsController — do not remove.
     */
    public function scopePublished($query)
    {
        return $query->where('status', self::STATUS_PUBLISHED)
            ->where(function ($q) {
                $q->whereNull('published_at')
                    ->orWhere('published_at', '<=', now());
            });
    }

    /**
     * Estimated reading time in minutes (200 wpm, minimum 1).
     * Usage: $post->reading_time
     * Used by NewsController — do not remove.
     */
    public function getReadingTimeAttribute(): int
    {
        $text = strip_tags((string) $this->content);
        $wordCount = str_word_count($text);

        return max(1, (int) ceil($wordCount / 200));
    }

    /**
     * Auto-generate unique slug from title before saving.
     */
    protected static function booted(): void
    {
        static::creating(function (Post $post) {
            if (empty($post->slug)) {
                $post->slug = static::generateUniqueSlug($post->title);
            }
        });

        static::updating(function (Post $post) {
            if (empty($post->slug)) {
                $post->slug = static::generateUniqueSlug($post->title, $post->id);
            }
        });
    }

    protected static function generateUniqueSlug(string $title, ?int $excludeId = null): string
    {
        $base = Str::slug($title);
        $slug = $base;
        $i = 1;

        while (
            static::where('slug', $slug)
                ->when($excludeId, fn ($q) => $q->where('id', '!=', $excludeId))
                ->exists()
        ) {
            $slug = "{$base}-{$i}";
            $i++;
        }

        return $slug;
    }
}
