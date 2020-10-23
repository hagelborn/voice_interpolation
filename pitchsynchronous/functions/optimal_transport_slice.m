function [a] = optimal_transport_slice(left,right,k,n_left,n_right,lpc_order)
%
left_sum = sum(left);
right_sum = sum(right);

left_nrg = norm(left);
right_nrg = norm(right);

left_norm = left/left_sum;
right_norm = right/right_sum;

intermass = left_nrg^(1-k)*right_nrg^k;
interpoints = (1-k)*n_left + k*n_right;

T = transport_matrix_sparse(left_norm,right_norm);
T = T((T(:,3)~=0),:);

interp = dtw_interpolation(left_norm, T(:,1), right_norm, T(:,2), k);
interp = interp/sum(interp);

interp_whole = intermass*[interp;interp(end-1:-1:2)];
a = spectrum2lpc(interp_whole,lpc_order,interpoints);

end

