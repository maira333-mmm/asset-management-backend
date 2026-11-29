import { apiSlice } from '../../api/apiSlice';

export const locationsApi = apiSlice.injectEndpoints({
  endpoints: (builder) => ({
    getLocations: builder.query({
      query: () => '/locations',
      providesTags: ['Locations'],
    }),
    createLocation: builder.mutation({
      query: (data) => ({ url: '/locations', method: 'POST', body: data }),
      invalidatesTags: ['Locations'],
    }),
  }),
});

export const { useGetLocationsQuery, useCreateLocationMutation } = locationsApi;