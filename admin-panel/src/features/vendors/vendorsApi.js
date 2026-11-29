import { apiSlice } from '../../api/apiSlice';

export const vendorsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getVendors: builder.query({
      query: () => '/vendors',
      providesTags: ['Vendors'],
    }),
    createVendor: builder.mutation({
      query: (data) => ({ url: '/vendors', method: 'POST', body: data }),
      invalidatesTags: ['Vendors'],
    }),
  }),
});

export const { useGetVendorsQuery, useCreateVendorMutation } = vendorsApi;