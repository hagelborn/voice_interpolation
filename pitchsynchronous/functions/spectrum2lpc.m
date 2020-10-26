function [a,e] = spectrum2lpc(spectrum,order,signal_length)
% Calculates lpc coefficient based on the spectrum using the biased
% autocorrelation estimate and the levension durbin recursion
% Input:
% spectrum: complex or real spectrum
% order: filter order
% sinal_length: signal length
%
% Output:
% a: Filter coefficients
% e: prediction error
m = signal_length;
R = ifft(abs(spectrum).^2);
R = R./m; % Biased autocorrelation estimate
[a,e] = levinson(R,order);
end

