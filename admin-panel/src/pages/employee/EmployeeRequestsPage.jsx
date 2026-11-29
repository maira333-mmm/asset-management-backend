import React from 'react';
import { useGetMyRequestsQuery } from '../../features/requests/requestsApi';

const EmployeeRequestsPage = () => {
  const { data: myRequests, isLoading } = useGetMyRequestsQuery();

  const getStatusColor = (status) => {
    if (status === 'Approved') return 'bg-green-100 text-green-700 border border-green-200';
    if (status === 'Rejected') return 'bg-red-100 text-red-700 border border-red-200';
    return 'bg-yellow-100 text-yellow-700 border border-yellow-200';
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold text-gray-800 mb-6">My Asset Requests</h1>

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Category</th>
              <th className="p-4 font-semibold text-gray-600">My Reason</th>
              <th className="p-4 font-semibold text-gray-600">Date</th>
              <th className="p-4 font-semibold text-gray-600">Status</th>
              <th className="p-4 font-semibold text-gray-600">Manager's Comment</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="5" className="p-6 text-center">Loading requests...</td></tr>
            ) : myRequests?.length === 0 ? (
              <tr><td colSpan="5" className="p-8 text-center text-gray-500">You haven't made any requests yet.</td></tr>
            ) : (
              myRequests?.map(req => (
                <tr key={req.request_id} className="border-b hover:bg-gray-50 transition-colors">
                  <td className="p-4 font-medium text-gray-800">{req.category_name}</td>
                  <td className="p-4 text-gray-600">{req.reason || '-'}</td>
                  <td className="p-4 text-gray-600">
                    {req.request_date ? new Date(req.request_date).toLocaleDateString() : '-'}
                  </td>
                  <td className="p-4">
                    <span className={`px-2.5 py-1 rounded-full text-xs font-bold ${getStatusColor(req.status)}`}>
                      {req.status}
                    </span>
                  </td>
                  <td className="p-4 text-sm text-gray-600 italic">
                    {req.manager_comment ? `"${req.manager_comment}"` : '-'}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default EmployeeRequestsPage;