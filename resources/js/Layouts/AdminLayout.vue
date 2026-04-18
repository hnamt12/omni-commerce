<script>
// AdminLayout is an alias for AuthenticatedLayout.
// The actual layout is applied globally in app.js via:
//   page.default.layout = page.default.layout || AuthenticatedLayout;
// This file exists so that components can import AdminLayout without errors.
import AuthenticatedLayout from './AuthenticatedLayout.vue';
export default AuthenticatedLayout;
</script>
