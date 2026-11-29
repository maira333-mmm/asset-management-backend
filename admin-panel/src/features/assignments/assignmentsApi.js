import { apiSlice } from '../../api/apiSlice';

export const assignmentsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    // 1. Get available assets for manager's department
    getAvailableAssets: builder.query({
      query: () => '/assignments/available-assets',
      providesTags: ['Assets'],
    }),
    // 2. Assign asset to employee
    assignAsset: builder.mutation({
      query: (data) => ({
        url: '/assignments/assign',
        method: 'POST',
        body: data,
      }),
      invalidatesTags: ['Assets'],
    }),
    // 3. Get employee's assigned assets
    getMyAssets: builder.query({
      query: () => '/assignments/my-assets',
      providesTags: ['Assets'],
    }),
    // 🌟 4. Get manager's assigned history (Yeh missing tha)
    getMyAssignments: builder.query({
      query: () => '/assignments/my-assignments',
      providesTags: ['Assets'],
    }),
  }),
});

export const { 
  useGetAvailableAssetsQuery, 
  useAssignAssetMutation,
  useGetMyAssetsQuery,
  useGetMyAssignmentsQuery // 🌟 Yeh export hona zaroori hai
} = assignmentsApi;