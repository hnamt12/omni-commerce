<script setup>
import { ref, computed, watch } from 'vue';
import { useForm } from '@inertiajs/vue3';

// ── Props & Emits ─────────────────────────────────────────────────────────────
const props = defineProps({
    show:   { type: Boolean, required: true },
    method: { type: Object,  default: null  },
});

const emit = defineEmits(['close', 'saved']);

// ── Form ──────────────────────────────────────────────────────────────────────
const form = useForm({
    name:         '',
    code:         '',
    type:         'cod',
    logo_url:     '',
    is_active:    true,
    // Flat fields (used for binding in the template)
    bank_id:      '',
    bank_account: '',
    bank_owner:   '',
    bank_name:    '',
    account_no:   '',
    account_name: '',
    tmn_code:     '',
    hash_secret:  '',
    url:          'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
});

// ── Sync form when method prop changes ────────────────────────────────────────
watch(() => props.method, (m) => {
    if (!m) {
        form.reset();
        form.clearErrors();
        return;
    }
    const cfg = m.config || {};
    form.name         = m.name      || '';
    form.code         = m.code      || '';
    form.type         = m.type      || 'cod';
    form.logo_url     = m.logo_url  || '';
    form.is_active    = !!m.is_active;
    // Manual / VietQR
    form.bank_id      = cfg.bank_id      || '';
    form.bank_account = cfg.bank_account || '';
    form.bank_owner   = cfg.bank_owner   || '';
    // Bank Transfer
    form.bank_name    = cfg.bank_name    || '';
    form.account_no   = cfg.account_no   || '';
    form.account_name = cfg.account_name || '';
    // Gateway / VNPay
    form.tmn_code     = cfg.tmn_code    || '';
    form.hash_secret  = cfg.hash_secret || '';
    form.url          = cfg.url         || 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
    form.clearErrors();
}, { immediate: true });

// ── Config payload builder ────────────────────────────────────────────────────
const buildConfig = () => {
    if (form.type === 'gateway') {
        return {
            tmn_code:    form.tmn_code.trim(),
            hash_secret: form.hash_secret.trim(),
            url:         form.url.trim(),
        };
    }
    if (form.type === 'manual') {
        if (props.method?.code === 'bank_transfer') {
            return {
                bank_name:    form.bank_name.trim(),
                account_no:   form.account_no.trim(),
                account_name: form.account_name.trim(),
            };
        }
        return {
            bank_id:      form.bank_id.trim(),
            bank_account: form.bank_account.trim(),
            bank_owner:   form.bank_owner.trim(),
        };
    }
    return {};
};

// ── Submit ────────────────────────────────────────────────────────────────────
const submit = () => {
    const config = buildConfig();
    const payload = {
        name:      form.name,
        code:      form.code,
        type:      form.type,
        logo_url:  form.logo_url,
        is_active: form.is_active,
        config,
    };

    if (props.method) {
        form.transform(() => payload).put(route('admin.payment-methods.update', props.method.id), {
            preserveScroll: true,
            onSuccess: () => {
                if (!form.hasErrors) {
                    emit('saved');
                    emit('close');
                }
            },
        });
    } else {
        form.transform(() => payload).post(route('admin.payment-methods.store'), {
            preserveScroll: true,
            onSuccess: () => {
                if (!form.hasErrors) {
                    emit('saved');
                    emit('close');
                }
            },
        });
    }
};

const close = () => { form.clearErrors(); emit('close'); };

// ── VietQR live preview ───────────────────────────────────────────────────────
const qrPreview = computed(() => {
    if (form.type !== 'manual' || form.code === 'bank_transfer') return null;
    if (!form.bank_id || !form.bank_account) return null;
    return `https://img.vietqr.io/image/${form.bank_id}-${form.bank_account}-compact2.png`
         + `?amount=10000&addInfo=PREVIEW&accountName=${encodeURIComponent(form.bank_owner || 'Preview')}`;
});

// ── Bank list ─────────────────────────────────────────────────────────────────
const banks = [
    { id: 'MB',   name: 'MB Bank'     },
    { id: 'VCB',  name: 'Vietcombank' },
    { id: 'TCB',  name: 'Techcombank' },
    { id: 'ACB',  name: 'ACB'         },
    { id: 'VPB',  name: 'VPBank'      },
    { id: 'TPB',  name: 'TPBank'      },
    { id: 'BIDV', name: 'BIDV'        },
    { id: 'VTB',  name: 'Vietinbank'  },
    { id: 'STB',  name: 'Sacombank'   },
    { id: 'HDB',  name: 'HDBank'      },
    { id: 'MSB',  name: 'MSB'         },
    { id: 'SHB',  name: 'SHB'         },
    { id: 'OCB',  name: 'OCB'         },
];
</script>

