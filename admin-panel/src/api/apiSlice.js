import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

export const apiSlice = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({
    baseUrl: 'http://localhost:5000/api',
    prepareHeaders: (headers) => {
      const token = localStorage.getItem('token');
      if (token) headers.set('Authorization', `Bearer ${token}`);
      return headers;
    },
  }),
  
  // 🌟 Added 'Returns' tag
  tagTypes: ['Assets', 'Employees', 'Departments', 'Vendors', 'Categories', 'Locations', 'Requests', 'Settings', 'Returns'],
  
  refetchOnMountOrArgChange: true,
  refetchOnFocus: true, 
  
  endpoints: () => ({}),
});