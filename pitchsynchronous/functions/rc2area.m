function [A] = rc2area(rc,A0)
%   Tube area representation of the LPC filter. A0, the initial area is set
%   to 1 if not specified.
if nargin <2
    A0 = 1;
end
rc_len = size(rc,2);
n_rc = size(rc,1);

A = zeros(n_rc,rc_len+1);
A(:,end) = A0;  
for j = rc_len:-1:1
    A(:,j) = A(:,j+1).*(1-rc(:,j))./(1+rc(:,j));
end
end

