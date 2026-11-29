import React, { useState } from 'react';
import { useGetLocationsQuery, useCreateLocationMutation } from '../features/locations/locationsApi';

const LocationsPage = () => {
  const { data: locations, isLoading } = useGetLocationsQuery();
  const [createLocation, { isLoading: isCreating }] = useCreateLocationMutation();
  const [formData, setFormData] = useState({ building: '', floor: '', room: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await createLocation(formData).unwrap();
      setFormData({ building: '', floor: '', room: '' });
      alert('Location added successfully!');
    } catch (err) {
      alert(err?.data?.message || 'Failed to add location');
    }
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Locations Management</h1>
        <span className="text-white px-4 py-1.5 rounded-full text-sm font-bold" style={{ backgroundColor: 'var(--primary-color)' }}>
          Total: {locations?.length || 0}
        </span>
      </div>
      
      <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
        <h2 className="text-lg font-bold mb-4">Add New Location</h2>
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <input type="text" placeholder="Building Name *" required value={formData.building} onChange={(e) => setFormData({...formData, building: e.target.value})} className="p-2 border rounded-lg" />
          <input type="text" placeholder="Floor" value={formData.floor} onChange={(e) => setFormData({...formData, floor: e.target.value})} className="p-2 border rounded-lg" />
          <input type="text" placeholder="Room" value={formData.room} onChange={(e) => setFormData({...formData, room: e.target.value})} className="p-2 border rounded-lg" />
          
          <button 
            type="submit" 
            disabled={isCreating} 
            className="md:col-span-3 text-white py-2 rounded-lg font-bold transition-all hover:opacity-90"
            style={{ backgroundColor: 'var(--primary-color)' }}
          >
            {isCreating ? 'Saving...' : 'Add Location'}
          </button>
        </form>
      </div>

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Building</th>
              <th className="p-4 font-semibold text-gray-600">Floor</th>
              <th className="p-4 font-semibold text-gray-600">Room</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? <tr><td colSpan="3" className="p-4 text-center">Loading...</td></tr> : 
             locations?.map(l => (
              <tr key={l.location_id} className="border-b hover:bg-gray-50">
                <td className="p-4 font-medium text-gray-800">{l.building}</td>
                <td className="p-4 text-gray-600">{l.floor || '-'}</td>
                <td className="p-4 text-gray-600">{l.room || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default LocationsPage;