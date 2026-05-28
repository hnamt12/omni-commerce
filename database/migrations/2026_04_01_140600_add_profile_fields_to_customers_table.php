<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            if (! Schema::hasColumn('customers', 'gender')) {
                $table->enum('gender', ['male', 'female', 'other'])->nullable()->after('phone');
            }
            if (! Schema::hasColumn('customers', 'avatar')) {
                $table->string('avatar')->nullable()->after('gender');
            }
        });
    }

    public function down(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            $columns = [];
            if (Schema::hasColumn('customers', 'gender')) {
                $columns[] = 'gender';
            }
            if (Schema::hasColumn('customers', 'avatar')) {
                $columns[] = 'avatar';
            }
            if (! empty($columns)) {
                $table->dropColumn($columns);
            }
        });
    }
};
