<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Inertia\Inertia;

class NewsController extends Controller
{
    /**
     * Public news listing page.
     *
     * Query params:
     *   sort  = latest (default) | popular
     *   page  = 1, 2, …
     */
    public function index(Request $request)
    {
        $sort = $request->input('sort', 'latest');

        // --- Featured post: single most-viewed published post ---
        $featured = Post::published()
            ->orderByDesc('views')
            ->select(['id', 'title', 'slug', 'thumbnail', 'summary', 'content', 'views', 'published_at', 'ai_model_source'])
            ->first();

        // --- Latest posts: exclude the featured one to avoid duplication ---
        $latestQuery = Post::published()
            ->select(['id', 'title', 'slug', 'thumbnail', 'summary', 'content', 'views', 'published_at', 'ai_model_source'])
            ->when($featured, fn ($q) => $q->where('id', '!=', $featured->id));

        if ($sort === 'popular') {
            $latestQuery->orderByDesc('views');
        } else {
            $latestQuery->orderByDesc('published_at');
        }

        $posts = $latestQuery->paginate(9)->withQueryString();

        // --- Trending sidebar: top 5 most-viewed (distinct from featured) ---
        $trending = Post::published()
            ->select(['id', 'title', 'slug', 'views', 'published_at'])
            ->when($featured, fn ($q) => $q->where('id', '!=', $featured->id))
            ->orderByDesc('views')
            ->limit(5)
            ->get();

        // Append reading_time accessor to each paginated result and featured
        $postsWithMeta = $posts->through(function (Post $post) {
            $post->append('reading_time');

            return $post;
        });

        return Inertia::render('Client/News/Index', [
            'featured' => $featured?->append('reading_time'),
            'posts' => $postsWithMeta,
            'trending' => $trending,
            'filters' => $request->only(['sort']),
        ]);
    }

    /**
     * Public single post detail page.
     */
    public function show(string $slug)
    {
        $post = Post::published()
            ->where('slug', $slug)
            ->firstOrFail();

        // Increment view counter
        $post->increment('views');

        // Related: same status, exclude current, ordered by views
        $related = Post::published()
            ->where('id', '!=', $post->id)
            ->select(['id', 'title', 'slug', 'thumbnail', 'summary', 'published_at', 'views'])
            ->orderByDesc('views')
            ->limit(4)
            ->get()
            ->each->append('reading_time');

        return Inertia::render('Client/News/Show', [
            'post' => $post->append('reading_time'),
            'related' => $related,
        ]);
    }
}
