function [new_F] = omt_interpolation(left_env,right_env,k,lpc_order,left_samp,right_samp)
%Formant interpolation using the optimal transport path between envelopes.
[num_left,env_len] = size(left_env);
[num_right,~] = size(right_env);
half_len = env_len/2 +1;

% repeat or delete right envelopes until there are the same number.
ind = round((((0:(num_left-1))/(num_left-1))*(num_right-1))+1);

new_F = zeros(num_left,lpc_order+1);
for i = 1:num_left 
    half_left = left_env(i,1:half_len +1);
    half_right = right_env(ind(i),1:half_len+1);
    new_F(i,:) = optimal_transport_slice(half_left,half_right,k,left_samp(i),right_samp(ind(i)),lpc_order);
end


end

