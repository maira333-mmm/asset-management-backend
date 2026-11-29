import { apiSlice } from '../../api/apiSlice';

export const departmentsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getDepartments: builder.query({
      query: () => '/departments',
      providesTags: ['Departments'],
    }),
    createDepartment: builder.mutation({
      query: (data) => ({ url: '/departments', method: 'POST', body: data }),
      invalidatesTags: ['Departments'],
    }),
    deleteDepartment: builder.mutation({
      query: (id) => ({ url: `/departments/${id}`, method: 'DELETE' }),
      invalidatesTags: ['Departments'],
    }),
  }),
});

export const {
  useGetDepartmentsQuery,
  useCreateDepartmentMutation,
  useDeleteDepartmentMutation,
} = departmentsApi;