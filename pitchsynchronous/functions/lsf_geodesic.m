function [a_mat] = lsf_geodesic(left_a,right_a,steps)
%Computes intermediate filters between two filters based on the Line
%spectral frequency interpolation with steps intermediate steps.

%convert filters to line spectral frequencies
left_lsf = poly2lsf(left_a)';
right_lsf = poly2lsf(right_a)';

%generate linearly spaced interpolation coefficients
k = ((0:steps-1)/(steps-1))';

%create intermediate LSFs
interp_lsf = (1-k) * left_lsf + k * right_lsf;
%Convert result to matrix of filters.
a_mat = lsfmat2lpcmat(interp_lsf);
end

