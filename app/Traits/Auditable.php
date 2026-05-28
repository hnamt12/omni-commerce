<?php

namespace App\Traits;

use App\Models\ActionLog;

trait Auditable
{
    /**
     * Boot the Auditable trait — hook vào 3 Eloquent events.
     */
    public static function bootAuditable(): void
    {
        static::created(function ($model) {
            static::logAction(
                $model,
                'created',
                null,
                static::sanitize($model->getAttributes())
            );
        });

        static::updated(function ($model) {
            // Chỉ lấy những keys thực sự thay đổi (bỏ qua trường giữ nguyên)
            $changedKeys = array_keys($model->getChanges());
            if (empty($changedKeys)) {
                return;
            }

            $oldValues = [];
            $newValues = [];
            foreach ($changedKeys as $key) {
                $oldValues[$key] = $model->getOriginal($key);
                $newValues[$key] = $model->getChanges()[$key];
            }

            static::logAction(
                $model,
                'updated',
                static::sanitize($oldValues),
                static::sanitize($newValues)
            );
        });

        static::deleted(function ($model) {
            static::logAction(
                $model,
                'deleted',
                static::sanitize($model->getAttributes()),
                null
            );
        });
    }

    /**
     * Ghi một bản ghi ActionLog vào cơ sở dữ liệu.
     */
    private static function logAction($model, string $action, ?array $oldValues = null, ?array $newValues = null): void
    {
        try {
            $actor = auth()->user();
            $userId = ($actor instanceof \App\Models\User) ? $actor->id : null;
            $customerId = ($actor instanceof \App\Models\Customer) ? $actor->id : null;

            // If the model itself is a Customer, log that customer_id
            if ($model instanceof \App\Models\Customer) {
                $customerId = $model->id;
            } elseif (isset($model->customer_id)) {
                // If model has a customer_id (like Order), log it
                $customerId = $model->customer_id;
            }

            ActionLog::create([
                'user_id'      => $userId,
                'customer_id'  => $customerId,
                'action'       => $action,
                'loggable_type' => get_class($model),
                'loggable_id'  => $model->getKey(),
                'old_values'   => $oldValues,
                'new_values'   => $newValues,
                'ip_address'   => request()->ip(),
                'user_agent'   => request()->userAgent(),
            ]);
        } catch (\Throwable $e) {
            // Silent fail – không làm hỏng request gốc nếu log thất bại
            logger()->error('[Auditable] Failed to write action log: ' . $e->getMessage());
        }
    }

    /**
     * Che giấu dữ liệu nhạy cảm trước khi lưu vào JSON.
     */
    private static function sanitize(array $data): array
    {
        $sensitiveKeys = ['password', 'remember_token', 'api_token', 'secret', 'token'];

        foreach ($sensitiveKeys as $key) {
            if (array_key_exists($key, $data)) {
                unset($data[$key]);
            }
        }

        return $data;
    }
}
