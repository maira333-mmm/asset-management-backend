import React, { useState } from 'react';
import { useGetVendorsQuery, useCreateVendorMutation } from '../features/vendors/vendorsApi';

const VendorsPage = () => {
  const { data: vendors, isLoading } = useGetVendorsQuery();
  const [createVendor, { isLoading: isCreating }] = useCreateVendorMutation();
  const [formData, setFormData] = useState({ vendor_name: '', email: '', phone: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await createVendor(formData).unwrap();
      setFormData({ vendor_name: '', email: '', phone: '' });
      alert('Vendor added successfully!');
    } catch (err) {
      alert(err?.data?.message || 'Failed to add vendor');
    }
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Vendors Management</h1>
        <span className="text-white px-4 py-1.5 rounded-full text-sm font-bold" style={{ backgroundColor: 'var(--primary-color)' }}>
          Total: {vendors?.length || 0}
        </span>
      </div>
      
      <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
        <h2 className="text-lg font-bold mb-4">Add New Vendor</h2>
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <input type="text" placeholder="Vendor Name *" required value={formData.vendor_name} onChange={(e) => setFormData({...formData, vendor_name: e.target.value})} className="p-2 border rounded-lg" />
          <input type="email" placeholder="Email" value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} className="p-2 border rounded-lg" />
          <input type="text" placeholder="Phone" value={formData.phone} onChange={(e) => setFormData({...formData, phone: e.target.value})} className="p-2 border rounded-lg" />
          
          <button 
            type="submit" 
            disabled={isCreating} 
            className="md:col-span-3 text-white py-2 rounded-lg font-bold transition-all hover:opacity-90"
            style={{ backgroundColor: 'var(--primary-color)' }}
          >
            {isCreating ? 'Saving...' : 'Add Vendor'}
          </button>
        </form>
      </div>

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Vendor Name</th>
              <th className="p-4 font-semibold text-gray-600">Email</th>
              <th className="p-4 font-semibold text-gray-600">Phone</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="3" className="p-4 text-center">Loading...</td></tr>
            ) : vendors?.length === 0 ? (
              <tr><td colSpan="3" className="p-4 text-center text-gray-500">No vendors found. Add one above.</td></tr>
            ) : (
              vendors?.map(v => (
                <tr key={v.vendor_id} className="border-b hover:bg-gray-50">
                  <td className="p-4 font-medium text-gray-800">{v.vendor_name}</td>
                  <td className="p-4 text-gray-600">{v.email || '-'}</td>
                  <td className="p-4 text-gray-600">{v.phone || '-'}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default VendorsPage;