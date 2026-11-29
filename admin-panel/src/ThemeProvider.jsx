import { useEffect } from 'react';
import { useGetSettingsQuery } from './features/settings/settingsApi';

const ThemeProvider = ({ children }) => {
  const { data: settings, isSuccess } = useGetSettingsQuery();

  useEffect(() => {
    // 1. Agar Database se data aa jaye
    if (isSuccess && settings) {
      document.documentElement.style.setProperty('--primary-color', settings.primary_color || '#1F3049');
      document.documentElement.style.setProperty('--accent-color', settings.accent_color || '#C9A15B');
      document.documentElement.style.setProperty('--bg-color', settings.bg_color || '#F4F5F7');
    } else {
      // 2. Agar database slow ho, toh LocalStorage se uthao (Fallback)
      const role = (localStorage.getItem('role') || 'admin').toLowerCase();
      const localPrimary = localStorage.getItem(`${role}_theme_primary`);
      const localAccent = localStorage.getItem(`${role}_theme_accent`);
      const localBg = localStorage.getItem(`${role}_theme_bg`);

      if (localPrimary) document.documentElement.style.setProperty('--primary-color', localPrimary);
      if (localAccent) document.documentElement.style.setProperty('--accent-color', localAccent);
      if (localBg) document.documentElement.style.setProperty('--bg-color', localBg);
    }
  }, [settings, isSuccess]);

  return <>{children}</>;
};

export default ThemeProvider;