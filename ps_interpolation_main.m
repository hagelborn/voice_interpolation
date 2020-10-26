% main interpolation script for trying out different methods
% Params
right_name = 'data/female/female1.wav';
left_name = 'data/male/male2.wav';
[right_signal,fs] = audioread(right_name);
[left_signal,~] = audioread(left_name);
win_tol = 0.8; %window length for analysis
lpc_order = 16; %order of prediction polynomial
lifter_order = 20; %order of cepstral lifter coefficients.
model_method = 'CT';

%%%%%%%%%%%%%%%%%% Start of script %%%%%%%%%%%%%%%%%%%%%%%%

disp('performing peak picking analysis on left signal')
left_peaks = find_peaks(left_signal,fs);
left_peak_ind = find(left_peaks);
l_mperiod = median(diff(left_peak_ind));
%pslpc
[left_F,left_env,l_samps] = ps_lpc(left_signal,left_peak_ind,fs,win_tol,lpc_order,model_method,lifter_order);

disp('performing peak picking analysis on right signal')
right_peaks = find_peaks(right_signal,fs);
right_peak_ind = find(right_peaks);
r_mperiod = median(diff(right_peak_ind));
%pslpc
[right_F,right_env,r_samps] = ps_lpc(right_signal,right_peak_ind,fs,win_tol,lpc_order,model_method,lifter_order);

%% Interpolation coefficient and method
k1 = 8/10;% interpolation factor
k2 = 8/10;
%[new_F] = area_interpolation(left_F,right_F,k1);
[new_F] = lsf_interpolation(left_F,right_F,k1);
%[new_F] = rc_interpolation(left_F,right_F,k1);
%[new_F] = omt_interpolation(left_env,right_env,k1,lpc_order,l_samps,r_samps);
%new_F(:,2:end) = 0;

f_ratio = ((1/l_mperiod)*(1-k2)+ 1/r_mperiod*k2)*l_mperiod;

[interpolation] = ps_synthesis(left_signal,left_F,new_F,left_peak_ind,f_ratio);

sound(interpolation,fs)
%% PLot new waveform
plot(interpolation)
%% Listen to source
sound(left_signal,fs)
%% Listen to target
sound(right_signal,fs)
%% Plot surface
figure
surf(left_env,'edgecolor','none');

