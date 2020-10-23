function [poly] = area2poly(area)
%Convert area tube model representation of filter to polynomial
%representation.
rc = area2rc(area);
poly = rcmat2lpcmat(rc);
end

