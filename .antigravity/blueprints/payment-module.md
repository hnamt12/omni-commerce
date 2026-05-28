# 💳 PAYMENT METHOD CONFIGURATION ARCHITECTURE

## 1. DATABASE SCHEMA (STRICT)
- **Table:** `payment_methods`
  - `id` (bigint, primary)
  - `name` (string) - e.g., "Chuyển khoản ngân hàng", "Thanh toán khi nhận hàng (COD)"
  - `code` (string, unique) - e.g., "bank_transfer", "cod"
  - `description` (text, nullable)
  - `is_active` (boolean, default: true)
  - `config` (json, nullable) - Stores details like bank name, account number, account name.

## 2. DATA FLOW
- **Backend Model (`PaymentMethod.php`):** MUST include `config` in `$casts` as `array`.
- **Controller (`PaymentMethodController.php`):** Handles listing (`index`) and updating configurations or toggling active status (`update`).
- **Frontend UI (`PaymentMethod/Index.vue`):** Displays available payment gateways as cards. Clicking "Cấu hình" opens a dynamic Modal based on the `code` to input API credentials or bank account detail numbers.