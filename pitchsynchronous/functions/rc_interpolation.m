function [new_F,resampled_F] = rc_interpolation(left_F,right_F,k)
% Interpolates between the left and right smoothed spectrum by moving along the line
% in the reflection coefficients. The formants are smoothed before
% interpolation in order to get a smoother resulting formant. 
%
% Input:
% left_F / right_F : matrix where each row is a set of filter coefficients
% k: interpolation coefficient [0, 1]
% 
% Output
% new_F: matrix of interpolated filters
% resampled_F: 
right_rc = lpcmat2rcmat(right_F);
left_rc = lpcmat2rcmat(left_F);

ind = round((0:(size(left_rc,1)-1))*((size(right_rc,1)-1)/(size(left_rc,1)-1))+1);
right_rc = right_rc(ind,:);

resampled_F = rcmat2lpcmat(right_rc);
% smooth the reflection coefficient
% interpolation step 
% here the signal is interpolated by making the signals the same length and

new_rc = (1-k)*left_rc + (k)*right_rc;
new_F = rcmat2lpcmat(new_rc);
end