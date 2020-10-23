function [ce] = cheap_trick_envelope(signal,tau)
%cheap trick envelope estimate.
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

