<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

/**
 * Thông báo gửi cho khách hàng khi trạng thái đơn hàng thay đổi.
 */
class OrderStatusNotification extends Notification implements ShouldQueue
{
    use Queueable;

    private string $orderCode;
    private string $oldStatus;
    private string $newStatus;
    private int $orderId;

    // Bản đồ màu/icon theo trạng thái đơn hàng
    private const STATUS_CONFIG = [
        'Chờ xác nhận'       => ['color' => 'bg-yellow-500 text-white', 'icon' => 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z'],
        'Đã xác nhận'        => ['color' => 'bg-blue-500 text-white',   'icon' => 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z'],
        'Đang chuẩn bị hàng' => ['color' => 'bg-indigo-500 text-white', 'icon' => 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4'],
        'Đang giao hàng'     => ['color' => 'bg-cyan-500 text-white',   'icon' => 'M8 17H5a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V15'],
        'Đã hoàn thành'      => ['color' => 'bg-emerald-500 text-white','icon' => 'M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z'],
        'Đã hủy'             => ['color' => 'bg-red-500 text-white',    'icon' => 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z'],
        'Giao hàng thất bại' => ['color' => 'bg-orange-500 text-white', 'icon' => 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z'],
        'Trả hàng/Hoàn tiền' => ['color' => 'bg-purple-500 text-white', 'icon' => 'M16 15v-1a4 4 0 00-4-4H8m0 0l3 3m-3-3l3-3m9 14V5a2 2 0 00-2-2H6a2 2 0 00-2 2v16l4-2 2 2 2-2 2 2 2-2 4 2z'],
    ];

    public function __construct(int $orderId, string $orderCode, string $oldStatus, string $newStatus)
    {
        $this->orderId   = $orderId;
        $this->orderCode = $orderCode;
        $this->oldStatus = $oldStatus;
        $this->newStatus = $newStatus;
    }

    /**
     * Kênh gửi thông báo.
     */
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    /**
     * Dữ liệu lưu vào database.
     */
    public function toArray(object $notifiable): array
    {
        $config = self::STATUS_CONFIG[$this->newStatus] ?? [
            'color' => 'bg-gray-500 text-white',
            'icon'  => 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
        ];

        return [
            'title'   => "Đơn hàng {$this->orderCode} đã cập nhật",
            'message' => "Trạng thái đơn hàng của bạn đã chuyển thành: {$this->newStatus}.",
            'url'     => route('client.order.show', $this->orderId),
            'icon'    => $config['icon'],
            'color'   => $config['color'],
        ];
    }
}
