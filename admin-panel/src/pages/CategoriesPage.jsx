import React, { useState } from 'react';
import { useGetCategoriesQuery, useCreateCategoryMutation } from '../features/categories/categoriesApi';

const CategoriesPage = () => {
  const { data: categories, isLoading } = useGetCategoriesQuery();
  const [createCategory, { isLoading: isCreating }] = useCreateCategoryMutation();
  const [formData, setFormData] = useState({ category_name: '', parent_id: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const payload = { ...formData, parent_id: formData.parent_id || null };
      await createCategory(payload).unwrap();
      setFormData({ category_name: '', parent_id: '' });
      alert('Category added successfully!');
    } catch (err) {
      alert(err?.data?.message || 'Failed to add category');
    }
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Categories Management</h1>
        <span className="text-white px-4 py-1.5 rounded-full text-sm font-bold" style={{ backgroundColor: 'var(--primary-color)' }}>
          Total: {categories?.length || 0}
        </span>
      </div>
      
      <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
        <h2 className="text-lg font-bold mb-4">Add New Category</h2>
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <input type="text" placeholder="Category Name *" required value={formData.category_name} onChange={(e) => setFormData({...formData, category_name: e.target.value})} className="p-2 border rounded-lg" />
          <select value={formData.parent_id} onChange={(e) => setFormData({...formData, parent_id: e.target.value})} className="p-2 border rounded-lg">
            <option value="">No Parent (Main Category)</option>
            {categories?.filter(c => !c.parent_id).map(c => (
              <option key={c.category_id} value={c.category_id}>{c.category_name}</option>
            ))}
          </select>
          
          <button 
            type="submit" 
            disabled={isCreating} 
            className="md:col-span-2 text-white py-2 rounded-lg font-bold transition-all hover:opacity-90"
            style={{ backgroundColor: 'var(--primary-color)' }}
          >
            {isCreating ? 'Saving...' : 'Add Category'}
          </button>
        </form>
      </div>

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Category Name</th>
              <th className="p-4 font-semibold text-gray-600">Type</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? <tr><td colSpan="2" className="p-4 text-center">Loading...</td></tr> : 
             categories?.map(c => (
              <tr key={c.category_id} className="border-b hover:bg-gray-50">
                <td className="p-4 font-medium text-gray-800">{c.category_name}</td>
                <td className="p-4 text-gray-600">{c.parent_id ? 'Sub-Category' : 'Main Category'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default CategoriesPage;