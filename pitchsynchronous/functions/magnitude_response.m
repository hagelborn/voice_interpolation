function [spec] = magnitude_response(filters,plotIt)
if nargin < 2
    plotIt = 0;
end
num_windows = size(filters,1);
spec = zeros(num_windows,512);
for i = 1:num_windows
    H = freqz(1,filters(i,:)); 
    spec(i,:) = log(abs(H).^2);
end
if plotIt
    figure
    surf(spec,'edgecolor','none')
end