import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useGetSettingsQuery } from './features/settings/settingsApi';
import Login from './pages/Login';
import AdminLayout from './components/layout/AdminLayout';
import ProtectedRoute from './routes/ProtectedRoute';
import Dashboard from './pages/Dashboard';
import DepartmentsPage from './pages/DepartmentsPage';
import EmployeesPage from './pages/EmployeesPage';
import VendorsPage from './pages/VendorsPage';
import CategoriesPage from './pages/CategoriesPage';
import LocationsPage from './pages/LocationsPage';
import AssetsPage from './pages/AssetsPage';
import AppearanceSettings from './pages/AppearanceSettings';

// Manager Pages
import ManagerDashboard from './pages/manager/ManagerDashboard';
import ManagerAssignPage from './pages/manager/ManagerAssignPage';
import ManagerRequestsPage from './pages/manager/ManagerRequestsPage';
import ManagerReturnsPage from './pages/manager/ManagerReturnsPage'; // 🌟 Naya Import

// Employee Pages
import EmployeeDashboard from './pages/employee/EmployeeDashboard';
import EmployeeRequestsPage from './pages/employee/EmployeeRequestsPage';

export default function App() {
  const { data: settings, isSuccess } = useGetSettingsQuery();

  useEffect(() => {
    const role = (localStorage.getItem('role') || 'admin').toLowerCase();

    // 1. Load from LocalStorage instantly (No Flash)
    const localPrimary = localStorage.getItem(`${role}_theme_primary`);
    const localAccent = localStorage.getItem(`${role}_theme_accent`);
    const localBg = localStorage.getItem(`${role}_theme_bg`);

    if (localPrimary) document.documentElement.style.setProperty('--primary-color', localPrimary);
    if (localAccent) document.documentElement.style.setProperty('--accent-color', localAccent);
    if (localBg) document.documentElement.style.setProperty('--bg-color', localBg);

    // 2. Fetch from Database and update if different
    if (isSuccess && settings) {
      document.documentElement.style.setProperty('--primary-color', settings.primary_color);
      document.documentElement.style.setProperty('--accent-color', settings.accent_color);
      document.documentElement.style.setProperty('--bg-color', settings.bg_color);
      
      if (settings.logo_url) {
        document.documentElement.style.setProperty('--logo-url', `url(${settings.logo_url})`);
      } else {
        document.documentElement.style.setProperty('--logo-url', `url('/pic.jpg')`);
      }

      localStorage.setItem(`${role}_theme_primary`, settings.primary_color);
      localStorage.setItem(`${role}_theme_accent`, settings.accent_color);
      localStorage.setItem(`${role}_theme_bg`, settings.bg_color);
    }
  }, [settings, isSuccess]);

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        
        {/* ==========================================
            ADMIN ROUTES
        ========================================== */}
        <Route path="/admin" element={<ProtectedRoute><AdminLayout /></ProtectedRoute>}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="departments" element={<DepartmentsPage />} />
          <Route path="employees" element={<EmployeesPage />} />
          <Route path="vendors" element={<VendorsPage />} />
          <Route path="categories" element={<CategoriesPage />} />
          <Route path="locations" element={<LocationsPage />} />
          <Route path="assets" element={<AssetsPage />} />
          <Route path="appearance" element={<AppearanceSettings />} />
        </Route>

        {/* ==========================================
            MANAGER ROUTES
        ========================================== */}
        <Route path="/manager" element={<ProtectedRoute><ManagerDashboard /></ProtectedRoute>}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={null} />
          <Route path="assign-asset" element={<ManagerAssignPage />} />
          <Route path="requests" element={<ManagerRequestsPage />} />
          <Route path="returns" element={<ManagerReturnsPage />} /> {/* 🌟 Naya Route */}
        </Route>

        {/* ==========================================
            EMPLOYEE ROUTES
        ========================================== */}
        <Route path="/employee" element={<ProtectedRoute><EmployeeDashboard /></ProtectedRoute>}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={null} />
          <Route path="my-requests" element={<EmployeeRequestsPage />} /> 
        </Route>
      </Routes>
    </BrowserRouter>
  );
}