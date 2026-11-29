import React, { useState } from 'react';
import { 
  useGetPendingRequestsQuery, 
  useUpdateRequestStatusMutation,
  useGetManagerRequestHistoryQuery 
} from '../../features/requests/requestsApi';
import { useGetAvailableAssetsQuery } from '../../features/assignments/assignmentsApi';
import { useGetCategoriesQuery } from '../../features/categories/categoriesApi';

const ManagerRequestsPage = () => {
  const { data: pendingRequests, isLoading: isPendingLoading } = useGetPendingRequestsQuery();
  const { data: history, isLoading: isHistoryLoading } = useGetManagerRequestHistoryQuery();
  const { data: availableAssets } = useGetAvailableAssetsQuery();
  const { data: categories } = useGetCategoriesQuery();
  
  const [updateStatus, { isLoading: isUpdating }] = useUpdateRequestStatusMutation();

  // Approve Modal States
  const [showApproveModal, setShowApproveModal] = useState(false);
  const [selectedApproveId, setSelectedApproveId] = useState(null);
  const [selectedAssetId, setSelectedAssetId] = useState('');

  // Reject Modal States
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [selectedRejectId, setSelectedRejectId] = useState(null);
  const [rejectReason, setRejectReason] = useState('');

  const openApproveModal = (id) => {
    setSelectedApproveId(id);
    setSelectedAssetId('');
    setShowApproveModal(true);
  };

  const handleApproveSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateStatus({ 
        id: selectedApproveId, 
        data: { status: 'Approved', asset_id: selectedAssetId, manager_comment: 'Request Approved' } 
      }).unwrap();
      alert('Request Approved and Asset Assigned!');
      setShowApproveModal(false);
    } catch (err) {
      alert(err?.data?.error || 'Failed to approve');
    }
  };

  const openRejectModal = (id) => {
    setSelectedRejectId(id);
    setRejectReason('');
    setShowRejectModal(true);
  };

  const handleRejectSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateStatus({ 
        id: selectedRejectId, 
        data: { status: 'Rejected', manager_comment: rejectReason } 
      }).unwrap();
      alert('Request Rejected!');
      setShowRejectModal(false);
    } catch (err) {
      alert(err?.data?.error || 'Failed to reject');
    }
  };

  const getStatusColor = (status) => {
    if (status === 'Approved') return 'bg-green-100 text-green-700';
    if (status === 'Rejected') return 'bg-red-100 text-red-700';
    return 'bg-yellow-100 text-yellow-700';
  };

  return (
    <div className="p-6 relative">
      <h1 className="text-2xl font-bold mb-6 text-gray-800">Team Asset Requests</h1>
      
      {/* 🌟 PENDING REQUESTS TABLE */}
      <div className="bg-white rounded-xl shadow-md overflow-hidden mb-8 border border-gray-100">
        <div className="p-4 bg-gray-50 border-b">
          <h2 className="font-bold text-gray-700">Pending Requests</h2>
        </div>
        <table className="w-full text-left">
          <thead className="bg-white border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Employee</th>
              <th className="p-4 font-semibold text-gray-600">Category</th>
              <th className="p-4 font-semibold text-gray-600">Reason</th>
              <th className="p-4 font-semibold text-gray-600">Actions</th>
            </tr>
          </thead>
          <tbody>
            {isPendingLoading ? (
              <tr><td colSpan="4" className="p-4 text-center">Loading...</td></tr>
            ) : pendingRequests?.length === 0 ? (
              <tr><td colSpan="4" className="p-6 text-center text-gray-500">No pending requests.</td></tr>
            ) : (
              pendingRequests?.map(req => (
                <tr key={req.request_id} className="border-b hover:bg-gray-50">
                  <td className="p-4">{req.employee_name}</td>
                  <td className="p-4">{req.category_name}</td>
                  <td className="p-4">{req.reason || '-'}</td>
                  <td className="p-4">
                    <button onClick={() => openApproveModal(req.request_id)} className="bg-green-600 text-white px-3 py-1 rounded mr-2 hover:bg-green-700">Approve</button>
                    <button onClick={() => openRejectModal(req.request_id)} className="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700">Reject</button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* 🌟 REQUEST HISTORY TABLE */}
      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <div className="p-4 bg-gray-50 border-b">
          <h2 className="font-bold text-gray-700">Request History (Approved / Rejected)</h2>
        </div>
        <table className="w-full text-left">
          <thead className="bg-white border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Employee</th>
              <th className="p-4 font-semibold text-gray-600">Category</th>
              <th className="p-4 font-semibold text-gray-600">Status</th>
              <th className="p-4 font-semibold text-gray-600">Manager's Comment</th>
            </tr>
          </thead>
          <tbody>
            {isHistoryLoading ? (
              <tr><td colSpan="4" className="p-4 text-center">Loading history...</td></tr>
            ) : history?.length === 0 ? (
              <tr><td colSpan="4" className="p-6 text-center text-gray-500">No history found.</td></tr>
            ) : (
              history?.map(req => (
                <tr key={req.request_id} className="border-b hover:bg-gray-50">
                  <td className="p-4 font-medium text-gray-800">{req.employee_name}</td>
                  <td className="p-4 text-gray-600">{req.category_name}</td>
                  <td className="p-4">
                    <span className={`px-2 py-1 rounded-full text-xs font-bold ${getStatusColor(req.status)}`}>
                      {req.status}
                    </span>
                  </td>
                  <td className="p-4 text-sm text-gray-500 italic">
                    {req.manager_comment ? `"${req.manager_comment}"` : '-'}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* APPROVE MODAL */}
      {showApproveModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-full max-w-md">
            <h2 className="text-xl font-bold mb-4 text-gray-800">Approve Request & Assign Asset</h2>
            <form onSubmit={handleApproveSubmit}>
              <label className="block text-sm font-semibold mb-2">Select Available Asset</label>
              <select 
                required
                value={selectedAssetId}
                onChange={(e) => setSelectedAssetId(e.target.value)}
                className="w-full p-2 border rounded-lg mb-4 focus:outline-none focus:ring-2 focus:ring-green-400"
              >
                <option value="">-- Choose Asset --</option>
                {availableAssets?.map(asset => {
                  const catName = categories?.find(c => c.category_id === asset.category_id)?.category_name || 'Unknown';
                  return <option key={asset.asset_id} value={asset.asset_id}>{catName} - {asset.asset_tag}</option>;
                })}
              </select>
              <div className="flex justify-end gap-3">
                <button type="button" onClick={() => setShowApproveModal(false)} className="px-4 py-2 text-gray-600 border rounded-lg hover:bg-gray-100">Cancel</button>
                <button type="submit" disabled={isUpdating} className="px-4 py-2 bg-green-600 text-white rounded-lg font-bold hover:bg-green-700 disabled:opacity-50">
                  {isUpdating ? 'Approving...' : 'Approve & Assign'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* REJECT MODAL */}
      {showRejectModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-full max-w-md">
            <h2 className="text-xl font-bold mb-4 text-gray-800">Reject Request</h2>
            <form onSubmit={handleRejectSubmit}>
              <label className="block text-sm font-semibold mb-2">Reason for Rejection</label>
              <textarea 
                required
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
                className="w-full p-2 border rounded-lg mb-4 h-24 focus:outline-none focus:ring-2 focus:ring-red-400"
                placeholder="Why are you rejecting this request?"
              ></textarea>
              <div className="flex justify-end gap-3">
                <button type="button" onClick={() => setShowRejectModal(false)} className="px-4 py-2 text-gray-600 border rounded-lg hover:bg-gray-100">Cancel</button>
                <button type="submit" disabled={isUpdating} className="px-4 py-2 bg-red-600 text-white rounded-lg font-bold hover:bg-red-700 disabled:opacity-50">
                  {isUpdating ? 'Rejecting...' : 'Confirm Reject'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default ManagerRequestsPage;