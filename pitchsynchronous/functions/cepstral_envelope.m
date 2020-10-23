function [env,rest,l_psd] = cepstral_envelope(signal,lifter_order)
%calculates the envelope of the psd by liftering the cepstrum, can also
%return the rest of the spectrum.
m = length(signal);
N = nextpow2(m);
dft_abs = abs(fft(signal,2^(N)));
dft_abs = dft_abs + (dft_abs == 0)*10^(-16);

l_psd = log(dft_abs);
ceps = real(ifft(l_psd));
[lifter,pitcher] = lifter_pitcher(ceps,lifter_order);
env = real(fft(lifter));
rest = real(fft(pitcher));
end