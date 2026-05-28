import { usePage } from '@inertiajs/vue3';

export function usePermission() {
    const page = usePage();

    /**
     * Returns true if the current user has the given permission.
     * Admins (role = 'admin') always pass.
     * Pass null/undefined to allow everyone.
     */
    const hasPermission = (permission) => {
        if (!permission) return true;
        const usr = page.props.auth?.user;
        if (!usr) return false;
        if (usr.roles && usr.roles.includes('admin')) return true;
        return !!(usr.permissions && usr.permissions.includes(permission));
    };

    return { hasPermission };
}
