import { type User } from '@/types';
import { Link } from '@inertiajs/react';

interface HeaderProps {
    auth: {
        user: User;
    };
}

const NavigationLink = ({ href, children }: { href: string; children: React.ReactNode }) => (
    <Link href={href} className="text-lg hover:text-blue-500 transition-colors duration-300">
        {children}
    </Link>
);

const AuthLinks = ({ isAuthenticated }: { isAuthenticated: boolean }) => (
    isAuthenticated ? (
        <NavigationLink href="/dashboard">Dashboard</NavigationLink>
    ) : (
        <>
            <NavigationLink href="/login">Bejelentkezés</NavigationLink>
            <NavigationLink href="/register">Regisztráció</NavigationLink>
        </>
    )
);

export default function Header({ auth }: HeaderProps) {
    return (
        <header className="flex flex-row justify-between items-center p-4">
            <nav className="flex flex-row gap-6">
                <NavigationLink href="/">Főoldal</NavigationLink>
                <AuthLinks isAuthenticated={!!auth.user} />
            </nav>
        </header>
    );
};
