<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phiếu Lấy Hàng (Picking Slip) #{{ $order->order_code }}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; font-size: 13px; color: #1e293b; background: #fff; }

        .picking-wrap { max-width: 800px; margin: 0 auto; padding: 32px; }

        /* Banner cảnh báo là phiếu nội bộ kho */
        .warehouse-badge {
            background: #f8fafc;
            border: 2px dashed #94a3b8;
            color: #475569;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            font-weight: 800;
            font-size: 14px;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 24px;
        }

        /* Header */
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #334155; padding-bottom: 16px; margin-bottom: 24px; }
        .company-info h1 { font-size: 24px; font-weight: 900; color: #1e293b; }
        .company-info p { font-size: 11px; color: #64748b; margin-top: 2px; }
        .slip-meta { text-align: right; }
        .slip-meta h2 { font-size: 20px; font-weight: 800; color: #b91c1c; }
        .slip-meta .order-id { font-family: monospace; font-size: 16px; font-weight: 700; color: #475569; margin-top: 4px; }
        .slip-meta p { font-size: 11px; color: #64748b; margin-top: 4px; }

        /* Picking Info Table */
        .info-table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        .info-table td { padding: 8px 12px; font-size: 12px; border: 1px solid #e2e8f0; }
        .info-table td.label { font-weight: 700; background: #f8fafc; color: #475569; width: 15%; }
        .info-table td.value { color: #1e293b; width: 35%; }

        /* Items Table */
        .items-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .items-table th { padding: 12px 14px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; text-align: left; background: #334155; color: white; border: 1px solid #334155; }
        .items-table td { padding: 14px; font-size: 13px; color: #1e293b; border: 1px solid #e2e8f0; vertical-align: middle; }
        
        /* Monospace font for warehouse codes */
        .sku-code { font-family: 'Consolas', 'Courier New', monospace; font-size: 14px; font-weight: bold; color: #0f172a; background: #f1f5f9; padding: 4px 8px; border-radius: 4px; border: 1px solid #e2e8f0; }
        
        .checkbox-cell { text-align: center; width: 50px; }
        .checkbox-box { width: 20px; height: 20px; border: 2px solid #64748b; border-radius: 4px; display: inline-block; }

        .qty-badge { display: inline-block; background: #fee2e2; color: #991b1b; padding: 6px 12px; border-radius: 6px; font-size: 16px; font-weight: 900; border: 1px solid #fecaca; }

        /* Footer Checklist area */
        .checker-section { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; border-top: 2px solid #e2e8f0; padding-top: 20px; margin-top: 40px; }
        .checker-box { text-align: center; border: 1px solid #cbd5e1; border-radius: 8px; padding: 16px; min-height: 120px; background: #f8fafc; }
        .checker-box .title { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #64748b; margin-bottom: 50px; }
        .checker-box .name { font-size: 12px; color: #94a3b8; border-top: 1px dashed #cbd5e1; padding-top: 6px; }

        @media print {
            body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .no-print { display: none !important; }
            .picking-wrap { padding: 0; max-width: 100%; }
        }
    </style>
</head>
<body>
    <div class="picking-wrap">
        
        <!-- Warehouse Internal Banner -->
        <div class="warehouse-badge">
            ⚠️ TÀI LIỆU NỘI BỘ KHO - KHÔNG GIAO CHO KHÁCH HÀNG ⚠️
        </div>

        <!-- Header -->
        <div class="header">
            <div class="company-info">
                <h1>⚡ OmniCommerce WH</h1>
                <p>Hệ thống Quản lý Kho bãi thông minh OmniCommerce</p>
                <p>Khu vực soạn hàng: Tầng 1 - Line A</p>
            </div>
            <div class="slip-meta">
                <h2>PHIẾU LẤY HÀNG</h2>
                <div class="order-id">Đơn hàng: {{ $order->order_code }}</div>
                <p>Ngày in: {{ now()->format('d/m/Y H:i') }}</p>
                <p>Người in: <strong>{{ auth()->user()->name ?? 'System' }}</strong></p>
            </div>
        </div>

        <!-- Order details -->
        <table class="info-table">
            <tr>
                <td class="label">Hình thức giao</td>
                <td class="value"><strong>{{ $order->payment_method === 'cod' ? 'Giao hàng thu tiền (COD)' : 'Thanh toán trước (Chuyển khoản)' }}</strong></td>
                <td class="label">Người soạn hàng</td>
                <td class="value">................................................</td>
            </tr>
            <tr>
                <td class="label">SĐT Khách</td>
                <td class="value">{{ $order->phone }}</td>
                <td class="label">Thời gian soạn</td>
                <td class="value">........ h ........ ngày ...../...../.....</td>
            </tr>
            <tr>
                <td class="label">Địa chỉ nhận</td>
                <td class="value" colspan="3">{{ $order->address }}</td>
            </tr>
        </table>

        <!-- Pick Items List -->
        <table class="items-table">
            <thead>
                <tr>
                    <th class="checkbox-cell">Lấy</th>
                    <th style="width: 25%;">Mã SKU</th>
                    <th>Tên Sản phẩm / Phân loại</th>
                    <th style="width: 15%; text-align: center;">Số lượng cần</th>
                    <th class="checkbox-cell">Kiểm</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $i => $item)
                <tr>
                    <td class="checkbox-cell">
                        <div class="checkbox-box"></div>
                    </td>
                    <td>
                        <span class="sku-code">{{ $item->variant->sku ?? $item->product->sku ?? 'N/A' }}</span>
                    </td>
                    <td>
                        <div style="font-weight: 800; font-size: 14px; margin-bottom: 4px;">{{ $item->product_name ?? $item->product->name }}</div>
                        @if($item->variant_options)
                            @php $opts = is_string($item->variant_options) ? json_decode($item->variant_options, true) : $item->variant_options; @endphp
                            <div style="color: #64748b; font-size: 11px; font-weight: 600;">
                                Phân loại: {{ implode(' - ', array_values($opts ?? [])) }}
                            </div>
                        @endif
                    </td>
                    <td style="text-align: center;">
                        <span class="qty-badge">{{ $item->quantity }}</span>
                    </td>
                    <td class="checkbox-cell">
                        <div class="checkbox-box"></div>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>

        <!-- Warehouse signoff -->
        <div class="checker-section">
            <div class="checker-box">
                <div class="title">1. Nhân viên Soạn hàng</div>
                <div class="name">Ký & ghi rõ họ tên</div>
            </div>
            <div class="checker-box">
                <div class="title">2. Nhân viên Kiểm hàng</div>
                <div class="name">Ký & ghi rõ họ tên</div>
            </div>
            <div class="checker-box">
                <div class="title">3. Nhân viên Đóng gói</div>
                <div class="name">Ký & ghi rõ họ tên</div>
            </div>
        </div>

    </div>
    <script>
        window.onload = function() { window.print(); }
    </script>
</body>
</html>
