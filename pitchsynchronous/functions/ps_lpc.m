function [F_mat,env_mat,n_samps] = ps_lpc(signal,peaks,fs,win_tol,lpc_order,method,lifter_order)
% Returns the lpc filter matrix, F_mat, the envelope matrix, env_mat, and
% the number of samples used in the estimation of each of the envelopes.

n_peaks = numel(peaks);

N = nextpow2(fs*win_tol);                
env_mat =  zeros(n_peaks,2^(N));        % Matrix containing the envelopes
F_mat = zeros(n_peaks,lpc_order+1);     % Matrix containing the filters
samp_tol = round(fs*win_tol);   % number of samples in one frame
%matrix containing start and end of window used to calculate F at a given
%peak
n_samps = zeros(n_peaks,1);
for i = 1:n_peaks
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
    

    win = hann(pre_samps+post_samps+1);
    analysis_window = win.*signal(peaks(i-l_periods): peaks(i+r_periods));
    
    switch method
        case "TE" %True Envelope
            env = te(analysis_window,2,lifter_order,0);
            F_mat(i,:) = spectrum2lpc(env,lpc_order,length(analysis_window));
        case "CT" %CheapTrick
            tau = mean(diff(peaks(i-l_periods:i+r_periods))); % estimate the mean period in the current frame
            log_env = cheap_trick_envelope(analysis_window,tau);
            env = exp(log_env);
            F_mat(i,:) = spectrum2lpc(env,lpc_order,length(analysis_window));
        case "RL" %Rectangular lifter
            log_env = cepstral_envelope(analysis_window,lifter_order);
            env = exp(log_env);
            F_mat(i,:) = spectrum2lpc(env,lpc_order,length(analysis_window));
        case "periodogram" 
            F_mat(i,:) = lpc(analysis_winodw,lpc_order);
            env = freqz(1,F_mat(i,:),N,'whole');
    end
    env_mat(i,:) = env;
    n_samps(i) = length(analysis_window);
end