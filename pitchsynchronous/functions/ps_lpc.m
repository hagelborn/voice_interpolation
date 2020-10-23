function [F_mat,env_mat,n_samps] = ps_lpc(signal,peaks,fs,win_tol,lpc_order,lifter_order)
%returns the lpc filter matrix, F_mat, the envelope matrix, env_mat, and
%the number of samples used in the estimation of each of the envelopes.

n_peaks = numel(peaks);
hann_in = @(n,N) 1/2 * (1 - cos((2*pi*n)/(2*N))); 
hann_out = @(n,N) 1/2 * (1 - cos((2*pi*(n+N))/(2*N)));

N = nextpow2(fs*win_tol);
env_mat =  zeros(n_peaks,2^(N));
F_mat = zeros(n_peaks,lpc_order+1);
%%This needs to change in order to ensure that the window isnt to long.
samp_tol = round(fs*win_tol);
%matrix containing start and end of window used to calculate F at a given
%peak
n_samps = zeros(n_peaks,1);
for i = 1:n_peaks

    %disp(i)
    % perform some kind of lpc analysis here
    %find pulses in analysis
    l_periods  = 0; %number of left and right periods to include
    r_periods = 0;
    %add a right and left peak until the number of samples is greater than
    %the tolerance.
    while samp_tol > peaks(i + r_periods)-peaks(i-l_periods)
        %check edge cases
        l_bool = ((i-l_periods) ~= 1);
        r_bool = ((i+r_periods) ~= n_peaks);
        %iterate
        l_periods = l_periods + l_bool;
        r_periods = r_periods + r_bool;
    end
    
    pre_samps = peaks(i) - peaks(i-l_periods);
    post_samps = peaks(i + r_periods) - peaks(i);
    
    %create lpc analysis window
    %asym_hann = [hann_in(1:pre_samps, pre_samps), hann_out(1:post_samps, post_samps)]';
    win = hann(pre_samps+post_samps+1);
    analysis_window = win.*signal(peaks(i-l_periods): peaks(i+r_periods));
    
    tau = mean(diff(peaks(i-l_periods:i+r_periods)));
    ce = cheap_trick_envelope(analysis_window,tau);
    %ce = cepstral_envelope(analysis_window,lifter_order);
    %env = te(analysis_window,2,lifter_order,0);
    env = exp(ce);
    
    env_mat(i,:) = env;
    n_samps(i) = length(analysis_window);
    F = spectrum2lpc(env,lpc_order,length(analysis_window));
    F_mat(i,:) = F;
end