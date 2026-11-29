import { apiSlice } from '../../api/apiSlice';

export const employeesApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getEmployees: builder.query({
      query: () => '/employees',
      providesTags: ['Employees'],
    }),
    createEmployee: builder.mutation({
      query: (data) => ({ url: '/employees', method: 'POST', body: data }),
      invalidatesTags: ['Employees'],
    }),
    updateEmployee: builder.mutation({
      query: ({ id, data }) => ({ url: `/employees/${id}`, method: 'PUT', body: data }),
      invalidatesTags: ['Employees'],
    }),
    deleteEmployee: builder.mutation({
      query: (id) => ({ url: `/employees/${id}`, method: 'DELETE' }),
      invalidatesTags: ['Employees'],
    }),
    updateEmployeeStatus: builder.mutation({
      query: ({ id, status }) => ({
        url: `/employees/${id}/status`,
        method: 'PUT',
        body: { status },
      }),
      invalidatesTags: ['Employees'],
    }),
  }),
});

export const {
  useGetEmployeesQuery,
  useCreateEmployeeMutation,
  useUpdateEmployeeMutation,
  useDeleteEmployeeMutation,
  useUpdateEmployeeStatusMutation,
} = employeesApi;