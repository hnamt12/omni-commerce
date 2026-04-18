<script setup>
import { ref, onMounted, watch } from 'vue';
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import { useLocation } from '@/Composables/useLocation';
import SearchableSelect from '@/Components/SearchableSelect.vue';

const props = defineProps({
    customer:  { type: Object, required: true },
    addresses: { type: Array,  default: () => [] },
});

const activeTab = ref('info');

// ── Info form ─────────────────────────────────────
const infoForm = useForm({
    name:   props.customer.name   ?? '',
    phone:  props.customer.phone  ?? '',
    gender: props.customer.gender ?? 'other',
    avatar: null
});

// Logic xem trước ảnh
const fileInput = ref(null);
const avatarPreview = ref(props.customer.avatar || null);

const triggerFileInput = () => { fileInput.value.click(); };

const onFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
        infoForm.avatar = file; 
        avatarPreview.value = URL.createObjectURL(file); 
    }
};

const updateInfo = () => infoForm.post(route('client.profile.update'), { preserveScroll: true });

const logout = () => router.post(route('client.logout'));

// ── Address form + location ────────────────────────
const { provinces, districts, wards, fetchProvinces, fetchDistricts, fetchWards } = useLocation();
const showModal = ref(false);

const addrForm = useForm({
    name: '', phone_number: '',
    province_id: '', province_name: '',
    district_id: '', district_name: '',
    ward_id: '',     ward_name: '',
    address: '', is_default: false,
});

watch(() => addrForm.province_id, (id) => {
    fetchDistricts(id);
    addrForm.province_name = provinces.value.find(p => p.id === id)?.full_name || '';
    addrForm.district_id   = '';
    addrForm.ward_id       = '';
});
watch(() => addrForm.district_id, (id) => {
    fetchWards(id);
    addrForm.district_name = districts.value.find(d => d.id === id)?.full_name || '';
    addrForm.ward_id       = '';
});
watch(() => addrForm.ward_id, (id) => {
    addrForm.ward_name = wards.value.find(w => w.id === id)?.full_name || '';
});

const submitAddress = () => {
    addrForm.post(route('client.address.store'), {
        onSuccess: () => { showModal.value = false; addrForm.reset(); },
    });
};

const openModal = () => {
    addrForm.reset();
    showModal.value = true;
};

onMounted(fetchProvinces);
</script>

