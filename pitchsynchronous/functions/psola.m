function [new_signal] = psola(signal,peaks,f_ratio)
%time domain pitch synchronous overlap and add
N = length(signal);
new_signal = zeros(N,1);
n_new_peaks = floor(length(peaks)*f_ratio);
new_peaks_ref = linspace(1,length(peaks),n_new_peaks);
new_peaks = zeros(n_new_peaks,1);
for i = 1:n_new_peaks
    npr = new_peaks_ref(i);
    weight = npr-floor(npr);
    left = floor(npr);
    right = ceil(npr);
    new_peaks(i) = round(peaks(left)*(1-weight) + peaks(right)*weight);
end

for j = 2:n_new_peaks
    [~,i] = min(abs(peaks - new_peaks(j)));
    if j == 1
        p1 = new_peaks(j);
    else
        p1 = new_peaks(j)-new_peaks(j-1);
    end
    if j == n_new_peaks
        p2 = N-new_peaks(j);
    else
        p2 = new_peaks(j+1)-new_peaks(j);
    end
    if peaks(i)-p1 < 1
        p1 = peaks(i);
    end
    if (peaks(i) + p2) > N
        p2 = N-peaks(i);
    end
    pre_win = linspace(0,1,p1+1)';
    post_win = linspace(1,0,p2+1)';
    window = [pre_win(2:end);post_win(2:end)];
    
    new_signal(new_peaks(j) - p1+1:new_peaks(j)+p2) = new_signal(new_peaks(j) - p1+1:new_peaks(j)+p2)...
        +window .* signal(peaks(i) - p1+1:peaks(i) + p2);
end
end