function [rc_mat] = lpcmat2rcmat(lpcmat)
%converts a matrix of filter polynomials to a matrix containing the
%corresponding reflection coefficients
sz = size(lpcmat);
rc_mat = zeros(sz(1),sz(2)-1);

for i = 1:sz(1)
    rc_mat(i,:) = poly2rc(lpcmat(i,:));
end

end
    