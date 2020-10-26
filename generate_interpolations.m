% Generates a set of intepolated voices between pairs of males and females
% and saves them. Audio files should be .wav at same sample frequency
% 

% Params to specifiy
interp_method = 'area'; % valid choices: 'area', 'lsf', 'rc' , 'omt' 
model_method = 'CT';     % valid choices: 'CT', 'TE', 'RL' for cheaptrick, true envelope and rectangular liftering respectively
male_path = 'data/male';
female_path = 'data/female';
num_pairs = 1;            % Nbr Male-female pairs
k_choice = [3, 5, 7]/10;  % Intepolation coefficients for each pair of interpolations, can be a vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%% Start of script %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_males = length(dir([male_path, '/*.wav']));   % This only works for UNIX systems, for windows use '\' instead
n_females = length(dir([female_path, '/*.wav']));
males = datasample(1:n_males,num_pairs,'Replace',false);
females = datasample(1:n_females,num_pairs,'Replace',false);

save_path = ['data/',interp_method,'_interpolation/'];
if ~exist(save_path, 'dir')
   mkdir(save_path);
end
for i = 1:num_pairs

    male_idx = males(i);
    male_name = ['male',int2str(male_idx),'.wav'];

    female_idx = females(i);
    female_name = ['female',int2str(female_idx),'.wav'];
    for w = 1:2
        if w == 1                       % Male 2 female
            left_path = male_path;
            left_name = male_name;
            right_path = female_path;
            right_name = female_name;
        else                            % Female 2 male
            right_path = male_path;
            right_name = male_name;
            left_path = female_path;
            left_name = female_name;
        end
       % Loops over the interpolation coefficients to generate interpolations at different steps    
        for j = 1:length(k_choice)
            k = k_choice(j);
            interpolate_and_write(left_path,left_name,right_path,right_name,k,interp_method,model_method,save_path);
        end
    end
end

function interpolate_and_write(left_path,left_name,right_path,right_name, k, interp_method, model_method, save_path)
    % Performs the interpolation
    left_str = [left_path,'/',left_name];
    right_str = [right_path,'/',right_name];

    [right_signal,fs] = audioread(right_str);
    [left_signal,~] = audioread(left_str);
    win_tol = 0.20; %window length for analysis
    lpc_order = 20; %order of prediction polynomial
    lifter_order = 15; %order of cepstral lifter coefficients.
    
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

    f_ratio = ((1/l_mperiod)^(1-k)* 1/r_mperiod^k)*l_mperiod;
    
    str = char(interp_method);
    switch lower(str)
        case 'lsf'
            [new_F] = lsf_interpolation(left_F,right_F,k);
        case 'area'
            [new_F] = area_interpolation(left_F,right_F,k);
        case 'omt'
            [new_F] = omt_interpolation(left_env,right_env,k,lpc_order,l_samps,r_samps);
        case 'rc'
            [new_F] = rc_interpolation(left_F,right_F,k);
        otherwise
            error('Not a valid method chosen. Valid options: omt, lsf, area, rc')
    end
    [interpolation] = ps_synthesis(left_signal,left_F,new_F,left_peak_ind,f_ratio);
    
    [~,left_name,~] = fileparts(left_name);
    [~,right_name,~] = fileparts(right_name);
    
    filename = [left_name,'_', right_name,'_', num2str(k), '.wav'];
    audiowrite([save_path,filename],interpolation,fs)
end
