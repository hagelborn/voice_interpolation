function [lpc_mat] = rcmat2lpcmat(rc_mat)
% Converts a matrix of filter polynomials to a matrix containing the
% corresponding reflection coefficients
% Input:
% rc_mat: matrix where each row is a set of reflection coefficients
% 
% Output:
% lpc_mat: matrix where each row is a set of filter coefficients
sz = size(rc_mat);
lpc_mat = zeros(sz(1),sz(2)+1);

for i = 1:sz(1)
    lpc_mat(i,:) = rc2poly(rc_mat(i,:));
end

end
    