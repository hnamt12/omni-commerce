<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use App\Models\Message;

class NewChatMessageNotification extends Notification
{
    use Queueable;

    private Message $message;
    private string $customerName;

    /**
     * Create a new notification instance.
     */
    public function __construct(Message $message, string $customerName)
    {
        $this->message = $message;
        $this->customerName = $customerName;
    }

    /**
     * Get the notification's delivery channels.
     */
    public function via($notifiable): array
    {
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     */
    public function toArray(object $notifiable): array
    {
        $content = $this->message->type === 'img' ? '📷 Đã gửi một ảnh' : $this->message->content;
        return [
            'title'   => 'Tin nhắn mới từ ' . $this->customerName,
            'message' => $content,
            'url'     => '/admin/chat?conversation_id=' . $this->message->conversation_id,
            'icon'    => 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z', // Chat bubble SVG path
            'color'   => 'bg-orange-500 text-white',
            'type'    => 'new_chat_message',
            'conversation_id' => $this->message->conversation_id,
        ];
    }
}
