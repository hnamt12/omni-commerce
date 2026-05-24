<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class PostController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $posts = Post::query()
            ->when($search, fn($q) => $q->where('title', 'like', "%{$search}%"))
            ->orderBy('created_at', 'desc')
            ->paginate(10)
            ->withQueryString();

        return Inertia::render('Admin/Posts/Index', [
            'posts' => $posts,
            'filters' => $request->only(['search']),
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Posts/Form');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title'            => 'required|string|max:255',
            'content'          => 'required|string',
            'thumbnail'        => 'nullable|image|max:2048',
            'summary'          => 'nullable|string',
            'status'           => 'required|in:draft,ai_generated,published',
            'published_at'     => 'nullable|date',
            'meta_title'       => 'nullable|string|max:255',
            'meta_description' => 'nullable|string',
        ]);

        $data = $request->only(['title', 'summary', 'content', 'status', 'meta_title', 'meta_description']);
        $data['slug']         = Str::slug($request->title) . '-' . time();
        $data['published_at'] = $request->filled('published_at') ? $request->published_at : now();

        if ($request->hasFile('thumbnail')) {
            $path = $request->file('thumbnail')->store('posts/thumbnails', 'public');
            $data['thumbnail'] = Storage::url($path);
        }

        Post::create($data);

        return redirect()->route('admin.posts.index')->with('success', 'Tạo bài viết mới thành công.');
    }

    public function edit(Post $post)
    {
        return Inertia::render('Admin/Posts/Form', [
            'post' => $post,
        ]);
    }

    public function update(Request $request, Post $post)
    {
        $request->validate([
            'title'            => 'required|string|max:255',
            'content'          => 'required|string',
            'thumbnail'        => 'nullable',
            'summary'          => 'nullable|string',
            'status'           => 'required|in:draft,ai_generated,published',
            'published_at'     => 'nullable|date',
            'meta_title'       => 'nullable|string|max:255',
            'meta_description' => 'nullable|string',
        ]);

        $data = $request->only(['title', 'summary', 'content', 'status', 'meta_title', 'meta_description']);
        if ($post->title !== $request->title) {
            $data['slug'] = Str::slug($request->title) . '-' . time();
        }
        $data['published_at'] = $request->filled('published_at') ? $request->published_at : $post->published_at;

        if ($request->hasFile('thumbnail')) {
            if ($post->thumbnail) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $post->thumbnail));
            }
            $path = $request->file('thumbnail')->store('posts/thumbnails', 'public');
            $data['thumbnail'] = Storage::url($path);
        }

        $post->update($data);

        return redirect()->route('admin.posts.index')->with('success', 'Cập nhật bài viết thành công.');
    }

    public function destroy(Post $post)
    {
        if ($post->thumbnail) {
            Storage::disk('public')->delete(str_replace('/storage/', '', $post->thumbnail));
        }
        $post->delete();

        return redirect()->back()->with('success', 'Đã xóa bài viết thành công.');
    }
}
