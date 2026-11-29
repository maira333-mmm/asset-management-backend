import React from 'react';
import { Link } from 'react-router-dom';
import { useGetEmployeesQuery } from '../features/employees/employeesApi';
import { useGetAssetsQuery } from '../features/assets/assetsApi';
import { useGetDepartmentsQuery } from '../features/departments/departmentsApi';
import { useGetVendorsQuery } from '../features/vendors/vendorsApi';

const Dashboard = () => {
  const { data: employees } = useGetEmployeesQuery();
  const { data: assets } = useGetAssetsQuery();
  const { data: departments } = useGetDepartmentsQuery();
  const { data: vendors } = useGetVendorsQuery();

  const totalUsers = employees?.length || 0;
  const totalManagers = employees?.filter(emp => emp.designation?.toLowerCase().includes('manager')).length || 0;
  const totalEmployees = totalUsers - totalManagers;
  const totalAssets = assets?.length || 0;
  const totalVendors = vendors?.length || 0;
  const totalDepartments = departments?.length || 0;

  return (
    <div className="p-6 min-h-screen" style={{ backgroundColor: 'var(--bg-color)' }}>
      <h1 className="text-2xl font-bold text-gray-800 mb-6">System Overview</h1>
      
      {/* Top Analytics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        
        <div className="bg-white p-6 rounded-xl shadow-sm flex flex-col justify-center border-l-4" style={{ borderColor: 'var(--primary-color)' }}>
          <span className="text-sm font-semibold text-gray-500 uppercase tracking-wider">Total Users</span>
          <span className="text-4xl font-bold mt-2" style={{ color: 'var(--primary-color)' }}>{totalUsers}</span>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border-l-4 border-blue-500 flex flex-col justify-center">
          <span className="text-sm font-semibold text-gray-500 uppercase tracking-wider">Managers</span>
          <span className="text-4xl font-bold text-blue-600 mt-2">{totalManagers}</span>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border-l-4 border-green-500 flex flex-col justify-center">
          <span className="text-sm font-semibold text-gray-500 uppercase tracking-wider">Employees</span>
          <span className="text-4xl font-bold text-green-600 mt-2">{totalEmployees}</span>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border-l-4 border-orange-500 flex flex-col justify-center">
          <span className="text-sm font-semibold text-gray-500 uppercase tracking-wider">Total Assets</span>
          <span className="text-4xl font-bold text-orange-600 mt-2">{totalAssets}</span>
        </div>
      </div>

      {/* Second Row Analytics */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <span className="text-sm font-semibold text-gray-500">Registered Vendors</span>
            <span className="block text-3xl font-bold text-gray-800 mt-1">{totalVendors}</span>
          </div>
          <Link to="/admin/vendors" className="text-sm font-bold hover:underline" style={{ color: 'var(--primary-color)' }}>View All →</Link>
        </div>
        
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
          <div>
            <span className="text-sm font-semibold text-gray-500">Active Departments</span>
            <span className="block text-3xl font-bold text-gray-800 mt-1">{totalDepartments}</span>
          </div>
          <Link to="/admin/departments" className="text-sm font-bold hover:underline" style={{ color: 'var(--primary-color)' }}>View All →</Link>
        </div>
      </div>

      {/* Quick Actions */}
      <h2 className="text-lg font-bold text-gray-800 mb-4 mt-10">Quick Actions</h2>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Link to="/admin/employees" className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 text-center transition-all hover:shadow-md group">
          <span className="block font-bold text-gray-700 group-hover:opacity-80">Add Employee</span>
        </Link>
        <Link to="/admin/assets" className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 text-center transition-all hover:shadow-md group">
          <span className="block font-bold text-gray-700 group-hover:opacity-80">Add Asset</span>
        </Link>
        <Link to="/admin/vendors" className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 text-center transition-all hover:shadow-md group">
          <span className="block font-bold text-gray-700 group-hover:opacity-80">Add Vendor</span>
        </Link>
        <Link to="/admin/categories" className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 text-center transition-all hover:shadow-md group">
          <span className="block font-bold text-gray-700 group-hover:opacity-80">Add Category</span>
        </Link>
      </div>
    </div>
  );
};

export default Dashboard;