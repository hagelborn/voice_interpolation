function [a,e] = spectrum2lpc(spectrum,order,signal_length)
% Calculates lpc coefficient based on the spectrum
m = signal_length;
R = ifft(abs(spectrum).^2);
R = R./m; % Biased autocorrelation estimate
[a,e] = levinson(R,order);
end