<template>
    <Teleport to="body">
        <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0 scale-95"
                    leave-active-class="transition duration-150" leave-to-class="opacity-0 scale-95">
            <div v-if="show"
                 class="fixed inset-0 bg-black/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4 sm:p-6"
                 @click.self="close">

                <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-2xl w-full max-w-5xl flex flex-col max-h-[90vh] overflow-hidden border border-gray-100 dark:border-slate-800">

                    <!-- ── Modal Header ── -->
                    <div class="px-6 py-4 border-b border-gray-100 dark:border-slate-800 flex items-center justify-between shrink-0 bg-white dark:bg-slate-900">
                        <div>
                            <h2 class="font-black text-gray-900 dark:text-white text-lg tracking-tight">
                                {{ method ? 'Cấu hình: ' + method.name : 'Thêm phương thức mới' }}
                            </h2>
                            <p class="text-xs text-gray-500 mt-0.5">Thiết lập các thông số kết nối và hiển thị</p>
                        </div>
                        <button @click="close"
                            class="text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 p-2 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-800 transition">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>

                    <!-- ── Modal Body ── -->
                    <div class="flex-1 overflow-y-auto p-6 bg-gray-50/50 dark:bg-slate-900/50">
                        
                        <!-- Global Error Banner -->
                        <div v-if="$page.props.errors?.error" class="mb-6 bg-red-50 text-red-600 border border-red-200 p-4 rounded-xl text-sm font-medium flex items-start gap-3 shadow-sm">
                            <svg class="w-5 h-5 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <div>{{ $page.props.errors?.error }}</div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
                            
                            <!-- ── Left Column: Basic Info ── -->
                            <div class="md:col-span-5 space-y-5 bg-white dark:bg-slate-800 p-5 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm h-fit">
                                <h3 class="text-sm font-extrabold flex items-center gap-2 text-gray-900 dark:text-white uppercase tracking-wider mb-2 border-b border-gray-100 dark:border-slate-700 pb-3">
                                    <svg class="w-4 h-4 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    Thông tin chung
                                </h3>

                                <!-- Name -->
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Tên hiển thị <span class="text-red-500">*</span></label>
                                    <input v-model="form.name" type="text" placeholder="VD: Thẻ tín dụng, Momo..."
                                        class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow">
                                    <p v-if="form.errors.name" class="text-xs text-red-500 mt-1">{{ form.errors.name }}</p>
                                </div>

                                <!-- Code -->
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Mã code <span class="text-red-500">*</span></label>
                                    <input v-model="form.code" type="text" placeholder="VD: momo, vnpay"
                                        class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono transition-shadow">
                                    <p v-if="form.errors.code" class="text-xs text-red-500 mt-1">{{ form.errors.code }}</p>
                                </div>

                                <!-- Type -->
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">Loại hình <span class="text-red-500">*</span></label>
                                    <select v-model="form.type"
                                        class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow">
                                        <option value="cod">Thu hộ (COD)</option>
                                        <option value="manual">Thủ công (Chuyển khoản)</option>
                                        <option value="gateway">Cổng thanh toán tự động</option>
                                    </select>
                                    <p v-if="form.errors.type" class="text-xs text-red-500 mt-1">{{ form.errors.type }}</p>
                                </div>

                                <!-- Logo URL -->
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">URL Logo</label>
                                    <input v-model="form.logo_url" type="text" placeholder="https://..."
                                        class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow">
                                </div>
                            </div>

                            <!-- ── Right Column: Configuration ── -->
                            <div class="md:col-span-7 space-y-5 bg-white dark:bg-slate-800 p-5 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm">
                                <h3 class="text-sm font-extrabold flex items-center gap-2 text-gray-900 dark:text-white uppercase tracking-wider mb-2 border-b border-gray-100 dark:border-slate-700 pb-3">
                                    <svg class="w-4 h-4 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                    Cấu hình chi tiết
                                </h3>

                                <!-- COD -->
                                <div v-if="form.type === 'cod'"
                                     class="bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-100 dark:border-emerald-800 rounded-xl p-5 flex items-start gap-4">
                                    <div class="bg-emerald-100 dark:bg-emerald-800 p-2 rounded-full shrink-0">
                                        <svg class="w-6 h-6 text-emerald-600 dark:text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-emerald-800 dark:text-emerald-300">Phương thức thanh toán tiền mặt</h4>
                                        <p class="text-sm text-emerald-700 dark:text-emerald-400 mt-1">
                                            COD (Cash On Delivery) không yêu cầu cấu hình API. Hệ thống sẽ tự động ghi nhận thanh toán khi đơn vị vận chuyển báo giao hàng thành công.
                                        </p>
                                    </div>
                                </div>

                                <!-- Bank Transfer -->
                                <template v-if="form.type === 'manual' && form.code === 'bank_transfer'">
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                Tên ngân hàng <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="form.bank_name" type="text" placeholder="VD: MB Bank, Vietcombank"
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                Số tài khoản <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="form.account_no" type="text" placeholder="VD: 0123456789"
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono tracking-wider transition-shadow">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                Tên chủ tài khoản <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="form.account_name" type="text" placeholder="NGUYEN VAN A"
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none uppercase transition-shadow">
                                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1.5 flex items-center gap-1">
                                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                                Nhập chữ IN HOA không dấu đúng với thẻ ngân hàng.
                                            </p>
                                        </div>
                                    </div>
                                </template>

                                <!-- VietQR -->
                                <template v-if="form.type === 'manual' && form.code !== 'bank_transfer'">
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                        <div class="space-y-4">
                                            <div>
                                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                    Ngân hàng <span class="text-red-500">*</span>
                                                </label>
                                                <select v-model="form.bank_id"
                                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow">
                                                    <option value="" disabled>Chọn ngân hàng</option>
                                                    <option v-for="b in banks" :key="b.id" :value="b.id">{{ b.id }} – {{ b.name }}</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                    Số tài khoản <span class="text-red-500">*</span>
                                                </label>
                                                <input v-model="form.bank_account" type="text" placeholder="VD: 0123456789"
                                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono tracking-wider transition-shadow">
                                            </div>
                                            <div>
                                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                    Chủ tài khoản <span class="text-red-500">*</span>
                                                </label>
                                                <input v-model="form.bank_owner" type="text" placeholder="NGUYEN VAN A"
                                                    class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none uppercase transition-shadow">
                                            </div>
                                        </div>
                                        
                                        <!-- Live QR Preview Terminal -->
                                        <div class="flex flex-col items-center justify-center bg-gray-50 dark:bg-slate-900 rounded-xl border border-gray-200 dark:border-slate-700 p-4">
                                            <p class="text-xs font-black text-gray-500 dark:text-gray-400 uppercase tracking-widest mb-4">Preview QR Code</p>
                                            <div v-if="qrPreview" class="w-40 h-40 bg-white p-2 rounded-xl shadow-sm border border-gray-100 flex items-center justify-center relative group">
                                                <img :src="qrPreview" alt="QR" class="w-full h-full object-contain">
                                                <div class="absolute inset-0 border-2 border-indigo-500/0 group-hover:border-indigo-500/50 rounded-xl transition-colors pointer-events-none"></div>
                                            </div>
                                            <div v-else class="w-40 h-40 bg-gray-100 dark:bg-slate-800 rounded-xl border border-dashed border-gray-300 dark:border-slate-600 flex flex-col items-center justify-center text-gray-400">
                                                <svg class="w-8 h-8 mb-2 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm14 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                                                </svg>
                                                <span class="text-xs font-medium text-center px-4">Nhập đủ thông tin để hiển thị</span>
                                            </div>
                                        </div>
                                    </div>
                                </template>

                                <!-- Gateway / VNPay -->
                                <template v-if="form.type === 'gateway'">
                                    <div class="space-y-4">
                                        <div class="bg-amber-50 dark:bg-amber-900/20 border border-amber-100 dark:border-amber-800/50 rounded-xl px-4 py-3 flex items-start gap-3">
                                            <svg class="w-5 h-5 text-amber-600 dark:text-amber-500 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                            </svg>
                                            <p class="text-xs text-amber-800 dark:text-amber-300 font-medium leading-relaxed">
                                                Mã TmnCode và Hash Secret là thông tin nhạy cảm. Chúng sẽ được mã hóa an toàn trong database. Tuyệt đối không chia sẻ với bên thứ ba.
                                            </p>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                Mã TmnCode (vnp_TmnCode) <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="form.tmn_code" type="text" placeholder="VD: CGXZLS0Z"
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono transition-shadow">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">
                                                Hash Secret (vnp_HashSecret) <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="form.hash_secret" type="password" placeholder="Nhập secret key..."
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-white rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono transition-shadow">
                                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1.5 flex items-center gap-1">
                                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                                Sử dụng thuật toán HMAC-SHA512.
                                            </p>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-1.5">URL Thanh toán <span class="text-red-500">*</span></label>
                                            <input v-model="form.url" type="text"
                                                class="w-full border border-gray-300 dark:border-slate-600 dark:bg-slate-700 dark:text-gray-300 bg-gray-50 rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 outline-none font-mono text-xs transition-shadow">
                                            <p class="text-xs text-indigo-600 dark:text-indigo-400 font-medium mt-1.5 flex items-center gap-1">
                                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
                                                Nhớ đổi sang link Live (vpcpay.html) trước khi Go-live.
                                            </p>
                                        </div>
                                    </div>
                                </template>

                            </div>
                            
                        </div>
                    </div>

                    <!-- ── Modal Footer ── -->
                    <div class="px-6 py-4 border-t border-gray-100 dark:border-slate-800 flex justify-end gap-3 shrink-0 bg-white dark:bg-slate-900">
                        <button @click="close"
                            class="px-5 py-2.5 text-sm font-bold text-gray-600 dark:text-gray-300 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl hover:bg-gray-50 dark:hover:bg-slate-700 transition shadow-sm">
                            Hủy bỏ
                        </button>
                        <button @click="submit" :disabled="form.processing"
                            class="px-6 py-2.5 text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-60 rounded-xl shadow-md hover:shadow-lg transition flex items-center gap-2">
                            <svg v-if="form.processing" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
                            </svg>
                            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            {{ form.processing ? 'Đang xử lý...' : 'Lưu cấu hình' }}
                        </button>
                    </div>

                </div>
            </div>
        </Transition>
    </Teleport>
</template>
