@php
    $companyName = $settings['company_name'] ?? 'Công ty TNHH OmniCommerce';
    $companyAddress = $settings['company_address'] ?? '123 Nguyễn Huệ, Q.1, TP. Hồ Chí Minh';
    $companyPhone = $settings['company_phone'] ?? '1800 9999';
    $companyEmail = $settings['company_email'] ?? 'hi@omnicommerce.vn';
    $companyMst = $settings['company_mst'] ?? '0312345678';
    $serial = $order->vat_invoice_serial ?? $settings['invoice_serial_prefix'] ?? 'AA/22E';
    $template = $order->vat_invoice_template ?? $settings['invoice_template_code'] ?? '01GTKT0/001';
    $invNum = $order->vat_invoice_number ?? str_pad($order->id, 7, '0', STR_PAD_LEFT);
    
    // QR Code to trace order online
    $trackingUrl = url('/don-hang/' . $order->id);
    $qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=' . urlencode($trackingUrl);

    // Number to words converter in Vietnamese
    if (!function_exists('convert_number_to_words')) {
        function convert_number_to_words($number) {
            $hyphen      = ' ';
            $conjunction = ' ';
            $separator   = ' ';
            $negative    = 'âm ';
            $decimal     = ' phẩy ';
            $dictionary  = array(
                0                   => 'không',
                1                   => 'một',
                2                   => 'hai',
                3                   => 'ba',
                4                   => 'bốn',
                5                   => 'năm',
                6                   => 'sáu',
                7                   => 'bảy',
                8                   => 'tám',
                9                   => 'chín',
                10                  => 'mười',
                11                  => 'mười một',
                12                  => 'mười hai',
                13                  => 'mười ba',
                14                  => 'mười bốn',
                15                  => 'mười lăm',
                16                  => 'mười sáu',
                17                  => 'mười bảy',
                18                  => 'mười tám',
                19                  => 'mười chín',
                20                  => 'hai mươi',
                30                  => 'ba mươi',
                40                  => 'bốn mươi',
                50                  => 'năm mươi',
                60                  => 'sáu mươi',
                70                  => 'bảy mươi',
                80                  => 'tám mươi',
                90                  => 'chín mươi',
                100                 => 'trăm',
                1000                => 'nghìn',
                1000000             => 'triệu',
                1000000000          => 'tỷ'
            );

            if (!is_numeric($number)) {
                return false;
            }

            if ($number < 0) {
                return $negative . convert_number_to_words(abs($number));
            }

            $string = $fraction = null;

            if (strpos($number, '.') !== false) {
                list($number, $fraction) = explode('.', $number);
            }

            switch (true) {
                case $number < 21:
                    $string = $dictionary[$number];
                    break;
                case $number < 100:
                    $tens   = ((int) ($number / 10)) * 10;
                    $ones   = $number % 10;
                    $string = $dictionary[$tens];
                    if ($ones) {
                        $string .= $hyphen . ($ones == 1 ? 'mốt' : ($ones == 5 ? 'lăm' : $dictionary[$ones]));
                    }
                    break;
                case $number < 1000:
                    $hundreds  = $number / 100;
                    $remainder = $number % 100;
                    $string = $dictionary[(int)$hundreds] . ' ' . $dictionary[100];
                    if ($remainder) {
                        $string .= $conjunction . ($remainder < 10 ? 'lẻ ' : '') . convert_number_to_words($remainder);
                    }
                    break;
                default:
                    $baseUnit = pow(1000, floor(log($number, 1000)));
                    $numBaseUnits = (int) ($number / $baseUnit);
                    $remainder = $number % $baseUnit;
                    $string = convert_number_to_words($numBaseUnits) . ' ' . $dictionary[$baseUnit];
                    if ($remainder) {
                        $string .= $remainder < 100 ? $conjunction . 'lẻ ' : $separator;
                        $string .= convert_number_to_words($remainder);
                    }
                    break;
            }

            return $string;
        }
    }

    $grandTotalWords = ucfirst(convert_number_to_words((int)$order->grand_total)) . ' đồng chẵn.';
