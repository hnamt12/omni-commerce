<?php

namespace Database\Seeders;

use App\Models\Customer;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusHistory;
use App\Models\ProductVariant;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        // Lấy hoặc tạo mock Customer
        $customers = $this->ensureCustomers();

        // Lấy variants đang có hàng (hoặc tất cả nếu không có)
        $variants = ProductVariant::with('product')->limit(10)->get();
        if ($variants->isEmpty()) {
            $this->command->warn('Không có ProductVariant nào trong DB. Seeder sẽ tạo đơn không có items.');
        }

        // Lấy staff user đầu tiên để gán vào đơn
        $staffId = User::first()?->id;

        $scenarios = [
            ['status' => 'Chờ xác nhận',       'history' => ['Chờ xác nhận']],
            ['status' => 'Chờ xác nhận',       'history' => ['Chờ xác nhận']],
            ['status' => 'Đã xác nhận',         'history' => ['Chờ xác nhận', 'Đã xác nhận']],
            ['status' => 'Đang chuẩn bị hàng', 'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đang chuẩn bị hàng']],
            ['status' => 'Đang giao hàng',     'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đang chuẩn bị hàng', 'Đang giao hàng']],
            ['status' => 'Đã hoàn thành',      'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đang chuẩn bị hàng', 'Đang giao hàng', 'Đã hoàn thành']],
            ['status' => 'Đã hoàn thành',      'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đang giao hàng', 'Đã hoàn thành']],
            ['status' => 'Đã hoàn thành',      'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đã hoàn thành']],
            ['status' => 'Đã hủy',             'history' => ['Chờ xác nhận', 'Đã hủy']],
            ['status' => 'Trả hàng/Hoàn tiền', 'history' => ['Chờ xác nhận', 'Đã xác nhận', 'Đang giao hàng', 'Trả hàng/Hoàn tiền']],
        ];

        $addresses = [
            ['address' => '12 Nguyễn Huệ, Quận 1', 'province_id' => 79, 'district_id' => 760, 'ward_id' => 26734],
            ['address' => '45 Lê Lợi, Quận Hải Châu', 'province_id' => 48, 'district_id' => 490, 'ward_id' => 20194],
            ['address' => '88 Trần Phú, Hoàn Kiếm', 'province_id' => 1, 'district_id' => 18, 'ward_id' => 337],
        ];

        $paymentMethods = ['cod', 'banking', 'vnpay', 'momo'];

        foreach ($scenarios as $i => $scenario) {
            $customer = $customers[$i % count($customers)];
            $addr = $addresses[$i % count($addresses)];
            $pickedVars = $variants->random(min(max(1, rand(1, 3)), $variants->count()));
            if (! $pickedVars instanceof Collection) {
                $pickedVars = collect([$pickedVars]);
            }

            $items = $pickedVars->map(function ($v) {
                $qty = rand(1, 3);

                return [
                    'variant' => $v,
                    'qty' => $qty,
                    'unit_price' => (float) ($v->price ?? 99000),
                    'total_price' => (float) ($v->price ?? 99000) * $qty,
                ];
            });

            $subtotal = $items->sum('total_price');
            $shippingFee = [0, 25000, 30000, 35000][rand(0, 3)];
            $discountAmount = 0;
            $grandTotal = $subtotal + $shippingFee - $discountAmount;
            $isCompleted = in_array($scenario['status'], ['Đã hoàn thành']);
            $isCanceled = in_array($scenario['status'], ['Đã hủy', 'Trả hàng/Hoàn tiền']);

            // Chỉ dùng các cột chắc chắn tồn tại trong DB
            $baseData = [
                'order_code' => 'ORD-'.strtoupper(Str::random(7)),
                'customer_id' => $customer->id,
                'name' => $customer->name,
                'phone' => $customer->phone ?? '09'.rand(10000000, 99999999),
                'address' => $addr['address'],
                'subtotal' => $subtotal,
                'shipping_fee' => $shippingFee,
                'discount_amount' => $discountAmount,
                'grand_total' => $grandTotal,
                'payment_method' => $paymentMethods[rand(0, 3)],
                'payment_status' => $isCompleted ? 'paid' : 'unpaid',
                'status' => $scenario['status'],
                'cancel_reason' => $isCanceled ? 'Khách hàng yêu cầu hủy / trả hàng' : null,
                'created_at' => now()->subDays(rand(1, 60))->subHours(rand(0, 12)),
                'updated_at' => now()->subDays(rand(0, 5)),
            ];

            // Thêm cột tuỳ chọn nếu DB có
            $hasColumn = fn ($col) => Schema::hasColumn('orders', $col);
            if ($hasColumn('email')) {
                $baseData['email'] = $customer->email;
            }
            if ($hasColumn('staff_id')) {
                $baseData['staff_id'] = $staffId;
            }
            if ($hasColumn('shipping_province_id')) {
                $baseData['shipping_province_id'] = $addr['province_id'];
            }
            if ($hasColumn('shipping_district_id')) {
                $baseData['shipping_district_id'] = $addr['district_id'];
            }
            if ($hasColumn('shipping_ward_id')) {
                $baseData['shipping_ward_id'] = $addr['ward_id'];
            }
            if ($hasColumn('payment_date') && $isCompleted) {
                $baseData['payment_date'] = now()->subDays(rand(1, 30));
            }

            $order = Order::create($baseData);

            // Tạo order items
            foreach ($items as $item) {
                $v = $item['variant'];
                $variantOptions = [];
                if (is_array($v->options)) {
                    $variantOptions = $v->options;
                } elseif (is_string($v->options)) {
                    $variantOptions = json_decode($v->options, true) ?? [];
                }

                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $v->product_id,
                    'variant_id' => $v->id,
                    'name' => $v->product?->name ?? 'Sản phẩm mẫu '.$v->id,
                    'sku_code' => $v->sku,
                    'image_url' => $v->image ?? null,
                    'variant_options' => $variantOptions ?: null,
                    'quantity' => $item['qty'],
                    'price' => $item['unit_price'],
                    'total_price' => $item['total_price'],
                ]);
            }

            // Tạo lịch sử trạng thái
            $historyStatuses = $scenario['history'];
            $prevStatus = null;
            $baseTime = $order->created_at;

            foreach ($historyStatuses as $j => $histStatus) {
                OrderStatusHistory::create([
                    'order_id' => $order->id,
                    'old_status' => $prevStatus,
                    'new_status' => $histStatus,
                    'changed_by_user_id' => $staffId,
                    'note' => $j === 0
                        ? 'Đơn hàng được tạo'
                        : ($j === count($historyStatuses) - 1 && $isCanceled
                            ? 'Khách hàng yêu cầu hủy'
                            : 'Cập nhật trạng thái hệ thống'),
                    'created_at' => $baseTime->copy()->addHours($j * rand(2, 8)),
                    'updated_at' => $baseTime->copy()->addHours($j * rand(2, 8)),
                ]);
                $prevStatus = $histStatus;
            }
        }

        $this->command->info('✅ Đã tạo 10 đơn hàng mẫu đa dạng trạng thái thành công!');
    }

    private function ensureCustomers(): array
    {
        $data = [
            ['name' => 'Nguyễn Văn An',   'email' => 'an.nguyen@demo.vn',   'phone' => '0901234561'],
            ['name' => 'Trần Thị Bình',   'email' => 'binh.tran@demo.vn',   'phone' => '0912345678'],
            ['name' => 'Lê Minh Tuấn',   'email' => 'tuan.le@demo.vn',     'phone' => '0923456789'],
        ];

        return array_map(function ($d) {
            return Customer::firstOrCreate(
                ['email' => $d['email']],
                array_merge($d, ['password' => bcrypt('password'), 'is_active' => true])
            );
        }, $data);
    }
}
