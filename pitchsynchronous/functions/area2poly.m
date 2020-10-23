function [poly] = area2poly(area)
%convert area tube model representation of filter to polynomial
%representation.
rc = area2rc(area);
poly = rcmat2lpcmat(rc);
end

