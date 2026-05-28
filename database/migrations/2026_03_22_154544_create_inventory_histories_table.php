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
        Schema::create('inventory_histories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_variant_id')->constrained('product_variants')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('users'); // Người thao tác
            $table->enum('action_type', ['import', 'export', 'adjustment', 'system']); // Nhập, Xuất, Cân bằng, Hệ thống
            $table->integer('quantity_change'); // Số lượng thay đổi (có thể âm hoặc dương)
            $table->integer('stock_before');
            $table->integer('stock_after');
            $table->string('note')->nullable(); // Lý do
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('inventory_histories');
    }
};
