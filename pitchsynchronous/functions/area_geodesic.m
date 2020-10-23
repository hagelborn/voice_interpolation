function [a_mat] = area_geodesic(left,right,n_steps,~)
%Performs the tube area interpolation of two LPC filters with n_steps
%intermediate steps.

%Get area representation of filters
left_area=poly2area(left);
right_area = poly2area(right);

%Generate linearly spaced interpolation coefficients
k_hat = ((0:n_steps-1)/(n_steps-1))';

%Create interpolated areas
area_mat =  (1-k_hat).*left_area + k_hat.*right_area;
%Convert result to filters
a_mat = area2poly(area_mat);
end