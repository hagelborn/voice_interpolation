function [ncep] = lifter_fun(cep,fun)
% Perform lifter windowing with arbitrary function.
cep_len = length(cep);
lifter_window = zeros(cep_len,1);
lifter_window(1:cep_len/2) = fun(((1:cep_len/2)-1));
lifter_window(cep_len/2+1:cep_len) = fun((cep_len-(cep_len/2:cep_len-1)));
ncep = cep(:).*lifter_window(:);
end