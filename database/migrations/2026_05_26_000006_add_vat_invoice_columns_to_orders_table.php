<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->string('vat_invoice_number')->nullable();
            $table->string('vat_invoice_serial')->nullable();
            $table->string('vat_invoice_template')->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['vat_invoice_number', 'vat_invoice_serial', 'vat_invoice_template']);
        });
    }
};
