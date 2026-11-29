import React from 'react';
import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useGetEmployeesQuery } from '../../features/employees/employeesApi';
import { useGetDepartmentsQuery } from '../../features/departments/departmentsApi';
import { useGetMyAssignmentsQuery } from '../../features/assignments/assignmentsApi';
import { useGetSettingsQuery } from '../../features/settings/settingsApi';

const ManagerDashboard = () => {
  const navigate = useNavigate();
  const location = useLocation();
  
  const { data: employees, isLoading: isTeamLoading } = useGetEmployeesQuery();
  const { data: departments } = useGetDepartmentsQuery();
  const { data: myAssignments, isLoading: isAssignmentsLoading } = useGetMyAssignmentsQuery();
  
  const { data: settings } = useGetSettingsQuery(); 
  const savedLogo = settings?.logo_url;

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    navigate('/');
  };

  const myTeam = employees || [];
  const totalAssigned = myAssignments?.length || 0;
  const isMainDashboard = location.pathname === '/manager/dashboard' || location.pathname === '/manager';

  return (
    <div className="flex min-h-screen transition-colors duration-300" style={{ backgroundColor: 'var(--bg-color)' }}>
      
      <div className="w-64 text-white p-4 flex flex-col shadow-lg" style={{ backgroundColor: 'var(--primary-color)' }}>
        <div className="mb-8 flex justify-center items-center h-16 border-b border-white/20 pb-4">
          {/* 🌟 Logo Variable se uthayen */}
          <div 
            className="h-full max-h-12 w-full bg-contain bg-center bg-no-repeat"
            style={{ backgroundImage: 'var(--logo-url)' }}
          ></div>
        </div>
        
        <nav className="flex flex-col gap-2 flex-1">
          <Link 
            to="/manager/dashboard" 
            className={`p-3 rounded-lg text-sm font-medium transition-all ${isMainDashboard ? 'font-bold' : ''}`}
            style={{ backgroundColor: isMainDashboard ? 'var(--accent-color)' : 'transparent', color: isMainDashboard ? 'var(--primary-color)' : '#ffffff' }}
          >
            My Team
          </Link>
          <Link 
            to="/manager/assign-asset" 
            className={`p-3 rounded-lg text-sm font-medium transition-all ${location.pathname === '/manager/assign-asset' ? 'font-bold' : ''}`}
            style={{ backgroundColor: location.pathname === '/manager/assign-asset' ? 'var(--accent-color)' : 'transparent', color: location.pathname === '/manager/assign-asset' ? 'var(--primary-color)' : '#ffffff' }}
          >
            Assign Asset
          </Link>
          <Link 
            to="/manager/requests" 
            className={`p-3 rounded-lg text-sm font-medium transition-all ${location.pathname === '/manager/requests' ? 'font-bold' : ''}`}
            style={{ backgroundColor: location.pathname === '/manager/requests' ? 'var(--accent-color)' : 'transparent', color: location.pathname === '/manager/requests' ? 'var(--primary-color)' : '#ffffff' }}
          >
            Team Requests
          </Link>
          
          {/* 🌟 NAYA LINK: Return Requests */}
          <Link 
            to="/manager/returns" 
            className={`p-3 rounded-lg text-sm font-medium transition-all ${location.pathname === '/manager/returns' ? 'font-bold' : ''}`}
            style={{ backgroundColor: location.pathname === '/manager/returns' ? 'var(--accent-color)' : 'transparent', color: location.pathname === '/manager/returns' ? 'var(--primary-color)' : '#ffffff' }}
          >
            Return Requests
          </Link>

        </nav>
        
        <button onClick={handleLogout} className="mt-auto px-4 py-2 rounded-lg font-bold hover:opacity-90 transition-opacity" style={{ backgroundColor: 'var(--accent-color)', color: 'var(--primary-color)' }}>
          Logout
        </button>
      </div>

      <div className="flex-1 p-6">
        {isMainDashboard ? (
          <>
            <h1 className="text-2xl font-bold text-gray-800 mb-6">Manager Dashboard</h1>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
                <div>
                  <p className="text-gray-500 font-medium mb-1">Total Team Members</p>
                  <h3 className="text-3xl font-bold" style={{ color: 'var(--primary-color)' }}>{isTeamLoading ? '...' : myTeam.length}</h3>
                </div>
              </div>
              <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
                <div>
                  <p className="text-gray-500 font-medium mb-1">Assets Assigned by Me</p>
                  <h3 className="text-3xl font-bold" style={{ color: 'var(--primary-color)' }}>{isAssignmentsLoading ? '...' : totalAssigned}</h3>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
              <h2 className="text-lg font-bold text-gray-700 mb-4">My Team</h2>
              <table className="w-full text-left border-collapse">
                <thead className="bg-gray-50 border-b">
                  <tr>
                    <th className="p-4 font-semibold text-gray-600">Employee Name</th>
                    <th className="p-4 font-semibold text-gray-600">Department</th>
                    <th className="p-4 font-semibold text-gray-600">Designation</th>
                  </tr>
                </thead>
                <tbody>
                  {myTeam.map(emp => (
                      <tr key={emp.employee_id} className="border-b hover:bg-gray-50 transition-colors">
                        <td className="p-4 font-medium text-gray-800">{emp.name}</td>
                        <td className="p-4 text-gray-600">{departments?.find(d => d.department_id === emp.department_id)?.department_name || 'N/A'}</td>
                        <td className="p-4 text-gray-600">{emp.designation || '-'}</td>
                      </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        ) : (
          <Outlet />
        )}
      </div>
    </div>
  );
};

export default ManagerDashboard;