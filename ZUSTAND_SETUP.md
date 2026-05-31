# Zustand Store Configuration

## 📁 Folder Structure

```
store/
├── index.ts          # Export all stores
├── types.ts          # TypeScript types for all stores
├── authStore.ts      # Authentication state management
└── uiStore.ts        # UI state management
```

## 🚀 Usage Examples

### 1. **Using Auth Store**

```typescript
'use client';

import { useAuthStore } from '@/store';

function LoginComponent() {
  const { user, isLoading, setUser, logout } = useAuthStore();

  return (
    <>
      {user ? (
        <button onClick={logout}>Logout</button>
      ) : (
        <button onClick={() => setUser({ id: 1, name: 'John' })}>
          Login
        </button>
      )}
    </>
  );
}
```

### 2. **Using UI Store**

```typescript
'use client';

import { useUIStore } from '@/store';

function SidebarToggle() {
  const { sidebarOpen, toggleSidebar } = useUIStore();

  return (
    <button onClick={toggleSidebar}>
      {sidebarOpen ? 'Close' : 'Open'} Sidebar
    </button>
  );
}
```

### 3. **Using Notifications**

```typescript
'use client';

import { useUIStore } from '@/store';

function NotificationExample() {
  const { addNotification, notifications } = useUIStore();

  const showNotification = () => {
    addNotification({
      message: 'This is a success message!',
      type: 'success',
      duration: 3000,
    });
  };

  return (
    <>
      <button onClick={showNotification}>Show Notification</button>
      {notifications.map((notif) => (
        <div key={notif.id}>{notif.message}</div>
      ))}
    </>
  );
}
```

## 🔧 Store Features

### **Auth Store** (`authStore.ts`)
- ✅ Persistent storage (localStorage)
- ✅ Redux DevTools integration
- ✅ User state management
- ✅ Loading and error states
- ✅ Logout and reset functions

### **UI Store** (`uiStore.ts`)
- ✅ Sidebar toggle state
- ✅ Theme switching (light/dark)
- ✅ Notification management
- ✅ Redux DevTools integration

## 📝 Adding New Stores

1. **Add type in `types.ts`:**
```typescript
export interface NewState {
  value: string;
}
```

2. **Create new store file:**
```typescript
import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { NewState } from './types';

interface NewActions {
  setValue: (value: string) => void;
}

type NewStore = NewState & NewActions;

export const useNewStore = create<NewStore>()(
  devtools((set) => ({
    value: '',
    setValue: (value) => set({ value }),
  }))
);
```

3. **Export in `index.ts`:**
```typescript
export { useNewStore } from './newStore';
```

## 🛠️ Middleware Available

- **`devtools`**: Redux DevTools integration for debugging
- **`persist`**: LocalStorage persistence (used in authStore)

## 💡 Best Practices

1. Always use `'use client'` directive in components using stores
2. Keep stores focused on specific domains (auth, ui, etc.)
3. Use TypeScript for type safety
4. Export both store and types from `index.ts`
5. Use Redux DevTools for debugging
6. Consider persistence for important user data
