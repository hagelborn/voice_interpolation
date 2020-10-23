function [root_mat,ang_mat,abs_mat] = polar_roots(mat)
%extracts the angle and absolute value of each root of the time varying
%expected input structure is (number of sample polynomials x polynomial coefficients)
    sz = size(mat);
    root_mat = zeros(sz(1),sz(2)-1);
    n = sz(2);
    for count = 1:sz(1)
        a = diag(ones(1,n-2,class(mat)),-1);
        a(1,:) = -mat(count,2:end);
        root_mat(count,:)=eig(a);
    end
    ang_mat = angle(root_mat);
    abs_mat = abs(root_mat);
end
