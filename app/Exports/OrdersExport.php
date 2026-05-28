<?php

namespace App\Exports;

use App\Models\Order;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithTitle;

class OrdersExport implements FromCollection, ShouldAutoSize, WithHeadings, WithMapping, WithTitle
{
    public function title(): string
    {
        return 'Danh sách Đơn hàng';
    }

    public function collection()
    {
        return Order::with('customer')->latest()->get();
    }

    public function headings(): array
    {
        return [
            'Mã Đơn Hàng',
            'Khách hàng',
            'Số Điện Thoại',
            'Tổng Tiền (đ)',
            'Trạng Thái Đơn',
            'Thanh Toán',
            'Ngày Đặt',
        ];
    }

    public function map($order): array
    {
        return [
            $order->order_code,
            $order->name,
            $order->phone,
            number_format($order->grand_total, 0, ',', '.'),
            $order->status,
            $order->payment_status === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán',
            $order->created_at->format('d/m/Y H:i'),
        ];
    }
}
