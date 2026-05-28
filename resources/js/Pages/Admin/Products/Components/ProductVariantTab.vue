<script setup>
import { ref, computed } from 'vue';
import { vnSlugify, formatMoney, parseMoney, handleMoneyInput, handleMoneyBlur } from '@/Utils/helpers';

const props = defineProps({
    form: Object,
    activeAttributes: Array,
});

// Cartesian Product - Non-destructive
const generateVariants = () => {
    if (!props.activeAttributes || props.activeAttributes.length === 0) return;
    
    // Check if any active attribute has empty values selection
    const invalidAttr = props.form.attributes.find(a => a.attribute_id && (!a.values || a.values.length === 0));
    if (invalidAttr) {
        alert('Vui lòng chọn ít nhất một giá trị cho mỗi thuộc tính trước khi tạo ma trận!');
        return;
    }

    const attributeGroups = props.activeAttributes.map(attr => {
        const formAttr = props.form.attributes.find(a => a.attribute_id == attr.id);
        const selectedValues = formAttr && formAttr.values ? formAttr.values : [];
        
        return attr.values
            .filter(v => selectedValues.includes(v.value))
            .map(v => ({ attrId: attr.id, valId: v.id, valTitle: v.value }));
    }).filter(group => group.length > 0);
    
    const cartesian = (arrays) => {
        return arrays.reduce((a, b) => 
            a.flatMap(d => b.map(e => [d, e].flat()))
        , [[]]);
    };
    
    const combos = cartesian(attributeGroups);
    
    const oldVariantsMap = new Map();
    (props.form.variants || []).forEach(v => {
        const key = Object.entries(v.attributes || {}).sort().map(([k, val]) => `${k}:${val}`).join('|');
        if (key) oldVariantsMap.set(key, v);
    });

    props.form.variants = combos.map(combo => {
        const attrMap = {};
        combo.forEach(c => { attrMap[c.attrId] = c.valId; });
        
        const comboKey = Object.entries(attrMap).sort().map(([k, val]) => `${k}:${val}`).join('|');
        const existing = oldVariantsMap.get(comboKey);
        if (existing) return existing;
        
        const newVariant = {
            _id: Date.now() + Math.random().toString(36).substr(2, 9),
            attributes: attrMap,
            price: '',
            original_price: '',
            stock: 10,
            sku: '',
            sale_price: '',
            cost_price: '',
        };
        generateSeniorSKU(newVariant);
        return newVariant;
    });
};

// SEO-Friendly Smart SKU Generator
const generateSeniorSKU = (variant) => {
    let baseSku = vnSlugify(props.form.name) || props.form.sku || 'SKU';
    let parts = [];
    (props.activeAttributes || []).forEach(attr => {
        const valId = variant.attributes[attr.id];
        if (valId) {
            const obj = attr.values.find(v => v.id == valId || v.value == valId);
            parts.push(vnSlugify(obj ? obj.value : valId).toUpperCase());
        }
    });
    variant.sku = baseSku.toUpperCase() + (parts.length ? '-' + parts.join('-') : '');
};

const removeVariantRow = (index) => { props.form.variants.splice(index, 1); };

// Bulk Actions — unified reactive object + single apply
const bulk = ref({ price: '', sale_price: '', cost_price: '', stock: '' });

const applyAllBulk = () => {
    if (!props.form.variants || props.form.variants.length === 0) {
        alert('Chưa có biến thể nào để áp dụng!');
        return;
    }
    const p = parseMoney(bulk.value.price);
    const sp = parseMoney(bulk.value.sale_price);
    const cp = parseMoney(bulk.value.cost_price);
    const st = parseInt(bulk.value.stock);
    let applied = 0;
    props.form.variants.forEach(v => {
        if (p)          { v.price = p; applied++; }
        if (sp)         { v.sale_price = sp; applied++; }
        if (cp)         { v.cost_price = cp; applied++; }
        if (!isNaN(st)) { v.stock = st; applied++; }
    });
    if (applied === 0) {
        alert('Vui lòng nhập ít nhất một giá trị để áp dụng!');
    }
};

