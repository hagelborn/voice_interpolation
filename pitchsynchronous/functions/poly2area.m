function [area] = poly2area(poly)
%converts the polynomial coefficient into an area tube model. The last area
%is assumed to be one.
rc = lpcmat2rcmat(poly);
area = rc2area(rc);
end 

