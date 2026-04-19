<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn #{{ $order->order_code }}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; font-size: 13px; color: #1a1a2e; background: #fff; }

        .invoice-wrap { max-width: 800px; margin: 0 auto; padding: 32px; }

        /* Header */
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 3px solid #4f46e5; padding-bottom: 20px; margin-bottom: 24px; }
        .company-info h1 { font-size: 26px; font-weight: 900; color: #4f46e5; letter-spacing: -0.5px; }
        .company-info p { font-size: 12px; color: #6b7280; margin-top: 2px; }
        .invoice-meta { text-align: right; }
        .invoice-meta h2 { font-size: 22px; font-weight: 800; color: #1f2937; }
        .invoice-meta .badge { display: inline-block; background: #ede9fe; color: #4f46e5; padding: 4px 12px; border-radius: 99px; font-size: 11px; font-weight: 700; margin-top: 6px; }
        .invoice-meta p { font-size: 12px; color: #6b7280; margin-top: 4px; }

        /* Info Grid */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .info-box { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 8px; padding: 14px 18px; }
        .info-box .label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #9ca3af; margin-bottom: 8px; }
        .info-box p { font-size: 13px; color: #374151; line-height: 1.6; }
        .info-box p strong { color: #111827; }

        /* Table */
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        thead { background: #4f46e5; color: white; }
        thead th { padding: 10px 14px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; text-align: left; }
        thead th:last-child { text-align: right; }
        tbody tr:nth-child(even) { background: #f9fafb; }
        tbody td { padding: 10px 14px; font-size: 13px; color: #374151; border-bottom: 1px solid #f3f4f6; vertical-align: top; }
        tbody td:nth-child(3), tbody td:nth-child(4), tbody td:last-child { text-align: right; }

        /* Totals */
        .totals { width: 320px; margin-left: auto; border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; }
        .totals-row { display: flex; justify-content: space-between; padding: 9px 16px; font-size: 13px; border-bottom: 1px solid #f3f4f6; }
        .totals-row:last-child { border-bottom: none; background: #4f46e5; color: white; font-weight: 700; font-size: 15px; }
        .totals-row.discount { color: #10b981; }
        .totals-row .key { color: inherit; }

        /* Footer */
        .footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: flex-end; gap: 20px; }
        .note { font-size: 12px; color: #6b7280; max-width: 350px; line-height: 1.6; }
        .note strong { color: #374151; }
        .signature { text-align: center; min-width: 180px; }
        .signature-line { border-top: 1px solid #9ca3af; margin-top: 50px; padding-top: 8px; font-size: 12px; color: #6b7280; }

        /* VAT box */
        .vat-notice { background: #fffbeb; border: 1px solid #fcd34d; border-radius: 6px; padding: 8px 14px; font-size: 12px; color: #92400e; margin-bottom: 16px; }

        @media print {
            body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .no-print { display: none !important; }
            .invoice-wrap { padding: 0; max-width: 100%; }
        }
    </style>
</head>
<body>
    <div class="invoice-wrap">

        <!-- Header -->
        <div class="header">
            <div class="company-info">
                <h1>⚡ OmniCommerce</h1>
                <p>Địa chỉ: 123 Nguyễn Huệ, Q.1, TP. Hồ Chí Minh</p>
                <p>Hotline: 1800 9999 · Email: hi@omnicommerce.vn</p>
                <p>MST: 0312345678</p>
            </div>
            <div class="invoice-meta">
                <h2>HÓA ĐƠN BÁN HÀNG</h2>
                <span class="badge">#{{ $order->order_code }}</span>
                <p>Ngày: {{ $order->created_at->format('d/m/Y H:i') }}</p>
                <p>Trạng thái: <strong>{{ $order->status }}</strong></p>
            </div>
        </div>

        <!-- Info Grid -->
        <div class="info-grid">
            <div class="info-box">
                <div class="label">Thông tin khách hàng</div>
                <p><strong>{{ $order->name }}</strong></p>
                <p>SĐT: {{ $order->phone }}</p>
                <p>{{ $order->email ?? 'N/A' }}</p>
                <p>Địa chỉ: {{ $order->address }}</p>
            </div>
            <div class="info-box">
                <div class="label">Chi tiết thanh toán</div>
                <p>Hình thức: <strong>{{ $order->payment_method === 'cod' ? 'COD (Thu khi giao)' : 'Thanh toán Online' }}</strong></p>
                <p>Trạng thái quỹ: <strong>{{ $order->payment_status === 'paid' ? '✅ Đã thu tiền' : '⏳ Chưa thu' }}</strong></p>
                @if($order->voucher_code)
                <p>Voucher: <strong>{{ $order->voucher_code }}</strong></p>
                @endif
            </div>
        </div>

        <!-- Products Table -->
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Sản phẩm</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $i => $item)
                <tr>
                    <td>{{ $i + 1 }}</td>
                    <td>
                        <strong>{{ $item->product_name }}</strong>
                        @if($item->variant_options)
                            @php $opts = is_string($item->variant_options) ? json_decode($item->variant_options, true) : $item->variant_options; @endphp
                            <br><small style="color:#9ca3af">{{ implode(' - ', array_values($opts ?? [])) }}</small>
                        @endif
                    </td>
                    <td>{{ number_format($item->price, 0, ',', '.') }} ₫</td>
                    <td>{{ $item->quantity }}</td>
                    <td><strong>{{ number_format($item->price * $item->quantity, 0, ',', '.') }} ₫</strong></td>
                </tr>
                @endforeach
            </tbody>
        </table>

        <!-- VAT Notice -->
        @if($order->tax_amount > 0)
        <div class="vat-notice">
            ⚠️ Hóa đơn bao gồm Thuế GTGT (VAT) 10% = <strong>{{ number_format($order->tax_amount, 0, ',', '.') }} ₫</strong>
        </div>
        @endif

        <!-- Totals -->
        <div class="totals">
            <div class="totals-row"><span class="key">Tổng tiền hàng:</span><span>{{ number_format($order->subtotal, 0, ',', '.') }} ₫</span></div>
            <div class="totals-row"><span class="key">Phí vận chuyển:</span><span>{{ number_format($order->shipping_fee, 0, ',', '.') }} ₫</span></div>
            @if($order->discount_amount > 0)
            <div class="totals-row discount"><span class="key">Giảm giá voucher:</span><span>-{{ number_format($order->discount_amount, 0, ',', '.') }} ₫</span></div>
            @endif
            @if($order->shipping_discount_amount > 0)
            <div class="totals-row discount"><span class="key">Giảm phí ship:</span><span>-{{ number_format($order->shipping_discount_amount, 0, ',', '.') }} ₫</span></div>
            @endif
            @if($order->tax_amount > 0)
            <div class="totals-row"><span class="key">VAT (10%):</span><span>{{ number_format($order->tax_amount, 0, ',', '.') }} ₫</span></div>
            @endif
            <div class="totals-row"><span class="key">Thành tiền:</span><span>{{ number_format($order->grand_total, 0, ',', '.') }} ₫</span></div>
        </div>

        <!-- Footer -->
        <div class="footer">
            <div class="note">
                <strong>Lưu ý:</strong> Đây là hóa đơn bán hàng điện tử. Mọi thắc mắc vui lòng liên hệ hotline <strong>1800 9999</strong>.<br>
                Xin chân thành cảm ơn quý khách đã tin tưởng OmniCommerce!
            </div>
            <div class="signature">
                <div>Đại diện người bán</div>
                <div class="signature-line">Ký tên & Đóng dấu</div>
            </div>
        </div>

    </div>
    <script>
        window.onload = function() { window.print(); }
    </script>
</body>
</html>
