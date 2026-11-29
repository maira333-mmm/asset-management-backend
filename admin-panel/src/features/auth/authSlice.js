import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  token: localStorage.getItem('token') || null,
  role: localStorage.getItem('role') || null,
  // Added new fields to store the logged-in employee's specific details
  employee_id: localStorage.getItem('employee_id') || null,
  department_id: localStorage.getItem('department_id') || null,
  manager_id: localStorage.getItem('manager_id') || null,
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setCredentials: (state, action) => {
      const { token, role, employee_id, department_id, manager_id } = action.payload;
      
      state.token = token;
      state.role = role;
      state.employee_id = employee_id;
      state.department_id = department_id;
      state.manager_id = manager_id;
      
      // Save everything to localStorage so it persists on page refresh
      localStorage.setItem('token', token);
      localStorage.setItem('role', role);
      
      if (employee_id) localStorage.setItem('employee_id', employee_id);
      if (department_id) localStorage.setItem('department_id', department_id);
      if (manager_id) localStorage.setItem('manager_id', manager_id);
    },
    logout: (state) => {
      state.token = null;
      state.role = null;
      state.employee_id = null;
      state.department_id = null;
      state.manager_id = null;
      
      // Clear everything from localStorage
      localStorage.clear();
    },
  },
});

export const { setCredentials, logout } = authSlice.actions;
export default authSlice.reducer;