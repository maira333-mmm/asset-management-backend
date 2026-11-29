import React, { useState, useEffect } from 'react';
import { useGetSettingsQuery, useUpdateSettingsMutation } from '../features/settings/settingsApi';

const AppearanceSettings = () => {
  const { data: dbSettings, isLoading } = useGetSettingsQuery();
  const [updateSettings, { isLoading: isUpdating }] = useUpdateSettingsMutation();

  const [primaryColor, setPrimaryColor] = useState('#1F3049');
  const [accentColor, setAccentColor] = useState('#C9A15B');
  const [bgColor, setBgColor] = useState('#F4F5F7');
  const [logo, setLogo] = useState(null);

  useEffect(() => {
    if (dbSettings) {
      setPrimaryColor(dbSettings.primary_color || '#1F3049');
      setAccentColor(dbSettings.accent_color || '#C9A15B');
      setBgColor(dbSettings.bg_color || '#F4F5F7');
      setLogo(dbSettings.logo_url || null);
    }
  }, [dbSettings]);

  const handleLogoUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => setLogo(reader.result);
      reader.readAsDataURL(file);
    }
  };

  const handleSave = async () => {
    try {
      // 1. Database mein save karein
      await updateSettings({ 
        primary_color: primaryColor, 
        accent_color: accentColor, 
        bg_color: bgColor, 
        logo_url: logo 
      }).unwrap();
      
      // 2. LocalStorage backup save karein
      const role = (localStorage.getItem('role') || 'admin').toLowerCase();
      localStorage.setItem(`${role}_theme_primary`, primaryColor);
      localStorage.setItem(`${role}_theme_accent`, accentColor);
      localStorage.setItem(`${role}_theme_bg`, bgColor);

      // 3. Colors foran apply karein (bina reload ke)
      document.documentElement.style.setProperty('--primary-color', primaryColor);
      document.documentElement.style.setProperty('--accent-color', accentColor);
      document.documentElement.style.setProperty('--bg-color', bgColor);

      // 🌟 4. IMAGE FORAN UPDATE KAREIN (Yeh line missing thi!)
      if (logo) {
        document.documentElement.style.setProperty('--logo-url', `url(${logo})`);
      }

      alert('Settings saved successfully!');
      
    } catch (err) {
      alert('Failed to save. Check backend.');
    }
  };

  const handleReset = async () => {
    setPrimaryColor('#1F3049');
    setAccentColor('#C9A15B');
    setBgColor('#F4F5F7');
    setLogo(null); 

    try {
      await updateSettings({ 
        primary_color: '#1F3049', 
        accent_color: '#C9A15B', 
        bg_color: '#F4F5F7', 
        logo_url: null 
      }).unwrap();

      const role = (localStorage.getItem('role') || 'admin').toLowerCase();
      localStorage.removeItem(`${role}_theme_logo`);
      localStorage.setItem(`${role}_theme_primary`, '#1F3049');
      localStorage.setItem(`${role}_theme_accent`, '#C9A15B');
      localStorage.setItem(`${role}_theme_bg`, '#F4F5F7');

      document.documentElement.style.setProperty('--primary-color', '#1F3049');
      document.documentElement.style.setProperty('--accent-color', '#C9A15B');
      document.documentElement.style.setProperty('--bg-color', '#F4F5F7');

      // 🌟 Reset par default image wapas lagayein
      document.documentElement.style.setProperty('--logo-url', `url('/pic.jpg')`);

      alert('Reset to default successful!');
    } catch (err) {
      alert('Failed to reset settings.');
    }
  };

  if (isLoading) return <div className="p-6">Loading settings...</div>;

  return (
    <div className="p-6 min-h-screen font-sans" style={{ backgroundColor: 'var(--bg-color)' }}>
      <div className="mb-8 flex justify-between items-start">
        <div>
          <p className="font-medium text-sm mb-1" style={{ color: 'var(--accent-color)' }}>Settings</p>
          <h1 className="text-4xl text-gray-800">Colour settings</h1>
          <p className="text-gray-500 mt-2 max-w-2xl">
            Pick the colours used across the app. They are saved in the database and applied as soon as you press Save.
          </p>
        </div>
        <div className="flex gap-4 mt-2">
           <button onClick={handleReset} className="text-gray-600 font-medium px-4 py-2 hover:bg-gray-200 rounded-lg transition-colors">
             Reset to default
           </button>
           <button 
             onClick={handleSave} 
             disabled={isUpdating} 
             className="text-white px-6 py-2 rounded-lg font-medium transition-opacity hover:opacity-90 disabled:opacity-50" 
             style={{ backgroundColor: primaryColor }}
           >
             {isUpdating ? 'Saving...' : 'Save colours'}
           </button>
        </div>
      </div>
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
          <h2 className="text-2xl mb-4 text-gray-800">Presets</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-8">
            <button onClick={() => {setPrimaryColor('#1F3049'); setAccentColor('#C9A15B'); setBgColor('#F4F5F7');}} className="px-4 py-3 border rounded-lg flex items-center gap-3 hover:bg-gray-50 transition-colors text-sm font-medium">
              <div className="flex gap-1">
                <span className="w-5 h-5 rounded-md bg-[#1F3049]"></span>
                <span className="w-5 h-5 rounded-md bg-[#C9A15B]"></span>
                <span className="w-5 h-5 rounded-md border border-gray-200 bg-[#F4F5F7]"></span>
              </div>
              Ledgerline navy
            </button>
            
            <button onClick={() => {setPrimaryColor('#1E3A2A'); setAccentColor('#D9A05B'); setBgColor('#F4F5F7');}} className="px-4 py-3 border rounded-lg flex items-center gap-3 hover:bg-gray-50 transition-colors text-sm font-medium">
              <div className="flex gap-1">
                <span className="w-5 h-5 rounded-md bg-[#1E3A2A]"></span>
                <span className="w-5 h-5 rounded-md bg-[#D9A05B]"></span>
                <span className="w-5 h-5 rounded-md border border-gray-200 bg-[#F4F5F7]"></span>
              </div>
              Evergreen
            </button>
          </div>

          <h2 className="text-2xl mb-4 text-gray-800">Custom colours</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="border rounded-lg p-3">
              <label className="block text-xs text-gray-500 mb-1">Primary</label>
              <div className="flex items-center gap-2">
                <input type="color" value={primaryColor} onChange={(e) => setPrimaryColor(e.target.value)} className="w-8 h-8 rounded cursor-pointer" />
                <input type="text" value={primaryColor} onChange={(e) => setPrimaryColor(e.target.value)} className="w-full text-sm outline-none" />
              </div>
            </div>
            <div className="border rounded-lg p-3">
              <label className="block text-xs text-gray-500 mb-1">Accent</label>
              <div className="flex items-center gap-2">
                <input type="color" value={accentColor} onChange={(e) => setAccentColor(e.target.value)} className="w-8 h-8 rounded cursor-pointer" />
                <input type="text" value={accentColor} onChange={(e) => setAccentColor(e.target.value)} className="w-full text-sm outline-none" />
              </div>
            </div>
            <div className="border rounded-lg p-3">
              <label className="block text-xs text-gray-500 mb-1">Page background</label>
              <div className="flex items-center gap-2">
                <input type="color" value={bgColor} onChange={(e) => setBgColor(e.target.value)} className="w-8 h-8 rounded cursor-pointer" />
                <input type="text" value={bgColor} onChange={(e) => setBgColor(e.target.value)} className="w-full text-sm outline-none" />
              </div>
            </div>
            <div className="border rounded-lg p-3">
              <label className="block text-xs text-gray-500 mb-1">Logo Upload</label>
              <input type="file" accept="image/*" onChange={handleLogoUpload} className="w-full text-sm mt-2" />
              {logo && <p className="text-green-600 text-xs mt-1">Custom logo ready!</p>}
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
          <h2 className="text-2xl mb-4 text-gray-800">Preview</h2>
          <div className="border border-gray-200 rounded-xl overflow-hidden flex h-80">
            <div className="w-1/3 flex flex-col p-4 transition-colors duration-300" style={{ backgroundColor: primaryColor }}>
              <img src={logo || '/pic.jpg'} alt="Logo" className="w-16 h-12 object-contain mb-6 bg-white/10 rounded-lg p-1" />
              <div className="h-2 bg-white/20 rounded w-full mb-3"></div>
              <div className="h-2 bg-white/20 rounded w-4/5 mb-3"></div>
              <div className="h-2 bg-white/20 rounded w-full mb-3"></div>
            </div>
            <div className="flex-1 p-6 transition-colors duration-300" style={{ backgroundColor: bgColor }}>
              <p className="text-xs font-bold mb-1" style={{ color: accentColor }}>Workspace</p>
              <h3 className="text-gray-800 text-2xl mb-4 font-serif">Asset register</h3>
              <div className="bg-white p-3 rounded shadow-sm border border-gray-100 flex justify-between items-center mb-2">
                <span className="text-sm text-gray-500">DELL-LAP-100 · Available</span>
                <button className="text-xs px-3 py-1 rounded text-white" style={{ backgroundColor: primaryColor }}>Register asset</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AppearanceSettings;