function ncep = chp_trick(cep,f0)

cep_len = length(cep);
lifter_window = zeros(cep_len,1);

lifter_window(1:cep_len/2) = sinc(f0*((1:cep_len/2)-1));

lifter_window(cep_len/2+1:cep_len) = sinc(f0*(cep_len-(cep_len/2:cep_len-1)));
ncep = cep(:).*lifter_window(:);
end
