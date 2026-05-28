<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        // 1. Bổ sung các cột vận hành thiếu vào bảng orders
        Schema::table('orders', function (Blueprint $table) {
            if (!Schema::hasColumn('orders', 'staff_id')) { $table->unsignedBigInteger('staff_id')->nullable(); }
            if (!Schema::hasColumn('orders', 'payment_date')) { $table->timestamp('payment_date')->nullable(); }
            if (!Schema::hasColumn('orders', 'canceled_by')) { $table->string('canceled_by')->nullable(); }
            if (!Schema::hasColumn('orders', 'email')) { $table->string('email')->nullable(); }
            if (!Schema::hasColumn('orders', 'tax_amount')) { $table->decimal('tax_amount', 15, 2)->default(0); }
            if (!Schema::hasColumn('orders', 'shipping_discount_amount')) { $table->decimal('shipping_discount_amount', 15, 2)->default(0); }
            if (!Schema::hasColumn('orders', 'shipping_province_id')) { $table->integer('shipping_province_id')->nullable(); }
            if (!Schema::hasColumn('orders', 'shipping_district_id')) { $table->integer('shipping_district_id')->nullable(); }
            if (!Schema::hasColumn('orders', 'shipping_ward_id')) { $table->integer('shipping_ward_id')->nullable(); }
            if (!Schema::hasColumn('orders', 'shipping_method')) { $table->string('shipping_method')->nullable(); }
            if (!Schema::hasColumn('orders', 'tracking_number')) { $table->string('tracking_number')->nullable(); }
            if (!Schema::hasColumn('orders', 'shipping_voucher_id')) { $table->unsignedBigInteger('shipping_voucher_id')->nullable(); }
            if (!Schema::hasColumn('orders', 'voucher_code')) { $table->string('voucher_code')->nullable(); }
            if (!Schema::hasColumn('orders', 'shipping_voucher_code')) { $table->string('shipping_voucher_code')->nullable(); }
        });

        // 2. Tạo bảng voucher_usages để xử lý logic hoàn voucher
        if (!Schema::hasTable('voucher_usages')) {
            Schema::create('voucher_usages', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('customer_id')->nullable();
                $table->unsignedBigInteger('voucher_id');
                $table->unsignedBigInteger('order_id');
                $table->timestamp('used_at')->useCurrent();
                $table->timestamps();
            });
        }
    }

    public function down() {
        // Không bắt buộc viết rollback ở đây
    }
};
