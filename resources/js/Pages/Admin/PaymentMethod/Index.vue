<script setup>
import { ref, computed, watch } from 'vue';
import { useForm, Head, router, usePage } from '@inertiajs/vue3';

// ── Props ────────────────────────────────────────────
const props = defineProps({ methods: Array });
const page  = usePage();

// ── Toast ────────────────────────────────────────────
const toast     = ref({ show: false, msg: '', type: 'success' });
let toastTimer  = null;
const showToast = (msg, type = 'success') => {
    clearTimeout(toastTimer);
    toast.value = { show: true, msg, type };
    toastTimer  = setTimeout(() => toast.value.show = false, 3500);
};
watch(() => page.props.flash?.success, (m) => { if (m) showToast(m, 'success'); }, { immediate: true });
watch(() => page.props.errors,         (e) => { if (e?.error) showToast(e.error, 'error'); }, { immediate: true, deep: true });

// ── Type helpers ─────────────────────────────────────
const typeLabel = { gateway: 'Tự động', manual: 'Thủ công', cod: 'COD' };
const typeBadge = { gateway: 'bg-indigo-100 text-indigo-700', manual: 'bg-cyan-100 text-cyan-700', cod: 'bg-emerald-100 text-emerald-700' };

// ── Toggle active ────────────────────────────────────
const toggle = (method) => router.post(route('admin.payment-methods.toggle', method.id), {}, { preserveScroll: true });

// ── Edit modal ───────────────────────────────────────
const showModal  = ref(false);
const editTarget = ref(null);

const form = useForm({
    name:       '',
    code:       '',
    type:       'cod',
    logo_url:   '',
    // COD/Manual fields
    bank_id:      '',
    bank_account: '',
    bank_owner:   '',
    // Gateway (VNPay) fields
    tmn_code:    '',
    hash_secret: '',
    url:         'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
});

const openEdit = (method) => {
    editTarget.value = method;
    const cfg = method.config || {};
    form.name       = method.name;
    form.code       = method.code;
    form.type       = method.type;
    form.logo_url   = method.logo_url || '';
    // Manual / VietQR
    form.bank_id      = cfg.bank_id      || '';
    form.bank_account = cfg.bank_account || '';
    form.bank_owner   = cfg.bank_owner   || '';
    // Gateway / VNPay
    form.tmn_code    = cfg.tmn_code    || '';
    form.hash_secret = cfg.hash_secret || '';
    form.url         = cfg.url         || 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
    form.clearErrors();
    showModal.value = true;
};

const closeModal = () => { showModal.value = false; editTarget.value = null; };

// Build the config payload based on type before submitting
const buildConfig = () => {
    if (form.type === 'gateway') {
        return {
            tmn_code:    form.tmn_code.trim(),
            hash_secret: form.hash_secret.trim(),
            url:         form.url.trim(),
        };
    }
    if (form.type === 'manual') {
        return {
            bank_id:      form.bank_id.trim(),
            bank_account: form.bank_account.trim(),
            bank_owner:   form.bank_owner.trim(),
        };
    }
    return {};
};

const submitEdit = () => {
    const config = buildConfig();
    form.transform((data) => ({
        name:     data.name,
        code:     data.code,
        type:     data.type,
        logo_url: data.logo_url,
        config,
    }))
    .put(route('admin.payment-methods.update', editTarget.value.id), {
        preserveScroll: true,
        onSuccess: closeModal,
    });
};

// ── Confirm delete ───────────────────────────────────
const confirmDelete = (method) => {
    if (!confirm(`Xóa phương thức "${method.name}"?`)) return;
    router.delete(route('admin.payment-methods.destroy', method.id), { preserveScroll: true });
};

// ── QR preview (manual type) ─────────────────────────
const qrPreview = computed(() => {
    if (form.type !== 'manual' || !form.bank_id || !form.bank_account) return null;
    return `https://img.vietqr.io/image/${form.bank_id}-${form.bank_account}-compact2.png`
         + `?amount=10000&addInfo=PREVIEW&accountName=${encodeURIComponent(form.bank_owner || 'Preview')}`;
});

const banks = [
    { id: 'MB',   name: 'MB Bank' },
    { id: 'VCB',  name: 'Vietcombank' },
    { id: 'TCB',  name: 'Techcombank' },
    { id: 'ACB',  name: 'ACB' },
    { id: 'VPB',  name: 'VPBank' },
    { id: 'TPB',  name: 'TPBank' },
    { id: 'BIDV', name: 'BIDV' },
    { id: 'VTB',  name: 'Vietinbank' },
    { id: 'STB',  name: 'Sacombank' },
    { id: 'HDB',  name: 'HDBank' },
    { id: 'MSB',  name: 'MSB' },
    { id: 'SHB',  name: 'SHB' },
    { id: 'OCB',  name: 'OCB' },
];
</script>

