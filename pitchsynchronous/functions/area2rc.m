function [rc] = area2rc(A)
%calculates the reflection coefficients corresponding to the area tube
%model desctribed by the vector A. Inverse of rc2area.
A_len = size(A,2)-1;
numA = size(A,1);
rc = zeros(numA,A_len-1);

for i = 1:numA
    for j = 1:A_len
        rc(i,j) = (A(i,j+1)-A(i,j))/(A(i,j+1)+A(i,j));
    end
end
end