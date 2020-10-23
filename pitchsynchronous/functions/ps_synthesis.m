function [interpolation] = ps_synthesis(signal,left_F,target_F,peaks,f_ratio)
% changes pitch of the signal using psola to pick out the pitch peaks. The
% short signal is then defiltered and the interpolated forman is added to the
% resampled residual.

%calculate the new median period of the signal
N = length(signal);
order = size(left_F,2)-1;

interpolation = zeros(N,1);

n_old_peaks = length(peaks);
n_new_peaks = floor(n_old_peaks*f_ratio);
new_peaks_ref = linspace(1,length(peaks),n_new_peaks);
new_peaks = zeros(n_new_peaks,1);
old_peaks = zeros(n_new_peaks,1);
%create first and second part of hamming windows used for lpc analysis and
%possibly overlap add


hann_in = @(n,N) 1/2 * (1 - cos((2*pi*n)/(2*N))); 
hann_out = @(n,N) 1/2 * (1 - cos((2*pi*(n+N))/(2*N)));
synthesis_periods = 2; %number of periods used for synthesis

for i = 1:n_new_peaks
    npr = new_peaks_ref(i);
    weight = npr-floor(npr);
    left = floor(npr);
    right = ceil(npr);
    new_peaks(i) = round(peaks(left)*(1-weight) + peaks(right)*weight);
    %save the closest peak index, with home made if statement.
    old_peaks(i) = left*(weight<1/2) + right*(weight>=1/2);
end
%start with no left periods in order to not break first iterations
pre_periods = synthesis_periods/2;
post_periods =synthesis_periods/2;
n_old_peaks = old_peaks(end);
windup = 0;
%save the state of the previous filter to reduce trancient behaviour.
f_state = zeros(order,1);
f_state2 = zeros(order,1);
for i = 1:n_new_peaks
    j = old_peaks(i);
    pre_periods = min([synthesis_periods/2, min([i,old_peaks(i)]-1)]);
    post_periods = min([synthesis_periods/2,min([n_new_peaks-i,n_old_peaks-j])]);
    
    a = left_F(j,:); %current filter
    b = target_F(j,:);
    
    %extract first and second period.
    pre_window = signal(peaks(j-pre_periods):peaks(j));
    post_window = signal(peaks(j)+(post_periods):(peaks(j+post_periods)));
    
    %extract residual of first and second period.
    [res_pre,f_state2] = filter(a,1,pre_window,f_state2);
    res_post = filter(a,1,post_window,f_state2);
    res = [res_pre;res_post];
    
    %calulate number of samples in pre and post window.
    pre_samps = peaks(j)-peaks(j-pre_periods)+1;
    post_samps = peaks(j+post_periods)-peaks(j);
    tot_samps = pre_samps+post_samps;
    
    %calculate number of samples in new pre and post windows.
    new_pre_samps = new_peaks(i)-new_peaks(i-pre_periods)+1;
    new_post_samps = new_peaks(i+post_periods)-new_peaks(i);
    new_samps = new_pre_samps+new_post_samps;
    
    ind = (0:(new_samps-1))*(tot_samps-1)/(new_samps-1)+1;
    %resampled_res = resample(res,new_samps,tot_samps);
    %resampled_res = interp1(res,ind)';
    resampled_res = interpft(res,new_samps);
    %resampled_res = sqrt(length(resampled_res)*var(res)/(var(resampled_res)*length(res)))*resampled_res;
    
%     
     [resampled_win1,f_state] = filter(1,b,resampled_res(1:new_pre_samps),f_state);
     resampled_win2 = filter(1,b,resampled_res(new_pre_samps+1:end),f_state);
     resampled_win = [resampled_win1 ; resampled_win2];

    %asym_hann = [hann_in(0:new_pre_samps, new_pre_samps), hann_out(1:new_post_samps, new_post_samps)]';
    asym_hann = [(1:new_pre_samps)/new_pre_samps, ((new_post_samps-1):-1:0)/new_post_samps]';
    interval = new_peaks(i-pre_periods):new_peaks(i+post_periods);
    
    interpolation(interval) = interpolation(interval) + resampled_win(:).*asym_hann(:);
end
end

