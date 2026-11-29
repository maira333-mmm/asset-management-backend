import React, { useState } from 'react';
import { 
  useGetAssetsQuery, 
  useCreateAssetMutation, 
  useUpdateAssetMutation, 
  useDeleteAssetMutation 
} from '../features/assets/assetsApi';
import { useGetCategoriesQuery } from '../features/categories/categoriesApi';
import { useGetVendorsQuery } from '../features/vendors/vendorsApi';
import { useGetLocationsQuery } from '../features/locations/locationsApi';
import { useGetDepartmentsQuery } from '../features/departments/departmentsApi';

const AssetsPage = () => {
  const { data: assets, isLoading } = useGetAssetsQuery();
  const { data: categories } = useGetCategoriesQuery();
  const { data: vendors } = useGetVendorsQuery();
  const { data: locations } = useGetLocationsQuery();
  const { data: departments } = useGetDepartmentsQuery();
  
  const [createAsset, { isLoading: isCreating }] = useCreateAssetMutation();
  const [updateAsset, { isLoading: isUpdating }] = useUpdateAssetMutation(); 
  const [deleteAsset] = useDeleteAssetMutation();
  const [editId, setEditId] = useState(null);

  const [formData, setFormData] = useState({
    asset_tag: '', serial_number: '', status: 'Available', purchase_date: '',
    category_id: '', vendor_id: '', location_id: '', dept_id: ''
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editId) {
        await updateAsset({ id: editId, data: formData }).unwrap();
        alert('Asset updated successfully!');
      } else {
        await createAsset(formData).unwrap();
        alert('Asset created successfully!');
      }
      resetForm();
    } catch (err) {
      alert(err?.data?.message || err?.data?.error || 'Operation failed');
    }
  };

  const resetForm = () => {
    setFormData({ asset_tag: '', serial_number: '', status: 'Available', purchase_date: '', category_id: '', vendor_id: '', location_id: '', dept_id: '' });
    setEditId(null);
  };

  const handleEdit = (asset) => {
    let formattedDate = '';
    if (asset.purchase_date) {
      formattedDate = asset.purchase_date.split('T')[0];
    }
    setFormData({
      asset_tag: asset.asset_tag,
      serial_number: asset.serial_number || '',
      status: asset.status || 'Available',
      purchase_date: formattedDate,
      category_id: asset.category_id || '',
      vendor_id: asset.vendor_id || '',
      location_id: asset.location_id || '',
      dept_id: asset.dept_id || ''
    });
    setEditId(asset.asset_id);
    window.scrollTo(0, 0);
  };

  const handleDelete = async (id) => {
    if(window.confirm('Are you sure you want to delete this asset?')) {
      try {
        await deleteAsset(id).unwrap();
        alert('Asset deleted!');
      } catch (err) {
        alert(err?.data?.message || 'Failed to delete');
      }
    }
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Assets Management</h1>
        <span className="text-white px-4 py-1.5 rounded-full text-sm font-bold" style={{ backgroundColor: 'var(--primary-color)' }}>
          Total: {assets?.length || 0}
        </span>
      </div>
      
      <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-bold">{editId ? 'Edit Asset (Change Status Here)' : 'Add New Asset'}</h2>
          {editId && (
            <button onClick={resetForm} className="text-red-500 text-sm hover:underline">
              Cancel Edit
            </button>
          )}
        </div>
        
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <input type="text" placeholder="Asset Tag *" required value={formData.asset_tag} onChange={(e) => setFormData({...formData, asset_tag: e.target.value})} className="p-2 border rounded-lg" />
          <input type="text" placeholder="Serial Number" value={formData.serial_number} onChange={(e) => setFormData({...formData, serial_number: e.target.value})} className="p-2 border rounded-lg" />
          <input type="date" value={formData.purchase_date} onChange={(e) => setFormData({...formData, purchase_date: e.target.value})} className="p-2 border rounded-lg text-gray-500" />
          
          <select value={formData.status} onChange={(e) => setFormData({...formData, status: e.target.value})} className="p-2 border rounded-lg">
            <option value="Available">Available</option>
            <option value="Assigned">Assigned</option>
            <option value="Under Maintenance">Under Maintenance</option>
            <option value="Retired">Retired</option>
          </select>

          <select required value={formData.category_id} onChange={(e) => setFormData({...formData, category_id: e.target.value})} className="p-2 border rounded-lg">
            <option value="">Select Category *</option>
            {categories?.map(c => <option key={c.category_id} value={c.category_id}>{c.category_name}</option>)}
          </select>

          <select required value={formData.vendor_id} onChange={(e) => setFormData({...formData, vendor_id: e.target.value})} className="p-2 border rounded-lg">
            <option value="">Select Vendor *</option>
            {vendors?.map(v => <option key={v.vendor_id} value={v.vendor_id}>{v.vendor_name}</option>)}
          </select>

          <select required value={formData.location_id} onChange={(e) => setFormData({...formData, location_id: e.target.value})} className="p-2 border rounded-lg">
            <option value="">Select Location *</option>
            {locations?.map(l => <option key={l.location_id} value={l.location_id}>{l.building} - {l.room}</option>)}
          </select>

          <select required value={formData.dept_id} onChange={(e) => setFormData({...formData, dept_id: e.target.value})} className="p-2 border rounded-lg">
            <option value="">Select Department *</option>
            {departments?.map(d => <option key={d.department_id} value={d.department_id}>{d.department_name}</option>)}
          </select>

          <button 
            type="submit" 
            disabled={isCreating || isUpdating} 
            className="md:col-span-4 text-white py-2 rounded-lg font-bold mt-2 transition-all hover:opacity-90 disabled:opacity-50"
            style={{ backgroundColor: editId ? '#ea580c' : 'var(--primary-color)' }}
          >
            {isCreating || isUpdating ? 'Saving...' : (editId ? 'Update Asset Status/Details' : 'Create Asset')}
          </button>
        </form>
      </div>

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Asset Tag</th>
              <th className="p-4 font-semibold text-gray-600">Serial No</th>
              <th className="p-4 font-semibold text-gray-600">Status</th>
              <th className="p-4 font-semibold text-gray-600">Category</th>
              <th className="p-4 font-semibold text-gray-600 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="5" className="p-4 text-center">Loading assets...</td></tr>
            ) : assets?.length === 0 ? (
              <tr><td colSpan="5" className="p-4 text-center text-gray-500">No assets found.</td></tr>
            ) : (
              assets?.map(a => (
                <tr key={a.asset_id} className="border-b hover:bg-gray-50">
                  <td className="p-4 font-medium text-gray-800">{a.asset_tag}</td>
                  <td className="p-4 text-gray-600">{a.serial_number || '-'}</td>
                  <td className="p-4 text-gray-600">
                    <span className={`px-2 py-1 rounded-full text-xs font-bold 
                      ${a.status === 'Available' ? 'bg-green-100 text-green-700' : 
                        a.status === 'Assigned' ? 'bg-blue-100 text-blue-700' : 
                        a.status === 'Retired' ? 'bg-red-100 text-red-700' :
                        'bg-yellow-100 text-yellow-700'}`}>
                      {a.status}
                    </span>
                  </td>
                  <td className="p-4 text-gray-600">{categories?.find(c => c.category_id === a.category_id)?.category_name || '-'}</td>
                  <td className="p-4 text-right">
                    <button onClick={() => handleEdit(a)} className="font-semibold mr-3 hover:underline" style={{ color: 'var(--primary-color)' }}>Edit</button>
                    <button onClick={() => handleDelete(a.asset_id)} className="text-red-600 hover:underline text-sm font-semibold">Delete</button>
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

export default AssetsPage;