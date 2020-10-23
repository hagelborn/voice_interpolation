function [new_formant,new_rc] = rc_interpolate(left_formant,right_formant,interpolation_factor)
%Generates an interpolated formant on the line segment connecting the
%reflection coefficients of the left and right formant filters.
left_rc = poly2rc(left_formant);
right_rc = poly2rc(right_formant);
new_rc = interpolation_factor*left_rc+(1-interpolation_factor)*right_rc;
new_formant = rc2poly(new_rc);
end

