<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\User;
use App\Notifications\NewChatMessageNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Notification;

class ChatController extends Controller
{
    // ──────────────────────────────────────────────────────────────
    //  ADMIN – Các API dành cho Admin (guard: web)
    // ──────────────────────────────────────────────────────────────

    /**
     * 1. Lấy danh sách hội thoại (Admin)
     */
    public function index()
    {
        $conversations = Conversation::with(['customer', 'messages' => function ($query) {
            $query->latest()->limit(1);
        }])
            ->withCount(['messages as unread_messages_count' => function ($query) {
                $query->where('sender_type', 'customer')->where('status', 'unread');
            }])
            ->get();

        return response()->json($conversations);
    }

    /**
     * 2. Lấy danh sách tin nhắn của 1 hội thoại cụ thể (Admin)
     */
    public function getMessages($conversationId)
    {
        // Mark all customer messages in this conversation as read
        Message::where('conversation_id', $conversationId)
            ->where('sender_type', 'customer')
            ->where('status', 'unread')
            ->update(['status' => 'read']);

        // Mark database notifications for this conversation as read for the current user
        if ($user = Auth::user()) {
            $user->unreadNotifications()
                ->where('type', 'App\Notifications\NewChatMessageNotification')
                ->where('data->conversation_id', (int) $conversationId)
                ->get()
                ->each(function ($notification) {
                    $notification->markAsRead();
                });
        }

        $messages = Message::where('conversation_id', $conversationId)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json($messages);
    }

    /**
     * 3. Admin gửi tin nhắn và phát sóng (Broadcast)
     */
    public function sendMessage(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'type' => 'nullable|in:text,img',
        ]);

        $content = $request->content;

        // Xử lý upload ảnh (lưu URL thay vì Base64)
        if ($request->type === 'img' && $request->hasFile('image')) {
            $path = $request->file('image')->store('chat_images', 'public');
            $content = '/storage/'.$path;
        } else {
            $request->validate([
                'content' => 'required|string',
            ]);
        }

        $message = Message::create([
            'conversation_id' => $request->conversation_id,
            'sender_id' => Auth::id() ?? 1,
            'sender_type' => 'admin',
            'content' => $content,
            'type' => $request->type ?? 'text',
            'status' => 'unread',
        ]);

        // Phát sóng tin nhắn qua Pusher (trigger event MessageSent)
        broadcast(new MessageSent($message));

        return response()->json($message);
    }

    // ──────────────────────────────────────────────────────────────
    //  CLIENT – Các API dành cho Customer (guard: customer)
    // ──────────────────────────────────────────────────────────────

    /**
     * 4. Customer khởi tạo hoặc lấy lại conversation hiện có
     *    POST /chat/start
     *    → Trả về { conversation, messages }
     */
    public function startOrGetConversation()
    {
        $customer = Auth::guard('customer')->user();

        // Tìm conversation active của customer (mỗi customer chỉ có 1 conversation active)
        $conversation = Conversation::where('customer_id', $customer->id)
            ->where('status', 'active')
            ->first();

        // Nếu chưa có → tạo mới
        if (! $conversation) {
            $conversation = Conversation::create([
                'customer_id' => $customer->id,
                'admin_id' => null, // Chưa assign admin
                'status' => 'active',
            ]);
        }

        // Lấy tất cả tin nhắn của conversation
        $messages = $conversation->messages()
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'conversation' => $conversation,
            'messages' => $messages,
        ]);
    }

    /**
     * 5. Customer gửi tin nhắn
     *    POST /chat/send
     *    → Kiểm tra customer chỉ gửi vào conversation của chính mình
     */
    public function customerSendMessage(Request $request)
    {
        $customer = Auth::guard('customer')->user();

        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'type' => 'nullable|in:text,img',
        ]);

        // ★ Bảo mật: Đảm bảo customer chỉ gửi vào conversation của chính mình
        $conversation = Conversation::where('id', $request->conversation_id)
            ->where('customer_id', $customer->id)
            ->firstOrFail();

        $content = $request->content;

        // Xử lý upload ảnh
        if ($request->type === 'img' && $request->hasFile('image')) {
            $path = $request->file('image')->store('chat_images', 'public');
            $content = '/storage/'.$path;
        } else {
            $request->validate([
                'content' => 'required|string',
            ]);
        }

        $message = Message::create([
            'conversation_id' => $conversation->id,
            'sender_id' => $customer->id,
            'sender_type' => 'customer',
            'content' => $content,
            'type' => $request->type ?? 'text',
            'status' => 'unread',
        ]);

        // Phát sóng tin nhắn qua Pusher
        broadcast(new MessageSent($message));

        // Gửi thông báo database tới Admin
        try {
            $receivers = User::whereHas('roles', function ($q) {
                $q->whereIn('name', ['admin', 'super admin', 'Super Admin']);
            })->orWhereIn('id', [1, 2])->get();

            if ($receivers->isNotEmpty()) {
                Notification::send($receivers, new NewChatMessageNotification($message, $customer->name));
            }
        } catch (\Throwable $e) {
            logger()->error('[Notification] Failed to send NewChatMessageNotification: '.$e->getMessage());
        }

        return response()->json($message);
    }

    /**
     * Lấy các tin nhắn chưa đọc từ khách hàng để hiển thị trên Header chuông.
     */
    public function getUnreadNotifications()
    {
        $unreadMessages = Message::where('sender_type', 'customer')
            ->where('status', 'unread')
            ->with('conversation.customer')
            ->latest()
            ->take(50)
            ->get();

        $notifications = $unreadMessages->map(function ($message) {
            $customerName = $message->conversation->customer->name ?? 'Khách hàng #'.$message->conversation->customer_id;

            return [
                'id' => 'chat-'.$message->id.'-'.strtotime($message->created_at),
                'type' => 'chat',
                'conversationId' => $message->conversation_id,
                'customerName' => $customerName,
                'content' => $message->type === 'img' ? '📷 Đã gửi một ảnh' : $message->content,
                'time' => $message->created_at->toIso8601String(),
                'read' => false,
            ];
        });

        return response()->json($notifications);
    }
}