<template>
    <Head title="Phương thức thanh toán" />

    <!-- ── Toast ── -->
    <Transition enter-active-class="transition duration-300" enter-from-class="opacity-0 translate-y-2"
                leave-active-class="transition duration-200"  leave-to-class="opacity-0 translate-y-2">
        <div v-if="toast.show" class="fixed bottom-6 right-6 z-[200] flex items-center gap-3 px-5 py-3.5 rounded-2xl shadow-xl text-sm font-bold text-white"
             :class="toast.type === 'success' ? 'bg-emerald-500' : 'bg-red-500'">
            <svg v-if="toast.type === 'success'" class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
            <svg v-else class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"/></svg>
            {{ toast.msg }}
        </div>
    </Transition>

    <div class="max-w-5xl mx-auto pb-10">

        <!-- ── Header ── -->
        <div class="mb-7">
            <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">Phương thức thanh toán</h1>
            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Quản lý và cấu hình các cổng thanh toán cho hệ thống OmniCommerce.</p>
        </div>

        <!-- ── Cards Grid ── -->
        <div class="grid grid-cols-1 gap-4">
            <div v-for="method in methods" :key="method.id"
                 class="bg-white dark:bg-slate-800 rounded-2xl border border-gray-200 dark:border-slate-700 shadow-sm overflow-hidden transition-all"
                 :class="!method.is_active ? 'opacity-60' : ''">

                <div class="p-6 flex items-center gap-5">

                    <!-- Logo -->
                    <div class="w-16 h-16 rounded-xl border border-gray-100 dark:border-slate-600 bg-gray-50 dark:bg-slate-700 flex items-center justify-center shrink-0 overflow-hidden">
                        <img v-if="method.logo_url" :src="method.logo_url" :alt="method.name" @error="method.logo_url = null" class="w-full h-full object-contain p-1">
                        <svg v-else class="w-8 h-8 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                        </svg>
                    </div>

                    <!-- Info -->
                    <div class="flex-1 min-w-0">
                        <div class="flex items-center gap-2 flex-wrap">
                            <h3 class="font-black text-gray-900 dark:text-white text-base">{{ method.name }}</h3>
                            <span class="text-[10px] font-bold uppercase px-2 py-0.5 rounded-full" :class="typeBadge[method.type]">
                                {{ typeLabel[method.type] }}
                            </span>
                            <span class="text-[10px] font-mono text-gray-400 bg-gray-100 dark:bg-slate-700 px-2 py-0.5 rounded-full">{{ method.code }}</span>
                        </div>

                        <!-- Config preview -->
                        <div class="mt-2 flex flex-wrap gap-x-5 gap-y-1 text-xs text-gray-500 dark:text-gray-400">
                            <template v-if="method.type === 'gateway' && method.config">
                                <span>TmnCode: <b class="text-gray-700 dark:text-gray-200 font-mono">{{ method.config.tmn_code || '—' }}</b></span>
                                <span>URL: <b class="text-gray-700 dark:text-gray-200 text-[10px]">{{ method.config.url?.replace('https://', '') || '—' }}</b></span>
                            </template>
                            <template v-else-if="method.type === 'manual' && method.config">
                                <span>NH: <b class="text-gray-700 dark:text-gray-200">{{ method.config.bank_id || '—' }}</b></span>
                                <span>STK: <b class="text-gray-700 dark:text-gray-200 font-mono">{{ method.config.bank_account || '—' }}</b></span>
                                <span>Chủ TK: <b class="text-gray-700 dark:text-gray-200">{{ method.config.bank_owner || '—' }}</b></span>
                            </template>
                            <span v-else class="italic">Không cần cấu hình</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="flex items-center gap-3 shrink-0">
                        <!-- Toggle switch -->
                        <label class="relative inline-flex items-center cursor-pointer" :title="method.is_active ? 'Đang bật – click để tắt' : 'Đang tắt – click để bật'">
                            <input type="checkbox" :checked="method.is_active" @change="toggle(method)" class="sr-only peer">
                            <div class="w-11 h-6 bg-gray-300 rounded-full peer
                                        peer-checked:after:translate-x-full peer-checked:after:border-white
                                        after:content-[''] after:absolute after:top-[2px] after:left-[2px]
                                        after:bg-white after:border-gray-300 after:border after:rounded-full
                                        after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600">
                            </div>
                        </label>

                        <!-- Edit btn -->
                        <button @click="openEdit(method)"
                            class="inline-flex items-center gap-1.5 px-4 py-2 text-xs font-bold text-indigo-600 bg-indigo-50 hover:bg-indigo-100
                                   dark:text-indigo-400 dark:bg-indigo-900/30 dark:hover:bg-indigo-900/50 rounded-xl transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                            Cấu hình
                        </button>

                        <!-- Delete btn (only non-COD) -->
                        <button v-if="method.code !== 'cod'" @click="confirmDelete(method)"
                            class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- ══════════════════════════════════════════════════ -->
    <!-- Edit Modal                                        -->
    <!-- ══════════════════════════════════════════════════ -->
    <Teleport to="body">
        <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0"
                    leave-active-class="transition duration-150" leave-to-class="opacity-0">
            <div v-if="showModal" class="fixed inset-0 bg-black/50 z-[100] flex items-center justify-center p-4" @click.self="closeModal">
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] flex flex-col overflow-hidden">

                    <!-- Modal Header -->
                    <div class="px-7 py-5 border-b border-gray-100 dark:border-slate-700 flex items-center justify-between shrink-0">
                        <div>
                            <h2 class="font-black text-gray-900 dark:text-white text-lg">Cấu hình phương thức</h2>
                            <p class="text-xs text-gray-500 mt-0.5">{{ editTarget?.name }}</p>
                        </div>
                        <button @click="closeModal" class="text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 p-1 rounded-lg hover:bg-gray-100 dark:hover:bg-slate-700 transition">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                        </button>
                    </div>

                    <!-- Modal Body -->
                    <div class="overflow-y-auto flex-1 px-7 py-6 space-y-5">

                        <!-- Name -->
                        <div>
                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Tên hiển thị</label>
                            <input v-model="form.name" type="text"
                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none">
                            <p v-if="form.errors.name" class="text-xs text-red-500 mt-1">{{ form.errors.name }}</p>
                        </div>

                        <!-- Logo URL -->
                        <div>
                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">URL Logo</label>
                            <input v-model="form.logo_url" type="text" placeholder="https://..."
                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>

                        <!-- ── COD: no extra config ── -->
                        <div v-if="form.type === 'cod'"
                             class="bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-100 dark:border-emerald-800 rounded-xl p-4">
                            <p class="text-sm text-emerald-700 dark:text-emerald-400 font-medium">
                                ✅ COD không cần cấu hình thêm — luôn hoạt động.
                            </p>
                        </div>

                        <!-- ── Manual (VietQR): bank fields ── -->
                        <template v-if="form.type === 'manual'">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Ngân hàng <span class="text-red-500">*</span></label>
                                <select v-model="form.bank_id"
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none">
                                    <option v-for="b in banks" :key="b.id" :value="b.id">{{ b.id }} – {{ b.name }}</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Số tài khoản <span class="text-red-500">*</span></label>
                                <input v-model="form.bank_account" type="text" placeholder="VD: 0123456789"
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono tracking-wider">
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Chủ tài khoản <span class="text-red-500">*</span></label>
                                <input v-model="form.bank_owner" type="text" placeholder="NGUYEN VAN A"
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none uppercase">
                                <p class="text-xs text-gray-400 mt-1">Nhập chữ IN HOA đúng với tên tài khoản ngân hàng.</p>
                            </div>
                            <!-- QR Preview -->
                            <div v-if="qrPreview" class="flex flex-col items-center pt-2">
                                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Preview QR</p>
                                <div class="w-36 h-36 border border-gray-200 dark:border-slate-600 rounded-xl overflow-hidden bg-white p-1">
                                    <img :src="qrPreview" alt="QR" class="w-full h-full object-contain">
                                </div>
                            </div>
                        </template>

                        <!-- ── Gateway (VNPay): API fields ── -->
                        <template v-if="form.type === 'gateway'">
                            <div class="bg-amber-50 dark:bg-amber-900/20 border border-amber-100 dark:border-amber-800 rounded-xl px-4 py-3">
                                <p class="text-xs text-amber-700 dark:text-amber-400 font-medium">⚠ Các trường bên dưới sẽ được lưu mã hóa trong database. Không chia sẻ với bên thứ 3.</p>
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Mã TmnCode (vnp_TmnCode) <span class="text-red-500">*</span></label>
                                <input v-model="form.tmn_code" type="text" placeholder="VD: CGXZLS0Z"
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono">
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Hash Secret (vnp_HashSecret) <span class="text-red-500">*</span></label>
                                <input v-model="form.hash_secret" type="password" placeholder="Nhập secret key..."
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono">
                                <p class="text-xs text-gray-400 mt-1">Dùng ký HMAC-SHA512 — phải trim() trước khi hash.</p>
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">URL Thanh toán</label>
                                <input v-model="form.url" type="text"
                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-gray-300 bg-gray-50 rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono text-xs">
                                <p class="text-xs text-amber-600 dark:text-amber-400 font-medium mt-1">Đổi sang link Live trước khi Go-live.</p>
                            </div>
                        </template>

                    </div>

                    <!-- Modal Footer -->
                    <div class="px-7 py-5 border-t border-gray-100 dark:border-slate-700 flex justify-end gap-3 shrink-0 bg-gray-50 dark:bg-slate-700/30">
                        <button @click="closeModal"
                            class="px-5 py-2.5 text-sm font-bold text-gray-600 dark:text-gray-300 bg-white dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-600 transition">
                            Hủy
                        </button>
                        <button @click="submitEdit" :disabled="form.processing"
                            class="px-6 py-2.5 text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-60 rounded-xl shadow-sm transition flex items-center gap-2">
                            <svg v-if="form.processing" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
                            </svg>
                            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                            {{ form.processing ? 'Đang lưu...' : 'Lưu cấu hình' }}
                        </button>
                    </div>

                </div>
            </div>
        </Transition>
    </Teleport>
</template>
