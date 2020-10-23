function [interp_a] = area_interpolation(left_a,right_a,k)
%interpolate between the filters left_a and right_a by interpolating in
%area_tube model. Written for use in the pitch synchrounous system.
left_area = poly2area(left_a);
right_area = poly2area(right_a);

ind = round((0:(size(left_area,1)-1))*((size(right_area,1)-1)/(size(left_area,1)-1))+1);
right_area_resamp = right_area(ind,:);

fun = @(x) 1/pi*asin(x)+0.5;
interp_area = (1-fun(k))*left_area + fun(k)*right_area_resamp;
interp_a = area2poly(interp_area);
end

