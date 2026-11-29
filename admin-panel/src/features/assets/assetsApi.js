import { apiSlice } from '../../api/apiSlice';

export const assetsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getAssets: builder.query({
      query: () => '/assets',
      providesTags: ['Assets'],
    }),
    createAsset: builder.mutation({
      query: (data) => ({ url: '/assets', method: 'POST', body: data }),
      invalidatesTags: ['Assets'],
    }),
    // 🌟 NAYA: Update Asset Mutation
    updateAsset: builder.mutation({
      query: ({ id, data }) => ({
        url: `/assets/${id}`,
        method: 'PUT',
        body: data,
      }),
      invalidatesTags: ['Assets'],
    }),
    deleteAsset: builder.mutation({
      query: (id) => ({ url: `/assets/${id}`, method: 'DELETE' }),
      invalidatesTags: ['Assets'],
    }),
  }),
});

export const { 
  useGetAssetsQuery, 
  useCreateAssetMutation, 
  useUpdateAssetMutation, // Export kiya
  useDeleteAssetMutation 
} = assetsApi;