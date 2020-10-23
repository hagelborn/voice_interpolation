function [a_mat] = rc_geodesic(left_a,right_a,n_steps)
%Interpolates between the filters left_a and right_a by interpolating in
%the reflection coefficients.
left_rc = poly2rc(left_a)';
right_rc = poly2rc(right_a)';
k = ((0:n_steps-1)/(n_steps-1))';
rc_mat = (1-k).*left_rc + k.*right_rc;
a_mat = rcmat2lpcmat(rc_mat);

end

