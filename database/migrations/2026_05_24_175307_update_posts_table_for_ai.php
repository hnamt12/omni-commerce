<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            // Drop old is_active column if it exists to clean up structure
            if (Schema::hasColumn('posts', 'is_active')) {
                $table->dropColumn('is_active');
            }

            // Add new AI automation-ready columns with safety checks
            if (! Schema::hasColumn('posts', 'status')) {
                $table->string('status')->default('published')->after('content'); // draft, ai_generated, published
            }
            if (! Schema::hasColumn('posts', 'ai_model_source')) {
                $table->string('ai_model_source')->nullable()->after('status');
            }
            if (! Schema::hasColumn('posts', 'published_at')) {
                $table->timestamp('published_at')->nullable()->after('updated_at');
            }
        });
    }

    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            if (! Schema::hasColumn('posts', 'is_active')) {
                $table->boolean('is_active')->default(true);
            }
            foreach (['status', 'ai_model_source', 'published_at'] as $col) {
                if (Schema::hasColumn('posts', $col)) {
                    $table->dropColumn($col);
                }
            }
        });
    }
};
