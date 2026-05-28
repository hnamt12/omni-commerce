<?php

namespace App\Notifications;

use App\Models\Product;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

/**
 * Thông báo nhắc nhở khách hàng đánh giá sản phẩm sau khi đơn hàng hoàn thành.
 */
class ReviewPromptNotification extends Notification implements ShouldQueue
{
    use Queueable;

    private string $orderCode;

    private int $productId;

    private string $productName;

    private ?string $productThumb;

    public function __construct(
        string $orderCode,
        int $productId,
        string $productName,
        ?string $productThumb = null
    ) {
        $this->orderCode = $orderCode;
        $this->productId = $productId;
        $this->productName = $productName;
        $this->productThumb = $productThumb;
    }

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        // Try to resolve product slug for direct deep-link to #reviews
        $product = Product::find($this->productId);
        $url = $product
            ? route('client.products.show', $product->slug).'#reviews'
            : route('client.products.show', $this->productId).'#reviews';

        return [
            'title' => "Đánh giá đơn hàng #{$this->orderCode}",
            'message' => "Bạn đã nhận «{$this->productName}»! Hãy chia sẻ trải nghiệm của bạn để giúp cộng đồng.",
            'url' => $url,
            'icon' => 'M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z',
            'color' => 'bg-amber-500 text-white',
            'product_id' => $this->productId,
            'product_name' => $this->productName,
            'product_thumb' => $this->productThumb,
            'type' => 'review_prompt',
        ];
    }
}
