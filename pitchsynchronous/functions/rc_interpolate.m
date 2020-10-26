function [new_formant,new_rc] = rc_interpolate(left_formant,right_formant,interpolation_factor)
% Interpolates between two filters in reflection coefficient representation
%
% Input:
% left_formant / right_formant : filters of same length
% interpolation_factor: [0, 1]
% 
% Output
% new_formant: interpolated filter
% new_rc: interpolated reflection coefficient representation
left_rc = poly2rc(left_formant);
right_rc = poly2rc(right_formant);
new_rc = interpolation_factor*left_rc+(1-interpolation_factor)*right_rc;
new_formant = rc2poly(new_rc);
end

