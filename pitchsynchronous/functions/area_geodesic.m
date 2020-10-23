function [a_mat] = area_geodesic(left,right,n_steps,~)
%performs the area interpolation of two LPC filters with n_steps
%intermediate steps. If not specified an arcsin function regulating the speed of
%the interpolation will be used.
%Get area representation of filters
if nargin < 4
    fun = @(x) x;
else
    fun = @(x) 2/pi * asin(x);
end
left_area=poly2area(left);
right_area = poly2area(right);

k = ((0:n_steps-1)/(n_steps-1))';
k_hat = fun(k);
area_mat =  (1-k_hat).*left_area + k_hat.*right_area;
a_mat = area2poly(area_mat);
end