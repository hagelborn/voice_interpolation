function [a_mat,interp_mat] = omt_lpc_geodesic(left,right,lpc_order,lifter_order,n_steps)
% Create n_steps intermediate filters between the frames left and right.
% The spectral smoothing of the frames are calculated using a rectangular lifter of
% lifter_order. n_steps intermediate smoothed spectra are calculated and
% their corresponding filter coefficients are estimated.
left_npoints = length(left);
right_npoints = length(right);

left_ce = cepstral_envelope(left,lifter_order);
right_ce = cepstral_envelope(right,lifter_order);

left_celin = exp(left_ce(1:(length(left_ce)/2+1)));
right_celin = exp(right_ce(1:(length(left_ce)/2+1)));

left_mass = sum(left_celin);
right_mass = sum(right_celin);
left_nrg = norm(left_celin);
right_nrg = norm(right_celin);


norm_left = left_celin/left_mass;
norm_right = right_celin/right_mass;

T = transport_matrix_sparse(norm_left,norm_right);
T = T(T(:,3)~=0,:);

a_mat = zeros(n_steps,lpc_order+1);
interp_mat = zeros(n_steps,length(left_ce));
for i = 1:n_steps
    k = (i-1)/(n_steps-1);
    intermass = left_mass^(1-k)*right_mass^k;
    inter_npoints = (1-k)* left_npoints + k*right_npoints;
    interp_half = dtw_interpolation(norm_left,T(:,1),norm_right,T(:,2),k);
    interp_half = interp_half/sum(interp_half);
    interp = intermass*[interp_half;interp_half(end-1:-1:2)];
    interp_mat(i,:) = interp; 
    a_mat(i,:) = spectrum2lpc(interp,lpc_order,inter_npoints);
end

