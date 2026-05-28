<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\PayrollRecord;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class PayrollController extends Controller
{
    /**
     * Display a listing of the payroll records.
     */
    public function index(Request $request)
    {
        $month = $request->input('month', Carbon::now()->month);
        $year = $request->input('year', Carbon::now()->year);
        $search = $request->input('search');

        $query = PayrollRecord::with(['user', 'creator'])
            ->where('period_month', $month)
            ->where('period_year', $year);

        if ($search) {
            $query->whereHas('user', function ($q) use ($search) {
                $q->where('name', 'LIKE', "%{$search}%")
                    ->orWhere('email', 'LIKE', "%{$search}%");
            });
        }

        $records = $query->paginate(15)->withQueryString();

        // Thống kê tổng quan trong tháng
        $stats = [
            'total_base_salary' => $query->sum('base_salary'),
            'total_commission' => $query->sum('commission_amount'),
            'total_bonus' => $query->sum('bonus_amount'),
            'total_deductions' => $query->sum('deductions'),
            'total_net_salary' => $query->sum('net_salary'),
            'paid_count' => $query->whereNotNull('paid_at')->count(),
            'total_count' => $query->count(),
        ];

        return Inertia::render('Admin/Payroll/Index', [
            'records' => $records,
            'stats' => $stats,
            'filters' => [
                'month' => (int) $month,
                'year' => (int) $year,
                'search' => $search,
            ],
        ]);
    }

    /**
     * Show form to calculate and preview new payrolls.
     */
    public function create(Request $request)
    {
        $month = $request->input('month', Carbon::now()->month);
        $year = $request->input('year', Carbon::now()->year);

        // Lấy danh sách toàn bộ nhân viên hoạt động để tính toán lương nháp
        $users = User::where('is_active', true)->get();
        $previews = [];

        foreach ($users as $user) {
            // Doanh số chốt đơn hoàn thành trong tháng
            $totalSales = Order::where('staff_id', $user->id)
                ->where('status', 'completed')
                ->whereMonth('created_at', $month)
                ->whereYear('created_at', $year)
                ->sum('total');

            // Tính hoa hồng
            $commission = $totalSales * ($user->commission_rate / 100);

            // Thưởng hiệu suất (KPI): Doanh thu > 50,000,000 VND -> Thưởng 2,000,000 VND
            $bonus = 0;
            if ($totalSales >= 50000000) {
                $bonus = 2000000;
            }

            // Kiểm tra xem đã có bảng lương chính thức chưa
            $exists = PayrollRecord::where('user_id', $user->id)
                ->where('period_month', $month)
                ->where('period_year', $year)
                ->first();

            $previews[] = [
                'user_id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'department' => $user->department ?? 'Chưa phân bổ',
                'position' => $user->position ?? 'Nhân viên',
                'base_salary' => (float) $user->base_salary,
                'commission_rate' => (float) $user->commission_rate,
                'total_sales' => (float) $totalSales,
                'commission_amount' => (float) $commission,
                'bonus_amount' => (float) $bonus,
                'deductions' => 0.0,
                'net_salary' => (float) ($user->base_salary + $commission + $bonus),
                'is_saved' => $exists ? true : false,
                'record_id' => $exists ? $exists->id : null,
            ];
        }

        return Inertia::render('Admin/Payroll/Create', [
            'previews' => $previews,
            'filters' => [
                'month' => (int) $month,
                'year' => (int) $year,
            ],
        ]);
    }

    /**
     * Store multiple payroll records (Save all previewed draft payrolls).
     */
    public function store(Request $request)
    {
        $request->validate([
            'month' => 'required|integer|min:1|max:12',
            'year' => 'required|integer',
            'records' => 'required|array',
            'records.*.user_id' => 'required|exists:users,id',
            'records.*.base_salary' => 'required|numeric|min:0',
            'records.*.commission_amount' => 'required|numeric|min:0',
            'records.*.bonus_amount' => 'required|numeric|min:0',
            'records.*.deductions' => 'required|numeric|min:0',
            'records.*.note' => 'nullable|string',
        ]);

        $month = $request->input('month');
        $year = $request->input('year');
        $recordsData = $request->input('records');
        $adminId = $request->user()->id;

        DB::beginTransaction();
        try {
            foreach ($recordsData as $data) {
                $netSalary = $data['base_salary'] + $data['commission_amount'] + $data['bonus_amount'] - $data['deductions'];

                // Tránh trùng lặp bảng lương bằng cách updateOrCreate
                PayrollRecord::updateOrCreate(
                    [
                        'user_id' => $data['user_id'],
                        'period_month' => $month,
                        'period_year' => $year,
                    ],
                    [
                        'base_salary' => $data['base_salary'],
                        'commission_amount' => $data['commission_amount'],
                        'bonus_amount' => $data['bonus_amount'],
                        'deductions' => $data['deductions'],
                        'net_salary' => $netSalary,
                        'note' => $data['note'] ?? null,
                        'created_by' => $adminId,
                    ]
                );
            }
            DB::commit();

            return redirect()->route('admin.payroll.index', ['month' => $month, 'year' => $year])
                ->with('success', 'Bảng tính lương tháng '.$month.'/'.$year.' đã được lưu thành công.');
        } catch (\Throwable $e) {
            DB::rollBack();

            return back()->withErrors(['error' => 'Lỗi lưu bảng lương: '.$e->getMessage()]);
        }
    }

    /**
     * Display the specified payroll record.
     */
    public function show($id)
    {
        $record = PayrollRecord::with(['user', 'creator'])->findOrFail($id);

        // Lấy danh sách các đơn hàng chốt được của nhân sự này trong tháng đó để đối soát hoa hồng
        $orders = Order::where('staff_id', $record->user_id)
            ->where('status', 'completed')
            ->whereMonth('created_at', $record->period_month)
            ->whereYear('created_at', $record->period_year)
            ->select('id', 'order_number', 'total', 'created_at')
            ->get();

        return Inertia::render('Admin/Payroll/Show', [
            'record' => $record,
            'orders' => $orders,
        ]);
    }

    /**
     * Mark the payroll record as paid.
     */
    public function pay($id)
    {
        try {
            $record = PayrollRecord::findOrFail($id);
            $record->update([
                'paid_at' => Carbon::now(),
            ]);

            return back()->with('success', 'Đã xác nhận thanh toán lương cho '.$record->user->name);
        } catch (\Throwable $e) {
            return back()->withErrors(['error' => 'Lỗi cập nhật thanh toán: '.$e->getMessage()]);
        }
    }

    /**
     * Export payslip as HTML / PDF (Printable format).
     */
    public function exportPdf($id)
    {
        $record = PayrollRecord::with(['user', 'creator'])->findOrFail($id);

        // Trả về view HTML đơn giản tối ưu cho in ấn (print)
        return view('admin.payroll.payslip', compact('record'));
    }
}
