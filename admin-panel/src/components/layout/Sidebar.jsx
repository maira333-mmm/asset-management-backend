import { NavLink, useNavigate } from 'react-router-dom';

const Sidebar = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    navigate('/');
  };

  const menuItems = [
    { name: 'Dashboard', path: '/admin/dashboard' },
    { name: 'Assets', path: '/admin/assets' },
    { name: 'Employees', path: '/admin/employees' },
    { name: 'Departments', path: '/admin/departments' },
    { name: 'Vendors', path: '/admin/vendors' },
    { name: 'Categories', path: '/admin/categories' },
    { name: 'Locations', path: '/admin/locations' },
    { name: 'Appearance', path: '/admin/appearance' },
  ];

  return (
    <div 
      className="w-64 text-white min-h-screen p-4 flex flex-col shadow-lg"
      style={{ backgroundColor: 'var(--primary-color)' }}
    >
      <div className="mb-8 flex justify-center items-center h-16 border-b border-white/20 pb-4">
        {/* 🌟 Background Image CSS Variable se uthayen */}
        <div 
          className="h-full max-h-12 w-full bg-contain bg-center bg-no-repeat"
          style={{ backgroundImage: 'var(--logo-url)' }}
        ></div>
      </div>
      
      <nav className="flex flex-col gap-2 flex-1">
        {menuItems.map((item) => (
          <NavLink
            key={item.name}
            to={item.path}
            className={({ isActive }) => `px-4 py-2.5 rounded-lg text-sm font-medium transition-all ${isActive ? 'font-bold' : ''}`}
            style={({ isActive }) => ({
              backgroundColor: isActive ? 'var(--accent-color)' : 'transparent',
              color: isActive ? 'var(--primary-color)' : '#ffffff'
            })}
          >
            {item.name}
          </NavLink>
        ))}
      </nav>

      <button 
        onClick={handleLogout} 
        className="mt-4 px-4 py-2 rounded-lg font-bold transition-all hover:opacity-90"
        style={{ backgroundColor: 'var(--accent-color)', color: 'var(--primary-color)' }}
      >
        Logout
      </button>
    </div>
  );
};

export default Sidebar;