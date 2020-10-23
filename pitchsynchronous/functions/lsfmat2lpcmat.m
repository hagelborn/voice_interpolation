function a_mat =  lsfmat2lpcmat(lsf_mat)
n_filt = size(lsf_mat,1);
n_freq = size(lsf_mat,2);

a_mat = zeros(n_filt,n_freq+1);

for i = 1:n_filt
    a_mat(i,:) = lsf2poly(lsf_mat(i,:));
end

end