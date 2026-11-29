import React, { useState } from 'react';
import { 
  useGetEmployeesQuery, 
  useCreateEmployeeMutation, 
  useUpdateEmployeeMutation, 
  useDeleteEmployeeMutation,
  useUpdateEmployeeStatusMutation 
} from '../features/employees/employeesApi';
import { useGetDepartmentsQuery } from '../features/departments/departmentsApi'; 

const EmployeesPage = () => {
  const { data: employees, isLoading, isError, error } = useGetEmployeesQuery();
  const { data: departments } = useGetDepartmentsQuery();
  
  const [createEmployee, { isLoading: isCreating }] = useCreateEmployeeMutation();
  const [updateEmployee, { isLoading: isUpdating }] = useUpdateEmployeeMutation();
  const [deleteEmployee] = useDeleteEmployeeMutation();
  const [updateStatus] = useUpdateEmployeeStatusMutation(); 

  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState(null);
  const [formData, setFormData] = useState({
    name: '', contact: '', cnic: '', joining_date: '', designation: '',
    address: '', emergency_contact: '', email: '', password: '',
    department_id: '', role_name: 'Employee', manager_id: '',
  });

  const handleInputChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editId) {
        await updateEmployee({ id: editId, data: formData }).unwrap();
        alert('Employee updated successfully!');
      } else {
        await createEmployee(formData).unwrap();
        alert('Employee created successfully!');
      }
      setShowForm(false);
      setEditId(null);
      resetForm();
    } catch (err) {
      alert(err?.data?.message || err?.data?.error || 'Something went wrong while saving employee.');
    }
  };

  const resetForm = () => {
    setFormData({ name: '', contact: '', cnic: '', joining_date: '', designation: '', address: '', emergency_contact: '', email: '', password: '', department_id: '', role_name: 'Employee', manager_id: '' });
  };

  const handleEdit = (emp) => {
    setFormData({
      name: emp.name, contact: emp.contact || '', cnic: emp.cnic || '', 
      joining_date: emp.joining_date ? emp.joining_date.split('T')[0] : '',
      designation: emp.designation || '', address: emp.address || '', 
      emergency_contact: emp.emergency_contact || '', email: emp.email,
      password: '', department_id: emp.department_id || '', 
      role_name: emp.role_name || 'Employee',
      manager_id: emp.manager_id || ''
    });
    setEditId(emp.employee_id);
    setShowForm(true);
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this employee?")) {
      try {
        await deleteEmployee(id).unwrap();
      } catch (err) {
        alert(err?.data?.message || 'Cannot delete employee. Suspend them instead.');
      }
    }
  };

  const handleToggleStatus = async (id, currentStatus) => {
    const newStatus = currentStatus === 'Active' ? 'Suspended' : 'Active';
    if (window.confirm(`Are you sure you want to ${newStatus === 'Active' ? 'Activate' : 'Suspend'} this employee?`)) {
      try {
        await updateStatus({ id, status: newStatus }).unwrap();
      } catch (err) {
        alert(err?.data?.message || 'Failed to update status');
      }
    }
  };

  if (isError) {
    return (
      <div className="p-6">
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg shadow-md">
          <p className="font-bold">Failed to load employees data.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Employees Management</h1>
        <button 
          onClick={() => { setShowForm(!showForm); setEditId(null); resetForm(); }}
          className="text-white px-4 py-2 rounded-lg font-semibold transition-all hover:opacity-90 shadow-sm"
          style={{ backgroundColor: 'var(--primary-color)' }} // 🌟 Button Fix
        >
          {showForm ? 'Close Form' : '+ Add Employee'}
        </button>
      </div>

      {showForm && (
        <div className="bg-white p-6 rounded-xl shadow-md mb-8 border border-gray-100">
          <h2 className="text-xl font-bold mb-4">{editId ? 'Edit Employee' : 'Add New Employee'}</h2>
          <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <input type="text" name="name" placeholder="Full Name *" value={formData.name} onChange={handleInputChange} required className="p-2 border rounded-lg" />
            <input type="email" name="email" placeholder="Email *" value={formData.email} onChange={handleInputChange} required disabled={!!editId} className="p-2 border rounded-lg disabled:bg-gray-100" />
            {!editId && <input type="password" name="password" placeholder="Password *" value={formData.password} onChange={handleInputChange} required className="p-2 border rounded-lg" />}
            <input type="text" name="cnic" placeholder="CNIC *" value={formData.cnic} onChange={handleInputChange} required className="p-2 border rounded-lg" />
            <input type="text" name="contact" placeholder="Contact Number" value={formData.contact} onChange={handleInputChange} className="p-2 border rounded-lg" />
            <input type="date" name="joining_date" value={formData.joining_date} onChange={handleInputChange} className="p-2 border rounded-lg text-gray-500" />
            <input type="text" name="designation" placeholder="Designation" value={formData.designation} onChange={handleInputChange} className="p-2 border rounded-lg" />
            
            <select name="department_id" value={formData.department_id} onChange={handleInputChange} required className="p-2 border rounded-lg">
              <option value="">Select Department *</option>
              {departments?.map(dept => <option key={dept.department_id} value={dept.department_id}>{dept.department_name}</option>)}
            </select>

            <select name="role_name" value={formData.role_name} onChange={handleInputChange} className="p-2 border rounded-lg">
              <option value="Employee">Employee</option>
              <option value="Manager">Manager</option>
              <option value="Admin">Admin</option>
            </select>

            <input type="text" name="address" placeholder="Address" value={formData.address} onChange={handleInputChange} className="p-2 border rounded-lg md:col-span-2" />
            <input type="text" name="emergency_contact" placeholder="Emergency Contact" value={formData.emergency_contact} onChange={handleInputChange} className="p-2 border rounded-lg md:col-span-2" />

            <button 
              type="submit" 
              disabled={isCreating || isUpdating} 
              className="md:col-span-2 text-white py-2 rounded-lg font-bold mt-2 transition-all disabled:opacity-50 hover:opacity-90"
              style={{ backgroundColor: 'var(--primary-color)' }} // 🌟 Button Fix
            >
              {isCreating || isUpdating ? 'Saving...' : (editId ? 'Update Employee' : 'Create Employee')}
            </button>
          </form>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-50 border-b">
            <tr>
              <th className="p-4 font-semibold text-gray-600">Name & Email</th>
              <th className="p-4 font-semibold text-gray-600">Role / Designation</th>
              <th className="p-4 font-semibold text-gray-600">Department</th>
              <th className="p-4 font-semibold text-gray-600">Status</th>
              <th className="p-4 font-semibold text-gray-600 text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="5" className="p-6 text-center text-gray-500">Loading employees...</td></tr>
            ) : employees?.length === 0 ? (
              <tr><td colSpan="5" className="p-6 text-center text-gray-500">No employees found. Click "+ Add Employee" to create one.</td></tr>
            ) : (
              employees?.map(emp => (
                <tr key={emp.employee_id} className="border-b hover:bg-gray-50 transition-colors">
                  <td className="p-4">
                    <div className="font-bold text-gray-800">{emp.name}</div>
                    <div className="text-xs text-gray-500">{emp.email}</div>
                  </td>
                  <td className="p-4 text-sm text-gray-600">
                    <div className="font-medium text-gray-800">{emp.role_name || 'Employee'}</div>
                    <div className="text-xs text-gray-500">{emp.designation || 'N/A'}</div>
                  </td>
                  <td className="p-4 text-sm text-gray-600">
                    {departments?.find(d => d.department_id === emp.department_id)?.department_name || 'N/A'}
                  </td>
                  <td className="p-4 text-sm">
                    <span className={`px-2 py-1 rounded-full text-xs font-bold ${emp.status === 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                      {emp.status || 'Active'}
                    </span>
                  </td>
                  <td className="p-4 text-right">
                    {/* 🌟 Actions Buttons Fix */}
                    <button 
                      onClick={() => handleEdit(emp)} 
                      className="font-semibold mr-3 hover:underline"
                      style={{ color: 'var(--primary-color)' }}
                    >
                      Edit
                    </button>
                    <button 
                      onClick={() => handleToggleStatus(emp.employee_id, emp.status)} 
                      className={`font-semibold mr-3 hover:underline ${emp.status === 'Active' ? 'text-orange-500' : 'text-green-600'}`}
                    >
                      {emp.status === 'Active' ? 'Suspend' : 'Activate'}
                    </button>
                    <button 
                      onClick={() => handleDelete(emp.employee_id)} 
                      className="text-red-600 font-semibold hover:underline"
                    >
                      Delete
                    </button>
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

export default EmployeesPage;