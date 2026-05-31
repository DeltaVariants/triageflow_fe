import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';
import { AuthState } from './types';

interface AuthActions {
    setUser: (user: unknown) => void;
    setLoading: (isLoading: boolean) => void;
    setError: (error: string | null) => void;
    logout: () => void;
    reset: () => void;
}

type AuthStore = AuthState & AuthActions;

const initialState: AuthState = {
    user: null,
    isLoading: false,
    error: null,
};

export const useAuthStore = create<AuthStore>()(
    devtools(
        persist(
            (set) => ({
                ...initialState,
                setUser: (user) => set({ user, error: null }),
                setLoading: (isLoading) => set({ isLoading }),
                setError: (error) => set({ error }),
                logout: () => set({ user: null, error: null }),
                reset: () => set(initialState),
            }),
            {
                name: 'auth-storage',
            }
        )
    )
);
