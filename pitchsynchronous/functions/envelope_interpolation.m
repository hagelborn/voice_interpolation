function [new_env] = envelope_interpolation(left_env,right_env,k)
%interpolates between the spectral envelopes of two signals using the
%modified optimal transport interpolation.
left_env = left_env/sum(left_env);
right_env = right_env/sum(right_env);

T = transport_matrix_sparse(left_env,right_env);
T = T(T(:,3)~=0,:);
new_env = dtw_interpolation(left_env,T(:,1),right_env,T(:,2),k);
end
