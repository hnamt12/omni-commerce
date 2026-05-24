# PRODUCT MODULE ARCHITECTURE & DATA FLOW

## 1. SYSTEM OVERVIEW
This module manages complex E-commerce products with dynamic attributes and matrix-generated variants (Shopee/TikTok Shop style).

## 2. FRONTEND FLOW (Vue 3 + Inertia.js)
- **Master Orchestrator:** `resources/js/Pages/Admin/Products/Form.vue`
  - It holds the absolute source of truth using Inertia `useForm`.
  - Child components MUST NOT mutate state globally; they only modify `props.form`.
- **Tab 1: Basic Information (`ProductBasicTab.vue`)**
  - Inputs: `name`, `description` (Rich Text), `is_active` (Boolean), `is_featured` (Boolean).
  - Images: Separated into `thumbnail` (Single Main Image File) and `images[]` (Array of Gallery Files).
- **Tab 2: Attributes Phân Loại (`ProductAttributeTab.vue`)**
  - **Crucial Rule:** Saves dynamic Tag-Inputs as **String Values** (e.g., `["Đỏ", "Xanh"]`), NOT numeric IDs.
  - Suggestion Row: Loads available values from `props.attributes` object. Clicking a suggestion appends the string to `form.attributes[x].values`.
- **Tab 3: Variants Table (`ProductVariantTab.vue`)**
  - Triggers Cartesian product calculation automatically whenever `form.attributes` changes.
  - Generates combinatorics list. Each row contains: `sku` (SEO-friendly format: `PRODUCTNAME-ATTR1-ATTR2`), `price`, `sale_price`, `cost_price`, `stock`.
  - Supports Bulk Actions (Triple input for Price, Sale Price, and Cost Price). Must clean commas/formatting before binding to form values.

## 3. BACKEND FLOW (Laravel 11)
- **Controller:** `app/Http/Controllers/Admin/ProductController.php`
- **Database Rules (STRICT):**
  - All writes inside `store()` and `update()` MUST be wrapped in `DB::transaction()`.
  - **Save Order:**
    1. Create/Update Base `Product` model (Handle booleans `is_active`, `is_featured`).
    2. Upload & Save `thumbnail` directly onto the `products` table.
    3. Loop & save upload `images` into the `product_images` table.
    4. Loop `$request->variants` -> Use `updateOrCreate()` based on SKU or ID.
    5. Resolve text attribute values via `AttributeValue::firstOrCreate()` to fetch proper IDs, then sync into the pivot table `product_variant_attributes` mapped to the corresponding `variant_id`.
- **Allowed Variant Columns:** `sku`, `price`, `sale_price`, `cost_price`, `stock`. 
  - *CRITICAL WARNING:* DO NOT use `original_price` or `options`. They do not exist in the MySQL schema.