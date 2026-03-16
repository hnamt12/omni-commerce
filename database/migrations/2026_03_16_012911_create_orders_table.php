<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_code')->unique();
            $table->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('voucher_id')->nullable()->constrained()->nullOnDelete();
            $table->string('name');
            $table->string('phone');
            $table->string('address');
            $table->decimal('subtotal', 15, 2);
            $table->decimal('shipping_fee', 15, 2)->default(0);
            $table->decimal('discount_amount', 15, 2)->default(0);
            $table->decimal('grand_total', 15, 2);
            $table->string('payment_method');
            $table->enum('payment_status', ['unpaid', 'paid', 'refunded', 'failed'])->default('unpaid');
            $table->enum('status', ['pending', 'confirmed', 'shipping', 'completed', 'canceled'])->default('pending');
            $table->text('cancel_reason')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
