<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phiếu Lương Điện Tử - {{ $record->user->name }}</title>
    <style>
        body { font-family: 'DejaVu Sans', sans-serif; font-size: 14px; color: #333; margin: 30px; }
        .header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #4f46e5; padding-bottom: 15px; }
        .header h1 { margin: 0; color: #4f46e5; font-size: 24px; text-transform: uppercase; }
        .header p { margin: 5px 0 0 0; color: #666; font-size: 14px; }
        .info-section { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .info-section td { padding: 8px 12px; vertical-align: top; }
        .info-section td.label { font-weight: bold; width: 25%; color: #555; }
        .salary-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .salary-table th { background-color: #f3f4f6; border: 1px solid #e5e7eb; padding: 12px; text-align: left; font-weight: bold; }
        .salary-table td { border: 1px solid #e5e7eb; padding: 12px; }
        .salary-table .right { text-align: right; }
        .total-row { font-weight: bold; background-color: #e0e7ff; color: #3730a3; }
        .footer { margin-top: 50px; text-align: right; }
        .signatures { width: 100%; margin-top: 40px; }
        .signatures td { text-align: center; width: 50%; }
        @media print {
            .no-print { display: none; }
            body { margin: 0; }
        }
        .btn-print {
            background-color: #4f46e5; color: white; border: none; padding: 10px 20px;
            font-size: 14px; font-weight: bold; border-radius: 6px; cursor: pointer;
            text-decoration: none; margin-bottom: 20px; display: inline-block;
        }
    </style>
</head>
<body>

    <div class="no-print" style="text-align: right;">
        <button onclick="window.print()" class="btn-print">🖨️ In Phiếu Lương / Xuất PDF</button>
    </div>

    <div class="header">
        <h1>Phiếu Lương Nhân Viên</h1>
        <p>Tháng {{ $record->period_month }} Năm {{ $record->period_year }}</p>
    </div>

    <table class="info-section">
        <tr>
            <td class="label">Nhân sự:</td>
            <td>{{ $record->user->name }}</td>
            <td class="label">Phòng ban:</td>
            <td>{{ $record->user->department ?? 'Chưa phân bổ' }}</td>
        </tr>
        <tr>
            <td class="label">Email:</td>
            <td>{{ $record->user->email }}</td>
            <td class="label">Chức vụ:</td>
            <td>{{ $record->user->position ?? 'Nhân viên' }}</td>
        </tr>
        <tr>
            <td class="label">Ngày vào làm:</td>
            <td>{{ $record->user->hire_date ? \Carbon\Carbon::parse($record->user->hire_date)->format('d/m/Y') : 'Chưa có' }}</td>
            <td class="label">Trạng thái:</td>
            <td><strong>{{ $record->paid_at ? 'Đã Thanh Toán (' . $record->paid_at->format('d/m/Y H:i') . ')' : 'Chờ Thanh Toán' }}</strong></td>
        </tr>
    </table>

    <table class="salary-table">
        <thead>
            <tr>
                <th>Khoản mục</th>
                <th class="right">Số tiền (VND)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Lương cơ bản (Lương cứng)</td>
                <td class="right">{{ number_format($record->base_salary) }}đ</td>
            </tr>
            <tr>
                <td>Hoa hồng doanh thu chốt đơn ({{ number_format($record->user->commission_rate, 1) }}%)</td>
                <td class="right">+{{ number_format($record->commission_amount) }}đ</td>
            </tr>
            <tr>
                <td>Thưởng hiệu suất (KPI)</td>
                <td class="right">+{{ number_format($record->bonus_amount) }}đ</td>
            </tr>
            <tr>
                <td>Các khoản khấu trừ (Phạt/Bảo hiểm/Khác)</td>
                <td class="right" style="color: #dc2626;">-{{ number_format($record->deductions) }}đ</td>
            </tr>
            <tr class="total-row">
                <td>LƯƠNG THỰC LĨNH (NET)</td>
                <td class="right">{{ number_format($record->net_salary) }}đ</td>
            </tr>
        </tbody>
    </table>

    @if($record->note)
    <div style="margin-bottom: 30px; background-color: #f9fafb; border-left: 4px solid #9ca3af; padding: 12px;">
        <strong>Ghi chú:</strong> {{ $record->note }}
    </div>
    @endif

    <table class="signatures">
        <tr>
            <td>
                <p><strong>Người nhận lương</strong></p>
                <p style="font-size: 12px; color: #888; margin-top: 60px;">(Ký và ghi rõ họ tên)</p>
            </td>
            <td>
                <p><strong>Người duyệt bảng lương</strong></p>
                <p><strong>{{ $record->creator->name }}</strong></p>
                <p style="font-size: 12px; color: #888; margin-top: 40px;">(Ký và đóng dấu)</p>
            </td>
        </tr>
    </table>

</body>
</html>
