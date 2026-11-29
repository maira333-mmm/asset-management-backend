import React, { useState } from 'react';
import { useGetPendingReturnsQuery, useUpdateReturnStatusMutation } from '../../features/returns/returnsApi';

const ManagerReturnsPage = () => {
  const { data: pendingReturns, isLoading } = useGetPendingReturnsQuery();
  const [updateStatus, { isLoading: isUpdating }] = useUpdateReturnStatusMutation();

  // Modal States
  const [showAcceptModal, setShowAcceptModal] = useState(false);
  const [selectedReturn, setSelectedReturn] = useState(null);
  const [actionType, setActionType] = useState('Available');
  const [comment, setComment] = useState('');

  const openAcceptModal = (returnItem) => {
    setSelectedReturn(returnItem);
    
    // Auto-select logic based on condition
    if (returnItem.condition === 'Damaged') {
      setActionType('Under Maintenance');
    } else if (returnItem.condition === 'Needs Repair') {
      setActionType('Under Maintenance');
    } else {
      setActionType('Available');
    }
    
    setComment('');
    setShowAcceptModal(true);
  };

  const handleAcceptSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateStatus({ 
        id: selectedReturn.return_id, 
        data: { 
          status: 'Approved', 
          manager_action: actionType, 
          manager_comment: comment 
        } 
      }).unwrap();
      alert(`Return Accepted! Asset is now ${actionType}.`);
      setShowAcceptModal(false);
    } catch (err) {
      alert(err?.data?.error || 'Failed to update');
    }
  };

  const handleReject = async (id) => {
    if (window.confirm("Are you sure you want to Reject this return? The asset will remain with the employee.")) {
      try {
        await updateStatus({ id, data: { status: 'Rejected', manager_comment: 'Return rejected by manager' } }).unwrap();
        alert('Return Rejected!');
      } catch (err) {
        alert(err?.data?.error || 'Failed to update');
      }
    }
  };

  return (
    <div className="p-6 relative">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">Return Requests</h1>
      
      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Employee</th>
              <th className="p-4 font-semibold text-gray-600">Asset</th>
              <th className="p-4 font-semibold text-gray-600">Condition</th>
              <th className="p-4 font-semibold text-gray-600">Employee Reason</th>
              <th className="p-4 font-semibold text-gray-600">Actions</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="5" className="p-4 text-center">Loading...</td></tr>
            ) : pendingReturns?.length === 0 ? (
              <tr><td colSpan="5" className="p-6 text-center text-gray-500">No pending return requests.</td></tr>
            ) : (
              pendingReturns?.map(ret => (
                <tr key={ret.return_id} className="border-b hover:bg-gray-50 transition-colors">
                  <td className="p-4 font-medium text-gray-800">{ret.employee_name}</td>
                  <td className="p-4">{ret.category_name} - {ret.asset_tag}</td>
                  <td className="p-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-bold ${ret.condition === 'Good' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                      {ret.condition}
                    </span>
                  </td>
                  <td className="p-4 text-gray-600">{ret.reason || '-'}</td>
                  <td className="p-4">
                    <button onClick={() => openAcceptModal(ret)} disabled={isUpdating} className="bg-green-600 text-white px-3 py-1 rounded mr-2 hover:bg-green-700 disabled:opacity-50">Accept</button>
                    <button onClick={() => handleReject(ret.return_id)} disabled={isUpdating} className="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 disabled:opacity-50">Reject</button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* 🌟 ACCEPT MODAL (With Maintenance & Retired Option) */}
      {showAcceptModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-full max-w-md">
            <h2 className="text-xl font-bold mb-4 text-gray-800">Accept Return</h2>
            <form onSubmit={handleAcceptSubmit}>
              
              <label className="block text-sm font-semibold mb-2">Asset Next Status</label>
              <select 
                value={actionType}
                onChange={(e) => setActionType(e.target.value)}
                className="w-full p-2 border rounded-lg mb-4 focus:outline-none focus:ring-2 focus:ring-green-400"
              >
                <option value="Available">Return to Inventory (Available)</option>
                <option value="Under Maintenance">Send to Maintenance (Damaged / Needs Repair)</option>
                <option value="Retired">Retire Asset (Completely Broken / End of Life)</option>
              </select>

              <label className="block text-sm font-semibold mb-2">Manager's Note (Optional)</label>
              <textarea 
                value={comment}
                onChange={(e) => setComment(e.target.value)}
                className="w-full p-2 border rounded-lg mb-4 h-20"
                placeholder="e.g., Screen is broken, need replacement..."
              ></textarea>

              <div className="flex justify-end gap-3">
                <button type="button" onClick={() => setShowAcceptModal(false)} className="px-4 py-2 border rounded-lg hover:bg-gray-100">Cancel</button>
                <button type="submit" disabled={isUpdating} className="px-4 py-2 bg-green-600 text-white rounded-lg font-bold hover:bg-green-700 disabled:opacity-50">
                  {isUpdating ? 'Processing...' : 'Confirm Accept'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default ManagerReturnsPage;