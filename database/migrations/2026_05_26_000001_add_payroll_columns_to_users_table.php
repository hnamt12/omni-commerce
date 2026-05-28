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
        Schema::table('users', function (Blueprint $table) {
            $table->string('department', 100)->nullable()->after('is_active');
            $table->string('position', 100)->nullable()->after('department');
            $table->date('hire_date')->nullable()->after('position');
            $table->decimal('base_salary', 15, 2)->default(0)->after('hire_date');
            $table->decimal('commission_rate', 5, 2)->default(0)->after('base_salary');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['department', 'position', 'hire_date', 'base_salary', 'commission_rate']);
        });
    }
};
