import React, { useState } from 'react';
import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useGetMyAssetsQuery } from '../../features/assignments/assignmentsApi';
import { useCreateRequestMutation } from '../../features/requests/requestsApi';
import { useGetCategoriesQuery } from '../../features/categories/categoriesApi';
import { useGetEmployeesQuery } from '../../features/employees/employeesApi';
import { useGetDepartmentsQuery } from '../../features/departments/departmentsApi';
import { useCreateReturnRequestMutation } from '../../features/returns/returnsApi';

const EmployeeDashboard = () => {
  const navigate = useNavigate();
  const location = useLocation();
  
  const { data: myAssets, isLoading: assetsLoading } = useGetMyAssetsQuery();
  const { data: categories } = useGetCategoriesQuery();
  const { data: allEmployees } = useGetEmployeesQuery();
  const { data: departments } = useGetDepartmentsQuery();
  
  const [createRequest, { isLoading: isRequesting }] = useCreateRequestMutation();
  const [createReturn, { isLoading: isReturning }] = useCreateReturnRequestMutation();

  const [requestData, setRequestData] = useState({ category_id: '', reason: '' });
  const [showRequestForm, setShowRequestForm] = useState(false);

  // Return Modal States
  const [showReturnModal, setShowReturnModal] = useState(false);
  const [selectedAssetId, setSelectedAssetId] = useState(null);
  const [returnData, setReturnData] = useState({ condition: 'Good', reason: '' });

  const employeeId = localStorage.getItem('employee_id');
  const myProfile = allEmployees?.find(emp => emp.employee_id === employeeId);
  const myDepartment = departments?.find(dept => dept.department_id === myProfile?.department_id);

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    localStorage.removeItem('employee_id');
    localStorage.removeItem('department_id');
    localStorage.removeItem('manager_id');
    navigate('/');
  };

  const handleRequestSubmit = async (e) => {
    e.preventDefault();
    try {
      await createRequest(requestData).unwrap();
      alert('Request submitted successfully!');
      setRequestData({ category_id: '', reason: '' });
      setShowRequestForm(false);
    } catch (err) {
      alert(err?.data?.error || 'Failed to submit request');
    }
  };

  const openReturnModal = (assetId) => {
    setSelectedAssetId(assetId);
    setReturnData({ condition: 'Good', reason: '' });
    setShowReturnModal(true);
  };

  const handleReturnSubmit = async (e) => {
    e.preventDefault();
    try {
      await createReturn({ 
        asset_id: selectedAssetId, 
        condition: returnData.condition, 
        reason: returnData.reason 
      }).unwrap();
      alert('Return request sent to manager!');
      setShowReturnModal(false);
    } catch (err) {
      alert(err?.data?.error || 'Failed to send return request');
    }
  };

  const isMainDashboard = location.pathname === '/employee/dashboard' || location.pathname === '/employee';
  const isMyRequests = location.pathname === '/employee/my-requests';

  return (
    <div className="flex min-h-screen transition-colors duration-300" style={{ backgroundColor: 'var(--bg-color)' }}>
      
      {/* Sidebar */}
      <div className="w-64 text-white p-4 flex flex-col shadow-lg" style={{ backgroundColor: 'var(--primary-color)' }}>
        <div className="mb-8 flex justify-center items-center h-16 border-b border-white/20 pb-4">
          <div className="h-full max-h-12 w-full bg-contain bg-center bg-no-repeat" style={{ backgroundImage: 'var(--logo-url)' }}></div>
        </div>
        
        <nav className="flex flex-col gap-2 flex-1">
          <Link to="/employee/dashboard" className={`p-3 rounded-lg text-sm font-medium transition-all ${isMainDashboard ? 'font-bold' : ''}`} style={{ backgroundColor: isMainDashboard ? 'var(--accent-color)' : 'transparent', color: isMainDashboard ? 'var(--primary-color)' : '#ffffff' }}>
            My Dashboard
          </Link>
          <Link to="/employee/my-requests" className={`p-3 rounded-lg text-sm font-medium transition-all ${isMyRequests ? 'font-bold' : ''}`} style={{ backgroundColor: isMyRequests ? 'var(--accent-color)' : 'transparent', color: isMyRequests ? 'var(--primary-color)' : '#ffffff' }}>
            My Requests
          </Link>
        </nav>
        
        <button onClick={handleLogout} className="mt-auto px-4 py-2 rounded-lg font-bold transition-all hover:opacity-90" style={{ backgroundColor: 'var(--accent-color)', color: 'var(--primary-color)' }}>
          Logout
        </button>
      </div>

      {/* Main Content */}
      <div className="flex-1 p-6">
        {isMainDashboard ? (
          <>
            <h1 className="text-2xl font-bold text-gray-800 mb-6">Welcome, {myProfile?.name || 'Employee'}</h1>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
              <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                <p className="text-gray-500 font-medium mb-1 text-sm">My Department</p>
                <h3 className="text-xl font-bold" style={{ color: 'var(--primary-color)' }}>{myDepartment?.department_name || 'Not Assigned'}</h3>
              </div>
              <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                <p className="text-gray-500 font-medium mb-1 text-sm">My Manager</p>
                <h3 className="text-xl font-bold" style={{ color: 'var(--primary-color)' }}>{myProfile?.manager_name || 'No Manager Assigned'}</h3>
                {myProfile?.manager_designation && <p className="text-xs text-gray-400 mt-1">{myProfile.manager_designation}</p>}
              </div>
              <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center justify-between">
                <div>
                  <p className="text-gray-500 font-medium mb-1 text-sm">My Assets</p>
                  <h3 className="text-3xl font-bold" style={{ color: 'var(--primary-color)' }}>{assetsLoading ? '...' : myAssets?.length || 0}</h3>
                </div>
                <div className="w-12 h-12 rounded-full flex items-center justify-center shadow-sm" style={{ backgroundColor: 'var(--accent-color)', color: 'var(--primary-color)' }}>
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-6 h-6">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z" />
                  </svg>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 mb-8 flex justify-between items-center">
              <div>
                <h2 className="text-lg font-bold text-gray-800">Need a new asset?</h2>
                <p className="text-sm text-gray-500">Send a request to your manager.</p>
              </div>
              <button onClick={() => setShowRequestForm(!showRequestForm)} className="text-white px-6 py-2 rounded-lg font-bold transition-all hover:opacity-90" style={{ backgroundColor: 'var(--primary-color)' }}>
                {showRequestForm ? 'Close Form' : '+ Request New Asset'}
              </button>
            </div>

            {showRequestForm && (
              <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
                <h2 className="text-xl font-bold mb-4 text-gray-800">Request an Asset</h2>
                <form onSubmit={handleRequestSubmit} className="flex flex-col md:flex-row gap-4 items-end">
                  <div className="flex-1 w-full">
                    <label className="block text-sm font-semibold mb-2">Asset Category</label>
                    <select required value={requestData.category_id} onChange={(e) => setRequestData({...requestData, category_id: e.target.value})} className="w-full p-2 border rounded-lg">
                      <option value="">-- Select Category --</option>
                      {categories?.map(cat => <option key={cat.category_id} value={cat.category_id}>{cat.category_name}</option>)}
                    </select>
                  </div>
                  <div className="flex-1 w-full">
                    <label className="block text-sm font-semibold mb-2">Reason</label>
                    <input type="text" required placeholder="Why?" value={requestData.reason} onChange={(e) => setRequestData({...requestData, reason: e.target.value})} className="w-full p-2 border rounded-lg" />
                  </div>
                  <button type="submit" disabled={isRequesting} className="text-white px-6 py-2 rounded-lg font-bold transition-all hover:opacity-90" style={{ backgroundColor: 'var(--primary-color)' }}>
                    {isRequesting ? 'Sending...' : 'Send Request'}
                  </button>
                </form>
              </div>
            )}

            <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
              <h2 className="text-lg font-bold text-gray-700 mb-4">My Assigned Assets</h2>
              <table className="w-full text-left border-collapse">
                <thead className="bg-gray-50 border-b">
                  <tr>
                    <th className="p-4 font-semibold text-gray-600">Asset</th>
                    <th className="p-4 font-semibold text-gray-600">Serial No</th>
                    <th className="p-4 font-semibold text-gray-600">Assigned On</th>
                    <th className="p-4 font-semibold text-gray-600">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {assetsLoading ? (
                    <tr><td colSpan="4" className="p-4 text-center">Loading assets...</td></tr>
                  ) : myAssets?.length === 0 ? (
                    <tr><td colSpan="4" className="p-8 text-center text-gray-500">No assets assigned yet.</td></tr>
                  ) : (
                    myAssets?.map(asset => (
                      <tr key={asset.assignment_id} className="border-b hover:bg-gray-50">
                        <td className="p-4">
                          <div className="font-bold text-gray-800">{asset.category_name || 'Asset'}</div>
                          <div className="text-xs text-gray-500">{asset.asset_tag}</div>
                        </td>
                        <td className="p-4 text-gray-600">{asset.serial_number || 'N/A'}</td>
                        <td className="p-4 text-gray-600">{asset.assigned_on ? new Date(asset.assigned_on).toLocaleDateString() : '-'}</td>
                        <td className="p-4 flex items-center gap-3">
                          <span className="px-2 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">Active</span>
                          {/* 🌟 RETURN BUTTON */}
                          <button onClick={() => openReturnModal(asset.asset_id)} className="text-red-600 text-sm font-semibold hover:underline">
                            Return
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </>
        ) : (
          <Outlet />
        )}
      </div>

      {/* 🌟 RETURN MODAL */}
      {showReturnModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-full max-w-md">
            <h2 className="text-xl font-bold mb-4">Return Asset</h2>
            <form onSubmit={handleReturnSubmit}>
              <label className="block text-sm font-semibold mb-2">Asset Condition</label>
              <select value={returnData.condition} onChange={(e) => setReturnData({...returnData, condition: e.target.value})} className="w-full p-2 border rounded-lg mb-4">
                <option value="Good">Good</option>
                <option value="Damaged">Damaged</option>
                <option value="Needs Repair">Needs Repair</option>
              </select>
              <label className="block text-sm font-semibold mb-2">Reason for Return</label>
              <textarea required value={returnData.reason} onChange={(e) => setReturnData({...returnData, reason: e.target.value})} className="w-full p-2 border rounded-lg mb-4 h-20" placeholder="Why are you returning this?"></textarea>
              <div className="flex justify-end gap-3">
                <button type="button" onClick={() => setShowReturnModal(false)} className="px-4 py-2 border rounded-lg">Cancel</button>
                <button type="submit" disabled={isReturning} className="px-4 py-2 bg-red-600 text-white rounded-lg font-bold disabled:opacity-50">
                  {isReturning ? 'Sending...' : 'Confirm Return'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default EmployeeDashboard;