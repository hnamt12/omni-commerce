<script setup>
import { ref } from 'vue';
import { vnSlugify } from '@/Utils/helpers';

const props = defineProps({
    form: Object,
    activeAttributes: Array,
});

const formatMoney = (val) => {
    if (!val && val !== 0) return '';
    return new Intl.NumberFormat('vi-VN').format(val);
};

const parseMoney = (str) => {
    if (!str) return '';
    return parseInt(String(str).replace(/\D/g, '')) || '';
};

// Cartesian Product - Non-destructive
const generateVariants = () => {
    if (!props.activeAttributes || props.activeAttributes.length === 0) return;
    
    // Check if any active attribute has empty selection
    const invalidAttr = props.form.attributes.find(a => a.attribute_id && (!a.selected_values || a.selected_values.length === 0));
    if (invalidAttr) {
        alert('Vui lòng chọn ít nhất một giá trị cho mỗi thuộc tính trước khi tạo ma trận!');
        return;
    }

    const attributeGroups = props.activeAttributes.map(attr => {
        const formAttr = props.form.attributes.find(a => a.attribute_id == attr.id);
        const selectedValues = formAttr && formAttr.selected_values ? formAttr.selected_values : (formAttr.values || []);
        
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
        
        return {
            _id: Date.now() + Math.random().toString(36).substr(2, 9),
            attributes: attrMap,
            price: '',
            original_price: '',
            stock: 10,
            sku: props.form.sku || vnSlugify(props.form.name) || '',
            sale_price: '',
            cost_price: '',
        };
    });
};

// Auto SKU per row
const generateSKU = (variant) => {
    let baseSku = vnSlugify(props.form.name) || props.form.sku || 'SKU';
    let parts = [];
    props.activeAttributes.forEach(attr => {
        const valId = variant.attributes[attr.id];
        if (valId) {
            const obj = attr.values.find(v => v.id == valId || v.value == valId);
            parts.push(vnSlugify(obj ? obj.value : valId).toUpperCase());
        }
    });
    variant.sku = baseSku.toUpperCase() + (parts.length ? '-' + parts.join('-') : '');
};

const removeVariantRow = (index) => { props.form.variants.splice(index, 1); };

// Bulk
const bulkPrice = ref('');
const bulkStock = ref('');
const applyBulk = () => {
    const p = parseMoney(bulkPrice.value);
    const s = parseInt(bulkStock.value);
    props.form.variants.forEach(v => {
        if (p) v.price = p;
        if (!isNaN(s)) v.stock = s;
    });
};
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

        <!-- Bulk Action -->
        <div class="bg-gray-50 dark:bg-slate-700/40 rounded-xl p-4 mb-5 flex flex-wrap items-end gap-4 border border-gray-200 dark:border-slate-600">
            <div>
                <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">💰 Giá hàng loạt (₫)</label>
                <div class="relative">
                    <input type="text" :value="formatMoney(bulkPrice)" @input="e => bulkPrice = e.target.value" class="w-44 py-2.5 pl-4 pr-12 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="500.000">
                    <span class="absolute right-3 top-1/2 -translate-y-1/2 text-xs font-bold text-gray-400">VND</span>
                </div>
            </div>
            <div>
                <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">📦 Tồn kho hàng loạt</label>
                <input type="number" v-model="bulkStock" class="w-32 py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="100">
            </div>
            <button @click.prevent="applyBulk" class="py-2.5 px-5 border-2 border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold rounded-xl text-sm hover:bg-indigo-50 dark:hover:bg-indigo-900/30 transition shadow-sm">
                Áp dụng ⚡
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
                                <input type="text" :value="formatMoney(variant.price)" @input="e => variant.price = parseMoney(e.target.value)" class="w-32 py-2.5 pl-4 pr-12 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" required placeholder="0">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <input type="text" :value="formatMoney(variant.sale_price)" @input="e => variant.sale_price = parseMoney(e.target.value)" class="w-28 py-2.5 pl-4 pr-12 border border-emerald-200 dark:border-emerald-800 bg-emerald-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition" placeholder="KM">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="relative">
                                <input type="text" :value="formatMoney(variant.cost_price)" @input="e => variant.cost_price = parseMoney(e.target.value)" class="w-28 py-2.5 pl-4 pr-12 border border-amber-200 dark:border-amber-800 bg-amber-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition" placeholder="Vốn">
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
                            <button type="button" @click.prevent="generateSKU(variant)" class="p-2 text-indigo-500 bg-indigo-50 dark:bg-indigo-900/30 hover:bg-indigo-600 hover:text-white rounded-lg transition" title="Auto SKU">
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
                            Chưa có biến thể. Chọn Thuộc tính rồi bấm <span class="font-bold text-indigo-500">"Tạo / Cập nhật Ma trận"</span>.
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
