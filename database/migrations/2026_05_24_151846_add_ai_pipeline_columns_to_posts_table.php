<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            // 1. Drop legacy boolean — replaced by strict workflow status string
            if (Schema::hasColumn('posts', 'is_active')) {
                $table->dropColumn('is_active');
            }

            // 2. Strict content moderation workflow status
            //    Allowed values: draft | ai_generated | published
            if (! Schema::hasColumn('posts', 'status')) {
                $table->string('status')->default('draft')->after('content');
            }

            // 3. Track which AI agent or system generated this post
            //    e.g. 'gpt-4o', 'deepseek-v3', 'gemini-2.5-pro', null = human
            if (! Schema::hasColumn('posts', 'ai_model_source')) {
                $table->string('ai_model_source')->nullable()->after('status');
            }

            // 4. Scheduled publishing — prevents Google spam detection
            //    by spreading publication time. null = publish immediately.
            if (! Schema::hasColumn('posts', 'published_at')) {
                $table->timestamp('published_at')->nullable()->after('updated_at');
            }
        });
    }

    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            // Restore is_active
            if (! Schema::hasColumn('posts', 'is_active')) {
                $table->boolean('is_active')->default(true)->after('content');
            }

            foreach (['status', 'ai_model_source', 'published_at'] as $col) {
                if (Schema::hasColumn('posts', $col)) {
                    $table->dropColumn($col);
                }
            }
        });
    }
};