@endphp
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn VAT #{{ $invNum }}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        @if(($paperSize ?? 'a4') === 'k80')
        /* K80 Thermal Paper Styling */
        body { font-family: 'Arial', sans-serif; font-size: 11px; color: #000; background: #fff; line-height: 1.4; padding: 4px; }
        .invoice-wrap { max-width: 80mm; width: 100%; margin: 0 auto; padding: 0; }
        .header { text-align: center; border-bottom: 1px dashed #000; padding-bottom: 8px; margin-bottom: 8px; }
        .header h1 { font-size: 15px; font-weight: bold; text-transform: uppercase; }
        .header h2 { font-size: 13px; font-weight: bold; margin-top: 2px; }
        .header p { font-size: 9px; color: #444; }
        .info-grid { font-size: 10px; margin-bottom: 8px; border-bottom: 1px dashed #000; padding-bottom: 8px; }
        .info-grid p { margin-bottom: 2px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 10px; }
        thead th { border-bottom: 1px solid #000; padding: 4px 0; text-align: left; }
        thead th:last-child { text-align: right; }
        tbody td { padding: 4px 0; border-bottom: 1px dashed #eee; vertical-align: top; }
        tbody td:last-child { text-align: right; }
        .totals { border-top: 1px solid #000; padding-top: 6px; font-size: 10px; margin-bottom: 10px; }
        .totals-row { display: flex; justify-content: space-between; padding: 2px 0; }
        .totals-row.grand { font-size: 12px; font-weight: bold; border-top: 1px dashed #000; padding-top: 4px; }
        .qr-section { text-align: center; margin: 10px 0; padding-top: 6px; border-top: 1px dashed #000; }
        .qr-section p { font-size: 8px; color: #555; margin-top: 4px; }
        .footer { text-align: center; font-size: 9px; margin-top: 8px; border-top: 1px dashed #000; padding-top: 8px; }
        .signature-section { display: none; }
        @else
        /* A4 Full Invoice Styling */
        body { font-family: 'Segoe UI', Arial, sans-serif; font-size: 13px; color: #1e293b; background: #fff; }
        .invoice-wrap { max-width: 800px; margin: 0 auto; padding: 40px; }
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 3px solid #4f46e5; padding-bottom: 20px; margin-bottom: 24px; }
        .company-info h1 { font-size: 24px; font-weight: 900; color: #4f46e5; }
        .company-info p { font-size: 12px; color: #64748b; margin-top: 2px; }
        .invoice-meta { text-align: right; }
        .invoice-meta h2 { font-size: 22px; font-weight: 800; color: #1e293b; }
        .invoice-meta p { font-size: 12px; color: #64748b; margin-top: 4px; }
        .invoice-meta .inv-details { font-family: monospace; font-size: 13px; color: #475569; margin-top: 6px; background: #f8fafc; border: 1px solid #e2e8f0; padding: 6px 12px; border-radius: 6px; display: inline-block; text-align: left; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .info-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px 18px; }
        .info-box .label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #94a3b8; margin-bottom: 8px; }
        .info-box p { font-size: 13px; color: #334155; line-height: 1.6; }
        .info-box p strong { color: #0f172a; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        thead { background: #4f46e5; color: white; }
        thead th { padding: 10px 14px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; text-align: left; }
        thead th:last-child { text-align: right; }
        tbody tr:nth-child(even) { background: #f8fafc; }
        tbody td { padding: 10px 14px; font-size: 13px; color: #334155; border-bottom: 1px solid #f1f5f9; vertical-align: top; }
        tbody td:nth-child(3), tbody td:nth-child(4), tbody td:last-child { text-align: right; }
        .totals-section { display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; }
        .qr-code-box { border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; text-align: center; font-size: 11px; color: #64748b; background: #f8fafc; max-width: 140px; }
        .totals { width: 320px; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; }
        .totals-row { display: flex; justify-content: space-between; padding: 9px 16px; font-size: 13px; border-bottom: 1px solid #f1f5f9; }
        .totals-row:last-child { border-bottom: none; background: #4f46e5; color: white; font-weight: 700; font-size: 15px; }
        .totals-row.discount { color: #10b981; }
        .words-section { background: #fef3c7; border: 1px solid #fde68a; border-radius: 8px; padding: 12px 18px; font-size: 13px; font-weight: 600; color: #92400e; margin-bottom: 24px; text-transform: capitalize; }
        .signature-section { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-top: 40px; text-align: center; }
        .signature-box { min-height: 140px; display: flex; flex-col; justify-content: space-between; }
        .signature-box .title { font-weight: bold; color: #1e293b; }
        .signature-box .sign-here { font-size: 11px; color: #94a3b8; font-style: italic; margin-top: 50px; border-top: 1px dashed #cbd5e1; padding-top: 8px; }
        .footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #e2e8f0; font-size: 12px; color: #64748b; line-height: 1.6; }
        @endif

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
                <h1>⚡ {{ $companyName }}</h1>
                <p>Địa chỉ: {{ $companyAddress }}</p>
                <p>Hotline: {{ $companyPhone }} · Email: {{ $companyEmail }}</p>
                <p>Mã Số Thuế (MST): <strong>{{ $companyMst }}</strong></p>
            </div>
            
            @if(($paperSize ?? 'a4') !== 'k80')
            <div class="invoice-meta">
                <h2>HÓA ĐƠN GIÁ TRỊ GIA TĂNG</h2>
                <div class="inv-details">
                    Mẫu số: <strong>{{ $template }}</strong><br>
                    Ký hiệu: <strong>{{ $serial }}</strong><br>
                    Số Hóa Đơn: <strong style="color: #b91c1c;">{{ $invNum }}</strong>
                </div>
                <p>Ngày lập: {{ $order->created_at->format('d/m/Y H:i') }}</p>
            </div>
            @else
            <div style="margin-top: 4px;">
                <h2>HÓA ĐƠN BÁN LẺ POS</h2>
                <p>Số HĐ: #{{ $order->order_code }}</p>
                <p>Ngày: {{ $order->created_at->format('d/m/Y H:i') }}</p>
            </div>
            @endif
        </div>

        <!-- Info Grid -->
        <div class="info-grid">
            @if(($paperSize ?? 'a4') !== 'k80')
            <div class="info-box">
                <div class="label">Đơn vị bán hàng</div>
                <p><strong>{{ $companyName }}</strong></p>
                <p>MST: {{ $companyMst }}</p>
                <p>Địa chỉ: {{ $companyAddress }}</p>
            </div>
            <div class="info-box">
                <div class="label">Người mua hàng</div>
                <p><strong>{{ $order->name }}</strong></p>
                <p>SĐT: {{ $order->phone }}</p>
                <p>Địa chỉ: {{ $order->address }}</p>
                <p>Hình thức: <strong>{{ $order->payment_method === 'cod' ? 'COD (Thu khi giao)' : 'Chuyển khoản / Online' }}</strong></p>
            </div>
            @else
            <div>
                <p>Khách hàng: <strong>{{ $order->name }}</strong></p>
                <p>SĐT: {{ $order->phone }}</p>
                <p>Địa chỉ: {{ $order->address }}</p>
                <p>Thanh toán: {{ $order->payment_method === 'cod' ? 'COD (Chưa thanh toán)' : 'Đã thanh toán Online' }}</p>
            </div>
            @endif
        </div>

        <!-- Products Table -->
        <table>
            <thead>
                <tr>
                    @if(($paperSize ?? 'a4') !== 'k80')
                    <th style="width: 5%">#</th>
                    @endif
                    <th>Sản phẩm</th>
                    <th style="text-align: right;">Đơn giá</th>
                    <th style="text-align: center; width: 12%;">SL</th>
                    <th style="text-align: right;">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $i => $item)
                <tr>
                    @if(($paperSize ?? 'a4') !== 'k80')
                    <td>{{ $i + 1 }}</td>
                    @endif
                    <td>
                        <strong>{{ $item->product_name }}</strong>
                        @if($item->variant_options)
                            @php $opts = is_string($item->variant_options) ? json_decode($item->variant_options, true) : $item->variant_options; @endphp
                            <br><small style="color:#64748b">{{ implode(' - ', array_values($opts ?? [])) }}</small>
                        @endif
                    </td>
                    <td style="text-align: right;">{{ number_format($item->price, 0, ',', '.') }} đ</td>
                    <td style="text-align: center;">{{ $item->quantity }}</td>
                    <td style="text-align: right;"><strong>{{ number_format($item->price * $item->quantity, 0, ',', '.') }} đ</strong></td>
                </tr>
                @endforeach
            </tbody>
        </table>

        <!-- Grand Total In Words (A4 Only) -->
        @if(($paperSize ?? 'a4') !== 'k80')
        <div class="words-section">
            ✍️ <strong>Số tiền viết bằng chữ:</strong> {{ $grandTotalWords }}
        </div>
        @endif

        <!-- Totals & QR Section -->
        @if(($paperSize ?? 'a4') !== 'k80')
        <div class="totals-section">
            
            <!-- QR code to lookup online -->
            <div class="qr-code-box">
                <img src="{{ $qrCodeUrl }}" alt="QR Code">
                <p style="margin-top: 6px; font-weight: bold; font-size: 9px;">QUÉT ĐỂ TRA CỨU ĐƠN HÀNG</p>
            </div>

            <!-- Totals box -->
            <div class="totals">
                <div class="totals-row"><span class="key">Tổng tiền hàng chưa thuế:</span><span>{{ number_format($order->subtotal - $order->tax_amount, 0, ',', '.') }} ₫</span></div>
                <div class="totals-row"><span class="key">Phí vận chuyển:</span><span>{{ number_format($order->shipping_fee, 0, ',', '.') }} ₫</span></div>
                @if($order->discount_amount > 0)
                <div class="totals-row discount"><span class="key">Giảm giá voucher:</span><span>-{{ number_format($order->discount_amount, 0, ',', '.') }} ₫</span></div>
                @endif
                @if($order->tax_amount > 0)
                <div class="totals-row"><span class="key">Thuế suất GTGT (10%):</span><span>{{ number_format($order->tax_amount, 0, ',', '.') }} ₫</span></div>
                @endif
                <div class="totals-row"><span class="key">Tổng cộng thanh toán:</span><span>{{ number_format($order->grand_total, 0, ',', '.') }} ₫</span></div>
            </div>
        </div>
        @else
        <!-- K80 Totals condensed format -->
        <div class="totals">
            <div class="totals-row"><span>Tạm tính:</span><span>{{ number_format($order->subtotal, 0, ',', '.') }} đ</span></div>
            @if($order->shipping_fee > 0)
            <div class="totals-row"><span>Phí ship:</span><span>+{{ number_format($order->shipping_fee, 0, ',', '.') }} đ</span></div>
            @endif
            @if($order->discount_amount > 0)
            <div class="totals-row" style="color: green;"><span>Giảm voucher:</span><span>-{{ number_format($order->discount_amount, 0, ',', '.') }} đ</span></div>
            @endif
            @if($order->tax_amount > 0)
            <div class="totals-row"><span>Thuế VAT (10%):</span><span>{{ number_format($order->tax_amount, 0, ',', '.') }} đ</span></div>
            @endif
            <div class="totals-row grand"><span>TỔNG THANH TOÁN:</span><span>{{ number_format($order->grand_total, 0, ',', '.') }} đ</span></div>
        </div>

        <!-- K80 QR code -->
        <div class="qr-section">
            <img src="{{ $qrCodeUrl }}" style="width: 90px; height: 90px;" alt="QR Code">
            <p>Quét mã để tra cứu hóa đơn trực tuyến</p>
        </div>
        @endif

        <!-- Signature Section (A4 Only) -->
        @if(($paperSize ?? 'a4') !== 'k80')
        <div class="signature-section">
            <div class="signature-box">
                <div class="title">Người mua hàng</div>
                <div class="sign-here">(Ký, ghi rõ họ tên)</div>
            </div>
            <div class="signature-box">
                <div class="title">Người bán hàng</div>
                <div style="font-size: 10px; color: #475569; font-weight: bold; border: 2px solid #b91c1c; border-radius: 6px; padding: 4px; display: inline-block; max-width: 220px; margin: 10px auto; background: #fff1f2;">
                    KÝ BỞI: {{ $companyName }}<br>
                    Mã số thuế: {{ $companyMst }}<br>
                    Thời gian ký: {{ now()->format('d/m/Y H:i:s') }}
                </div>
                <div class="sign-here">Chữ ký điện tử / Con dấu hợp pháp</div>
            </div>
        </div>
        @endif

        <!-- Footer Notice -->
        <div class="footer" style="text-align: center;">
            <p>Hóa đơn điện tử được khởi tạo từ hệ thống OmniCommerce ERP.</p>
            <p>Cảm ơn quý khách đã tin tưởng và mua sắm tại cửa hàng của chúng tôi!</p>
        </div>

    </div>
    <script>
        window.onload = function() { window.print(); }
    </script>
</body>
</html>
