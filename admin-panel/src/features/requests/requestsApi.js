import { apiSlice } from '../../api/apiSlice';

export const requestsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getPendingRequests: builder.query({
      query: () => '/requests/pending',
      providesTags: ['Requests'],
    }),
    getManagerRequestHistory: builder.query({
      query: () => '/requests/history',
      providesTags: ['Requests'],
    }),
    getMyRequests: builder.query({
      query: () => '/requests/my-requests',
      providesTags: ['Requests'],
    }),
    createRequest: builder.mutation({
      query: (data) => ({
        url: '/requests',
        method: 'POST',
        body: data,
      }),
      invalidatesTags: ['Requests'],
    }),
    updateRequestStatus: builder.mutation({
      query: ({ id, data }) => ({
        url: `/requests/${id}/status`,
        method: 'PUT',
        body: data,
      }),
      invalidatesTags: ['Requests', 'Assets'], // Assets update karein taake history update ho
    }),
  }),
});

export const { 
  useGetPendingRequestsQuery, 
  useGetManagerRequestHistoryQuery,
  useGetMyRequestsQuery,
  useCreateRequestMutation,
  useUpdateRequestStatusMutation 
} = requestsApi;