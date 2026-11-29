import { apiSlice } from '../../api/apiSlice';

export const categoriesApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getCategories: builder.query({
      query: () => '/categories',
      providesTags: ['Categories'],
    }),
    createCategory: builder.mutation({
      query: (data) => ({ url: '/categories', method: 'POST', body: data }),
      invalidatesTags: ['Categories'],
    }),
  }),
});

export const { useGetCategoriesQuery, useCreateCategoryMutation } = categoriesApi;