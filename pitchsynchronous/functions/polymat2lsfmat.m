function [lsf_mat] = polymat2lsfmat(poly_mat)
%Converts the filter coefficient to line spectral pairs.

num_filters= size(poly_mat,1);
len_filters = size(poly_mat,2);
lsf_mat = zeros(num_filters,len_filters-1);

for i = 1:num_filters
   lsf_mat(i,:) = poly2lsf(poly_mat(i,:));
end
end

