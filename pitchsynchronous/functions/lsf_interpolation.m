function [interp_a] = lsf_interpolation(left_a,right_a,k)
%interpolates between the formant filters left a and right a by first
%converting the filters to line spectral frequency and linearly
%interpolating.

left_lsf = polymat2lsfmat(left_a);
right_lsf = polymat2lsfmat(right_a);

ind = round((0:(size(left_a,1)-1))*((size(right_a,1)-1)/(size(left_a,1)-1))+1);

right_lsf_resampled = right_lsf(ind,:);
interp_lsf = (1-k)*left_lsf + k * right_lsf_resampled;
interp_a = lsfmat2lpcmat(interp_lsf);
end