const hasValidAttributes = computed(() => {
    return props.form.attributes && props.form.attributes.length > 0 && props.form.attributes.some(a => a.attribute_id && a.values && a.values.length > 0);
});
</script>

<template>
    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6 mb-5">
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 mb-5">
            <div>
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg">Ma trận Biến thể (Cartesian)</h2>
                <p class="text-sm text-gray-500 mt-0.5">Tự động kết hợp các thuộc tính, giữ nguyên dữ liệu cũ khi cập nhật.</p>
            </div>
            <button @click.prevent="generateVariants" class="px-5 py-2.5 bg-indigo-600 text-white font-bold rounded-xl text-sm hover:bg-indigo-700 transition shadow-lg hover:shadow-indigo-200 dark:hover:shadow-none flex items-center gap-2 shrink-0">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
                Tạo / Cập nhật Ma trận
            </button>
        </div>

        <!-- Bulk Actions -->
        <div class="bg-gradient-to-r from-gray-50 to-slate-50 dark:from-slate-700/40 dark:to-slate-700/20 rounded-xl p-5 mb-5 border border-gray-200 dark:border-slate-600">
            <div class="flex items-center gap-2 mb-4">
                <span class="text-base">⚡</span>
                <p class="text-sm font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300">Thiết lập hàng loạt</p>
                <span class="text-[10px] text-gray-400 dark:text-gray-500 ml-1">Chỉ áp dụng các ô đã điền giá trị</span>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
                <!-- Giá niêm yết -->
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1">💰 Giá niêm yết</label>
                    <div class="relative">
                        <input type="text" :value="formatMoney(bulk.price)" @input="e => handleMoneyInput(e, bulk, 'price')" @blur="e => handleMoneyBlur(e, bulk, 'price')" class="w-full py-2.5 pl-3 pr-10 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-lg text-sm focus:ring-2 focus:ring-indigo-500 transition" placeholder="500.000">
                        <span class="absolute right-2.5 top-1/2 -translate-y-1/2 text-[9px] font-bold text-gray-400">₫</span>
                    </div>
                </div>
                <!-- Giá KM -->
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 mb-1">🎁 Giá KM</label>
                    <div class="relative">
                        <input type="text" :value="formatMoney(bulk.sale_price)" @input="e => handleMoneyInput(e, bulk, 'sale_price')" @blur="e => handleMoneyBlur(e, bulk, 'sale_price')" class="w-full py-2.5 pl-3 pr-10 border border-emerald-200 dark:border-emerald-800 bg-emerald-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-lg text-sm focus:ring-2 focus:ring-emerald-500 transition" placeholder="450.000">
                        <span class="absolute right-2.5 top-1/2 -translate-y-1/2 text-[9px] font-bold text-gray-400">₫</span>
                    </div>
                </div>
                <!-- Giá vốn -->
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400 mb-1">📊 Giá vốn</label>
                    <div class="relative">
                        <input type="text" :value="formatMoney(bulk.cost_price)" @input="e => handleMoneyInput(e, bulk, 'cost_price')" @blur="e => handleMoneyBlur(e, bulk, 'cost_price')" class="w-full py-2.5 pl-3 pr-10 border border-amber-200 dark:border-amber-800 bg-amber-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-lg text-sm focus:ring-2 focus:ring-amber-500 transition" placeholder="300.000">
                        <span class="absolute right-2.5 top-1/2 -translate-y-1/2 text-[9px] font-bold text-gray-400">₫</span>
                    </div>
                </div>
                <!-- Tồn kho -->
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1">📦 Tồn kho</label>
                    <input type="number" v-model="bulk.stock" class="w-full py-2.5 px-3 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-lg text-sm focus:ring-2 focus:ring-indigo-500 transition" placeholder="100">
                </div>
            </div>
            <button type="button" @click.prevent="applyAllBulk" class="w-full py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-sm transition shadow-md hover:shadow-lg flex items-center justify-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                Xác nhận thiết lập hàng loạt
            </button>
        </div>

        <!-- Variant Table -->
        <div class="overflow-x-auto border border-gray-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800">
            <table class="w-full text-left text-sm whitespace-nowrap">
                <thead class="bg-gray-50 dark:bg-slate-700/50 text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 border-b border-gray-200 dark:border-slate-600">
                    <tr>
                        <th v-for="attr in activeAttributes" :key="'th-' + attr.id" class="px-4 py-3">{{ attr.name }}</th>
                        <th class="px-4 py-3">Giá niêm yết (₫)</th>
                        <th class="px-4 py-3">Giá KM (₫)</th>
                        <th class="px-4 py-3">Giá vốn (₫)</th>
                        <th class="px-4 py-3 text-center">Tồn kho</th>
                        <th class="px-4 py-3">Mã SKU</th>
                        <th class="px-3 py-3 text-center">Auto</th>
                        <th class="px-2 py-3 text-center">Xóa</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-slate-700">
                    <tr v-for="(variant, index) in form.variants" :key="variant._id" class="hover:bg-gray-50/50 dark:hover:bg-slate-700/30 transition">
                        <td v-for="attr in activeAttributes" :key="'td-' + attr.id" class="px-4 py-3">
                            <span class="font-semibold text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-900/30 px-2.5 py-1 rounded-lg text-xs border border-indigo-100 dark:border-indigo-800">
                                {{ attr.values.find(v => v.id == variant.attributes[attr.id])?.value || variant.attributes[attr.id] || '—' }}
                            </span>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <input type="text" :value="formatMoney(variant.price)" @input="e => handleMoneyInput(e, variant, 'price')" @blur="e => handleMoneyBlur(e, variant, 'price')" class="w-32 py-2.5 pl-4 pr-12 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" required placeholder="0">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <input type="text" :value="formatMoney(variant.sale_price)" @input="e => handleMoneyInput(e, variant, 'sale_price')" @blur="e => handleMoneyBlur(e, variant, 'sale_price')" class="w-28 py-2.5 pl-4 pr-12 border border-emerald-200 dark:border-emerald-800 bg-emerald-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition" placeholder="KM">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <input type="text" :value="formatMoney(variant.cost_price)" @input="e => handleMoneyInput(e, variant, 'cost_price')" @blur="e => handleMoneyBlur(e, variant, 'cost_price')" class="w-28 py-2.5 pl-4 pr-12 border border-amber-200 dark:border-amber-800 bg-amber-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition" placeholder="Vốn">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">📦</span>
                                <input type="number" v-model="variant.stock" class="w-24 py-2.5 pl-9 pr-3 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm text-center focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" required>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <input type="text" v-model="variant.sku" class="w-44 py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-xs font-mono focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 focus:bg-white transition">
                        </td>
                        <td class="px-3 py-3 text-center">
                            <button type="button" @click.prevent="generateSeniorSKU(variant)" class="p-2 text-indigo-500 bg-indigo-50 dark:bg-indigo-900/30 hover:bg-indigo-600 hover:text-white rounded-lg transition" title="Auto SKU">
                                <svg class="w-4 h-4 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" /></svg>
                            </button>
                        </td>
                        <td class="px-3 py-3 text-center">
                            <button type="button" @click.prevent="removeVariantRow(index)" class="p-2 text-red-400 hover:bg-red-50 dark:hover:bg-red-900/30 hover:text-red-600 rounded-lg transition">
                                <svg class="w-4 h-4 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                            </button>
                        </td>
                    </tr>
                    <tr v-if="form.variants.length === 0">
                        <td :colspan="activeAttributes.length + 7" class="py-14 text-center text-gray-400 dark:text-gray-500 italic bg-gray-50/50 dark:bg-slate-700/20">
                            <template v-if="!hasValidAttributes">
                                Chưa có thuộc tính nào được cấu hình. Vui lòng qua tab <span class="font-bold text-indigo-500">"🏷️ Thuộc tính"</span> để chọn giá trị.
                            </template>
                            <template v-else>
                                Chưa có biến thể. Bấm <span class="font-bold text-indigo-500">"Tạo / Cập nhật Ma trận"</span> để sinh biến thể từ các giá trị đã chọn.
                            </template>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
