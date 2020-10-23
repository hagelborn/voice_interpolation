function [a_mat] = lsf_geodesic(left_a,right_a,steps)
%
left_lsf = poly2lsf(left_a)';
right_lsf = poly2lsf(right_a)';

k = ((0:steps-1)/(steps-1))';

interp_lsf = (1-k) * left_lsf + k * right_lsf;
a_mat = lsfmat2lpcmat(interp_lsf);
end

