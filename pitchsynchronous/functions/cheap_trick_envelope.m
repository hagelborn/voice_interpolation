function [ce] = cheap_trick_envelope(signal,tau)
%Cheap trick spectral smoothing, tau is the estimated number of samples in each period.
m = length(signal);
N = nextpow2(m);
dft_abs = abs(fft(signal,2^(N)));
dft_abs = dft_abs + (dft_abs == 0)*10^(-16);

l_psd = log(dft_abs);
ceps = real(ifft(l_psd));
s = @(x) sinc(x/tau);
n_cep = lifter_fun(ceps,s);
ce = real(fft(n_cep));
end