<template>
    <Head title="Hồ sơ của tôi – OmniCommerce" />
    <ClientLayout>
        <div class="bg-gray-50 min-h-screen py-8">
            <div class="max-w-[1100px] mx-auto px-4">
                <div class="flex flex-col md:flex-row gap-6">

                    <!-- ── SIDEBAR ──────────────────────────────── -->
                    <aside class="w-full md:w-56 shrink-0">
                        <!-- Avatar card -->
                        <div class="flex items-center gap-3 mb-4 p-4 bg-white rounded-2xl shadow-sm border border-gray-100">
                            <div class="w-11 h-11 rounded-full bg-gradient-to-br from-red-400 to-orange-400 text-white font-black text-lg flex items-center justify-center shadow shrink-0">
                                {{ customer.name?.charAt(0).toUpperCase() }}
                            </div>
                            <div class="min-w-0">
                                <p class="font-bold text-gray-900 text-sm truncate">{{ customer.name }}</p>
                                <p class="text-xs text-gray-400 truncate">{{ customer.email }}</p>
                            </div>
                        </div>

                        <!-- Nav -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden text-sm">
                            <Link :href="route('client.order.index')"
                                class="flex items-center gap-2.5 px-4 py-3 text-gray-600 hover:text-red-500 hover:bg-red-50 transition border-b border-gray-50">
                                📦 Đơn hàng của tôi
                            </Link>
                            <button @click="activeTab = 'info'"
                                :class="activeTab === 'info' ? 'text-red-600 bg-red-50 font-bold' : 'text-gray-600 hover:text-red-500 hover:bg-red-50'"
                                class="w-full flex items-center gap-2.5 px-4 py-3 transition border-b border-gray-50 text-left">
                                👤 Thông tin cá nhân
                            </button>
                            <button @click="activeTab = 'address'"
                                :class="activeTab === 'address' ? 'text-red-600 bg-red-50 font-bold' : 'text-gray-600 hover:text-red-500 hover:bg-red-50'"
                                class="w-full flex items-center gap-2.5 px-4 py-3 transition border-b border-gray-50 text-left">
                                📍 Sổ địa chỉ
                            </button>
                            <button @click="logout"
                                class="w-full flex items-center gap-2.5 px-4 py-3 text-left text-gray-500 hover:text-red-500 hover:bg-red-50 transition">
                                🚪 Đăng xuất
                            </button>
                        </div>
                    </aside>

                    <!-- ── CONTENT ───────────────────────────────── -->
                    <div class="flex-1 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">

                        <!-- ── INFO TAB ── -->
                        <div v-if="activeTab === 'info'">
                            <div class="pb-4 mb-6 border-b border-gray-100">
                                <h2 class="text-lg font-black text-gray-900">Hồ Sơ Của Tôi</h2>
                                <p class="text-xs text-gray-500 mt-0.5">Quản lý thông tin để bảo mật tài khoản</p>
                            </div>

                            <!-- Flash success -->
                            <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0 -translate-y-1" leave-to-class="opacity-0">
                                <div v-if="$page.props.flash?.success"
                                    class="mb-5 flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 text-sm px-4 py-2.5 rounded-xl">
                                    ✅ {{ $page.props.flash.success }}
                                </div>
                            </Transition>

                            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                                <!-- Form -->
                                <div class="md:col-span-2 space-y-4 text-sm">
                                    <div class="flex items-center gap-4">
                                        <label class="w-32 text-right text-gray-500 shrink-0">Email</label>
                                        <div class="flex items-center gap-2">
                                            <span class="font-medium text-gray-900">{{ customer.email }}</span>
                                            <span class="text-green-500 text-xs font-bold">✓ Đã xác thực</span>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-4">
                                        <label class="w-32 text-right text-gray-500 shrink-0">Họ và tên</label>
                                        <input v-model="infoForm.name" type="text"
                                            class="flex-1 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300">
                                    </div>
                                    <div class="flex items-center gap-4">
                                        <label class="w-32 text-right text-gray-500 shrink-0">Số điện thoại</label>
                                        <input v-model="infoForm.phone" type="text"
                                            class="flex-1 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300">
                                    </div>
                                    <div class="flex items-center gap-4">
                                        <label class="w-32 text-right text-gray-500 shrink-0">Giới tính</label>
                                        <div class="flex items-center gap-4">
                                            <label class="flex items-center gap-1.5 cursor-pointer">
                                                <input type="radio" v-model="infoForm.gender" value="male" class="text-red-500"> Nam
                                            </label>
                                            <label class="flex items-center gap-1.5 cursor-pointer">
                                                <input type="radio" v-model="infoForm.gender" value="female" class="text-red-500"> Nữ
                                            </label>
                                            <label class="flex items-center gap-1.5 cursor-pointer">
                                                <input type="radio" v-model="infoForm.gender" value="other" class="text-red-500"> Khác
                                            </label>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-4">
                                        <span class="w-32 shrink-0"></span>
                                        <button @click="updateInfo" :disabled="infoForm.processing"
                                            class="bg-red-500 hover:bg-red-600 text-white font-bold px-7 py-2.5 rounded-xl text-sm transition disabled:opacity-60">
                                            {{ infoForm.processing ? 'Đang lưu...' : 'Lưu thay đổi' }}
                                        </button>
                                    </div>
                                </div>

                                <!-- Avatar -->
                                <div class="flex flex-col items-center gap-3">
                                    <div class="w-24 h-24 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold text-3xl shadow-sm overflow-hidden mb-4">
                                        <img v-if="avatarPreview" :src="avatarPreview" class="w-full h-full object-cover">
                                        <span v-else>{{ infoForm.name.charAt(0).toUpperCase() }}</span>
                                    </div>
                                    <button @click="triggerFileInput" type="button" class="bg-blue-50 hover:bg-blue-100 text-blue-600 border border-blue-200 px-4 py-2 rounded-full text-xs font-bold transition flex items-center gap-2">
                                        📷 Đổi ảnh đại diện
                                    </button>
                                    <p class="text-[10px] text-gray-400 mt-2">JPEG, PNG tối đa 2MB</p>
                                    <input type="file" ref="fileInput" class="hidden" accept="image/jpeg, image/png, image/jpg" @change="onFileChange">
                                </div>
                            </div>

                            <!-- Security box -->
                            <div class="mt-8 p-4 bg-red-50 border border-red-100 rounded-2xl flex items-center justify-between">
                                <div>
                                    <p class="font-black text-gray-900 text-sm">Bảo mật tài khoản</p>
                                    <p class="text-xs text-gray-500 mt-0.5">Đổi mật khẩu định kỳ để bảo vệ tài khoản</p>
                                </div>
                                <button class="bg-red-500 hover:bg-red-600 text-white font-bold px-5 py-2 rounded-xl text-sm transition shadow-sm">
                                    🔑 Đổi mật khẩu
                                </button>
                            </div>
                        </div>

                        <!-- ── ADDRESS TAB ── -->
                        <div v-else-if="activeTab === 'address'">
                            <div class="flex justify-between items-center pb-4 mb-5 border-b border-gray-100">
                                <div>
                                    <h2 class="text-lg font-black text-gray-900">Địa Chỉ Của Tôi</h2>
                                    <p class="text-xs text-gray-500 mt-0.5">Quản lý sổ địa chỉ giao hàng</p>
                                </div>
                                <button @click="openModal"
                                    class="bg-red-500 hover:bg-red-600 text-white font-bold px-4 py-2 rounded-xl text-sm transition shadow-sm">
                                    + Thêm địa chỉ mới
                                </button>
                            </div>

                            <!-- Flash success (address tab) -->
                            <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0 -translate-y-1" leave-to-class="opacity-0">
                                <div v-if="$page.props.flash?.success"
                                    class="mb-5 flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 text-sm px-4 py-2.5 rounded-xl">
                                    ✅ {{ $page.props.flash.success }}
                                </div>
                            </Transition>

                            <div v-if="addresses.length" class="space-y-3">
                                <div v-for="addr in addresses" :key="addr.id"
                                    class="flex justify-between items-start p-4 border border-gray-200 rounded-xl hover:border-gray-300 transition">
                                    <div>
                                        <p class="font-bold text-gray-900 text-sm">
                                            {{ addr.name }}
                                            <span class="font-normal text-gray-500 ml-2">| {{ addr.phone_number }}</span>
                                        </p>
                                        <p class="text-sm text-gray-600 mt-1">{{ addr.address }}</p>
                                        <span v-if="addr.is_default"
                                            class="inline-block mt-2 border border-red-500 text-red-500 text-[10px] font-bold px-2 py-0.5 rounded">
                                            Mặc định
                                        </span>
                                    </div>
                                    <button class="text-xs text-indigo-600 font-bold hover:underline ml-4 shrink-0">
                                        Cập nhật
                                    </button>
                                </div>
                            </div>
                            <p v-else class="text-center text-gray-400 py-12 text-sm">
                                📍 Bạn chưa có địa chỉ nào được lưu.
                            </p>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!-- ══════ ADD ADDRESS MODAL ══════ -->
        <Teleport to="body">
            <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0"
                        leave-active-class="transition duration-150" leave-to-class="opacity-0">
                <div v-if="showModal"
                    class="fixed inset-0 bg-black/50 z-[100] flex items-center justify-center p-4"
                    @click.self="showModal = false">
                    <div class="bg-white rounded-2xl w-full max-w-3xl shadow-2xl flex flex-col max-h-[90vh]">

                        <!-- Modal header -->
                        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
                            <h3 class="font-black text-gray-900 text-base">📍 Thêm địa chỉ mới</h3>
                            <button @click="showModal = false"
                                class="text-gray-400 hover:text-gray-800 text-xl font-bold leading-none transition">✕</button>
                        </div>

                        <!-- Modal body -->
                        <div class="p-6 space-y-4 overflow-y-auto flex-1">

                            <!-- Họ tên + SĐT -->
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                        Họ và tên <span class="text-red-500">*</span>
                                    </label>
                                    <input v-model="addrForm.name" type="text" placeholder="Nguyễn Văn A"
                                        autocomplete="name"
                                        class="w-full border border-gray-300 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-red-300 transition">
                                    <p v-if="addrForm.errors.name" class="mt-1 text-xs text-red-600">{{ addrForm.errors.name }}</p>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                        Số điện thoại <span class="text-red-500">*</span>
                                    </label>
                                    <input v-model="addrForm.phone_number" type="text" placeholder="0912 345 678"
                                        autocomplete="tel"
                                        class="w-full border border-gray-300 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-red-300 transition">
                                    <p v-if="addrForm.errors.phone_number" class="mt-1 text-xs text-red-600">{{ addrForm.errors.phone_number }}</p>
                                </div>
                            </div>

                            <!-- Tỉnh / Huyện / Xã -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                        Tỉnh / Thành <span class="text-red-500">*</span>
                                    </label>
                                    <SearchableSelect
                                        v-model="addrForm.province_id"
                                        :options="provinces"
                                        placeholder="Chọn Tỉnh/Thành..."
                                    />
                                    <p v-if="addrForm.errors.province_id" class="mt-1 text-xs text-red-600">{{ addrForm.errors.province_id }}</p>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                        Quận / Huyện <span class="text-red-500">*</span>
                                    </label>
                                    <SearchableSelect
                                        v-model="addrForm.district_id"
                                        :options="districts"
                                        :disabled="!districts.length"
                                        placeholder="Chọn Quận/Huyện..."
                                    />
                                    <p v-if="addrForm.errors.district_id" class="mt-1 text-xs text-red-600">{{ addrForm.errors.district_id }}</p>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                        Phường / Xã <span class="text-red-500">*</span>
                                    </label>
                                    <SearchableSelect
                                        v-model="addrForm.ward_id"
                                        :options="wards"
                                        :disabled="!wards.length"
                                        placeholder="Chọn Phường/Xã..."
                                    />
                                    <p v-if="addrForm.errors.ward_id" class="mt-1 text-xs text-red-600">{{ addrForm.errors.ward_id }}</p>
                                </div>
                            </div>

                            <!-- Địa chỉ cụ thể -->
                            <div class="mt-1">
                                <label class="block text-xs font-bold text-gray-700 mb-1.5">
                                    Địa chỉ cụ thể <span class="text-red-500">*</span>
                                </label>
                                <textarea v-model="addrForm.address" rows="3"
                                    autocomplete="street-address"
                                    placeholder="Số nhà, ngõ, tên đường..."
                                    class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-300 resize-y transition"></textarea>
                                <p v-if="addrForm.errors.address" class="mt-1 text-xs text-red-600">{{ addrForm.errors.address }}</p>
                            </div>

                            <!-- Checkbox mặc định -->
                            <label class="flex items-center gap-2.5 cursor-pointer select-none">
                                <input type="checkbox" v-model="addrForm.is_default"
                                    class="w-4 h-4 text-red-500 border-gray-300 rounded focus:ring-red-400 cursor-pointer">
                                <span class="text-sm text-gray-700 font-medium">Đặt làm địa chỉ mặc định</span>
                            </label>
                        </div>

                        <!-- Modal footer -->
                        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100">
                            <button @click="showModal = false"
                                class="px-5 py-2.5 rounded-xl border border-gray-300 text-sm font-bold text-gray-600 hover:bg-gray-50 transition">
                                Hủy
                            </button>
                            <button @click="submitAddress" :disabled="addrForm.processing"
                                class="px-6 py-2.5 rounded-xl bg-red-500 hover:bg-red-600 text-white text-sm font-bold shadow-sm transition disabled:opacity-60 flex items-center gap-2">
                                <svg v-if="addrForm.processing" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                                </svg>
                                {{ addrForm.processing ? 'Đang lưu...' : 'Lưu địa chỉ' }}
                            </button>
                        </div>
                    </div>
                </div>
            </Transition>
        </Teleport>

    </ClientLayout>
</template>
