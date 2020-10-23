function [interp] = omt_geodesic(Pi,k)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
interp = zeros(size(Pi,1),1);
pang = 0;
for i = 1:size(Pi,1)
   for j = 1:size(Pi,2)
        if round((1-k)*i+k*j) == 162 && Pi(i,j) ~= 0 
            pang = pang +1;
            Pi(i,j)
        end
        interp(round((1-k)*i+k*j)) = interp(round((1-k)*i+k*j))+ Pi(i,j);
   end
end

end

