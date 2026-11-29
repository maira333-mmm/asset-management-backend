import { apiSlice } from '../../api/apiSlice';

export const returnsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    createReturnRequest: builder.mutation({
      query: (data) => ({
        url: '/returns',
        method: 'POST',
        body: data,
      }),
      invalidatesTags: ['Returns', 'Assets'],
    }),
    getPendingReturns: builder.query({
      query: () => '/returns/pending',
      providesTags: ['Returns'],
    }),
    updateReturnStatus: builder.mutation({
      query: ({ id, data }) => ({
        url: `/returns/${id}/status`,
        method: 'PUT',
        body: data,
      }),
      invalidatesTags: ['Returns', 'Assets'],
    }),
    getMyReturns: builder.query({
      query: () => '/returns/my-returns',
      providesTags: ['Returns'],
    }),
  }),
});

export const { 
  useCreateReturnRequestMutation,
  useGetPendingReturnsQuery,
  useUpdateReturnStatusMutation,
  useGetMyReturnsQuery
} = returnsApi;