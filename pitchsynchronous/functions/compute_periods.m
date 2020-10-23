function [periods] = compute_periods(signal,win_len,min_period,max_period)
%computes the periodicity in each window of a time domain signal.
N = length(signal);
n_frames = ceil(N/win_len);
periods = zeros(n_frames,1);
max_period = min([win_len,max_period]);
for i = 1:n_frames-1
    fourier = fft(signal(win_len*(i-1)+1:(win_len*i)));
    fourier(1)=0;
    autoc = real(ifft(fourier.*conj(fourier)));
    [~,arg_max] = max(autoc(min_period:max_period));
    peak = min_period + arg_max -1;
    periods(i,1) = peak;
end
%overlap last part
fourier = fft(signal(N-win_len+1:N));
fourier(1) = 0;
autoc = real(ifft(fourier.*conj(fourier)));
[~,arg_max] = max(autoc(min_period:max_period));
peak = min_period + arg_max -1;
periods(n_frames,1) = peak;
end
