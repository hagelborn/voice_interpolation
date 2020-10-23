function a = cep_env_lpc(signal,lpc_order,lifter_order)
% calculates the lpc from the Rectangular lifter smothed envelope.
m = length(signal);
ce = cepstral_envelope(signal,lifter_order);
ce_lin = exp(ce);
a = spectrum2lpc(ce_lin,lpc_order,m);
end
