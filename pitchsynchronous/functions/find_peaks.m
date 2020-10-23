function [peaks] = find_peaks(signal,fs)
%find the peak in each period of the signal
max_hz = 300;
min_hz = 70;
win_len = round(fs*0.04);
max_change = 1.05;
min_change = 0.95;

N = length(signal);
min_period = floor(fs/max_hz);
max_period = floor(fs/min_hz);

%compute pitch periodicity
periods = compute_periods(signal, win_len, min_period, max_period);
%restrict range to avoid errors
m_period = median(periods);
max_period = round(1.05*m_period);
min_period = round(0.95*m_period);
%re estimate period based on mean
periods = compute_periods(signal,win_len, min_period, max_period);
[~,prev] = max(signal(1:periods(1)*1.1));
peaks = zeros(N,1);
peaks([1, prev]) = 1;
while true
    idx = ceil(prev/win_len);
    if prev + round(periods(idx)*max_change) > N
        break;
    end
    [a,argmax] = max(signal((prev + round(periods(idx)*min_change)):(prev + round(periods(idx)*max_change))));
    prev=prev+round(periods(idx)*min_change) + argmax-1; 
    peaks(prev)=1;
end
end