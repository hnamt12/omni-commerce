<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

/**
 * Thông báo gửi tới Admin khi có đơn hàng mới.
 */
class NewOrderNotification extends Notification
{
    use Queueable;

    private $order;

    /**
     * Nhận vào object Order đầy đủ (eager-load customer nếu cần).
     */
    public function __construct($order)
    {
        $this->order = $order;
    }

    /**
     * Kênh gửi thông báo.
     */
    public function via($notifiable): array
    {
        return ['database'];
    }

    /**
     * Dữ liệu lưu vào bảng notifications — chuẩn cho Frontend Vue.
     */
    public function toArray(object $notifiable): array
    {
        $customerName = $this->order->customer?->name
            ?? $this->order->name    // Đơn POS hoặc khách vãng lai
            ?? 'Khách vãng lai';

        return [
            'title'   => 'Đơn hàng mới nhận!',
            'message' => "Khách hàng {$customerName} vừa đặt đơn hàng #{$this->order->id} (Mã: {$this->order->order_code}).",
            'url'     => '/admin/orders/' . $this->order->id,
            'icon'    => 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z', // Shopping bag SVG path
            'color'   => 'bg-emerald-500 text-white',
            'type'    => 'new_order',
        ];
    }
}
