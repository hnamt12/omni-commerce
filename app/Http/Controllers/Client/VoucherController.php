<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Models\Voucher;
use Illuminate\Http\Request;

class VoucherController extends Controller
{
    // ─────────────────────────────────────────────
    //  Apply voucher to session
    // ─────────────────────────────────────────────
    public function applyVoucher(Request $request)
    {
        $code = trim($request->code ?? '');
        $voucher = Voucher::where('code', '=', $code)->where('is_active', true)->first();

        if (! $voucher) {
            return back()->with('error', 'Mã giảm giá không hợp lệ!');
        }

        $now = now();
        if ($voucher->start_date && $voucher->start_date->gt($now)) {
            return back()->with('error', 'Mã giảm giá chưa đến thời gian sử dụng!');
        }
        if ($voucher->end_date && $voucher->end_date->lt($now)) {
            return back()->with('error', 'Mã giảm giá đã hết hạn sử dụng!');
        }

        $type = $voucher->discount_percentage > 0 ? 'percent' : 'fixed';
        $value = $type === 'percent' ? $voucher->discount_percentage : $voucher->discount_amount_fixed;

        $applied = session('applied_vouchers', []);
        $applied[$voucher->scope] = [
            'id' => $voucher->id,
            'code' => $voucher->code,
            'type' => $type,
            'value' => (float) $value,
            'scope' => $voucher->scope,
            'max' => (float) ($voucher->max_discount_amount ?? 0),
        ];
        session(['applied_vouchers' => $applied]);

        return back()->with('success', 'Đã áp dụng mã giảm giá!');
    }

    // ─────────────────────────────────────────────
    //  Remove voucher from session
    // ─────────────────────────────────────────────
    public function removeVoucher(Request $request)
    {
        $scope = $request->scope;
        $applied = session('applied_vouchers', []);
        if (isset($applied[$scope])) {
            unset($applied[$scope]);
            session(['applied_vouchers' => $applied]);
        }

        return back()->with('success', 'Đã gỡ mã giảm giá!');
    }
}
