<?php

use App\Models\Conversation;
use App\Models\Customer;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

/*
|--------------------------------------------------------------------------
| Chat Channel – Xác thực quyền truy cập hội thoại
|--------------------------------------------------------------------------
| Cho phép truy cập nếu:
|   - User là Admin (guard: web)  → admin luôn có quyền xem tất cả hội thoại
|   - User là Customer (guard: customer) → chỉ được vào conversation của chính mình
*/
Broadcast::channel('chat.{conversationId}', function ($user, $conversationId) {
    // Admin (User model) – được phép truy cập mọi conversation
    if ($user instanceof User) {
        return true;
    }

    // Customer – chỉ được vào conversation thuộc về mình
    if ($user instanceof Customer) {
        return Conversation::where('id', $conversationId)
            ->where('customer_id', $user->id)
            ->exists();
    }

    return false;
}, ['guards' => ['web', 'customer']]);

Broadcast::channel('admin.chat-list', function ($user) {
    return $user instanceof User;
}, ['guards' => ['web']]);

Broadcast::channel('admin-notifications', function ($user) {
    return $user instanceof User;
}, ['guards' => ['web']]);
