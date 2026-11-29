import React, { useState } from 'react';
import { 
  useGetAvailableAssetsQuery, 
  useAssignAssetMutation, 
  useGetMyAssignmentsQuery 
} from '../../features/assignments/assignmentsApi';
import { useGetEmployeesQuery } from '../../features/employees/employeesApi';
import { useGetCategoriesQuery } from '../../features/categories/categoriesApi';

const ManagerAssignPage = () => {
  const { data: employees } = useGetEmployeesQuery(); 
  const { data: availableAssets, isLoading: assetsLoading } = useGetAvailableAssetsQuery();
  const { data: categories } = useGetCategoriesQuery();
  const { data: myAssignments, isLoading: historyLoading } = useGetMyAssignmentsQuery();
  
  const [assignAsset, { isLoading: isAssigning }] = useAssignAssetMutation();
  const [formData, setFormData] = useState({ employee_id: '', asset_id: '' });

  const handleAssign = async (e) => {
    e.preventDefault();
    try {
      await assignAsset(formData).unwrap();
      alert('Asset assigned successfully!');
      setFormData({ employee_id: '', asset_id: '' }); 
    } catch (err) {
      alert(err?.data?.error || 'Failed to assign asset');
    }
  };

  return (
    <div className="p-6">
      
      {/* Assign Asset Form */}
      <div className="bg-white p-6 rounded-xl shadow-md max-w-2xl mb-8 border border-gray-100">
        <h1 className="text-2xl font-bold mb-6 text-gray-800">Assign Asset to Team Member</h1>
        <form onSubmit={handleAssign} className="flex flex-col gap-4">
          <div>
            <label className="block text-sm font-semibold mb-2">Select Employee</label>
            <select required value={formData.employee_id} onChange={(e) => setFormData({...formData, employee_id: e.target.value})} className="w-full p-2 border rounded-lg">
              <option value="">-- Choose Employee --</option>
              {employees?.map(emp => <option key={emp.employee_id} value={emp.employee_id}>{emp.name} ({emp.designation})</option>)}
            </select>
          </div>
          <div>
            <label className="block text-sm font-semibold mb-2">Select Available Asset</label>
            <select required value={formData.asset_id} onChange={(e) => setFormData({...formData, asset_id: e.target.value})} className="w-full p-2 border rounded-lg">
              <option value="">-- Choose Asset --</option>
              {assetsLoading ? <option>Loading...</option> : availableAssets?.length === 0 ? <option disabled>No assets available</option> : (
                availableAssets?.map(asset => {
                  const catName = categories?.find(c => c.category_id === asset.category_id)?.category_name || 'Unknown';
                  return <option key={asset.asset_id} value={asset.asset_id}>{catName} - {asset.asset_tag}</option>;
                })
              )}
            </select>
          </div>
          <button type="submit" disabled={isAssigning} className="text-white p-3 rounded-lg font-bold mt-2 transition-all hover:opacity-90" style={{ backgroundColor: 'var(--primary-color)' }}>
            {isAssigning ? 'Assigning...' : 'Assign Asset'}
          </button>
        </form>
      </div>

      {/* 🌟 MY ASSIGNMENT HISTORY */}
      <div className="bg-white p-6 rounded-xl shadow-md border border-gray-100">
        <h2 className="text-xl font-bold text-gray-800 mb-4">My Assignment History</h2>
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Asset</th>
              <th className="p-4 font-semibold text-gray-600">Assigned To</th>
              <th className="p-4 font-semibold text-gray-600">Date</th>
              <th className="p-4 font-semibold text-gray-600">Status</th>
            </tr>
          </thead>
          <tbody>
            {historyLoading ? (
              <tr><td colSpan="4" className="p-4 text-center">Loading history...</td></tr>
            ) : myAssignments?.length === 0 ? (
              <tr><td colSpan="4" className="p-4 text-center text-gray-500">No assignments yet.</td></tr>
            ) : (
              myAssignments?.map(assign => (
                <tr key={assign.assignment_id} className="border-b hover:bg-gray-50">
                  <td className="p-4">
                    <div className="font-bold text-gray-800">{assign.category_name || 'Asset'}</div>
                    <div className="text-xs text-gray-500">{assign.asset_tag} (SN: {assign.serial_number})</div>
                  </td>
                  <td className="p-4 text-gray-600 font-medium">{assign.employee_name}</td>
                  <td className="p-4 text-gray-600">{assign.assigned_on ? new Date(assign.assigned_on).toLocaleDateString() : '-'}</td>
                  <td className="p-4"><span className="px-2 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-700">Active</span></td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ManagerAssignPage;