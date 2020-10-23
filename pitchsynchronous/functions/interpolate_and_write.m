function interpolate_and_write(left_path,left_name,right_path,right_name, k, method)
    left_str = [left_path,'/',left_name];
    right_str = [right_path,'/',right_name];
    left_pk_str = [left_path,'pk/',left_name];
    right_pk_str = [right_path,'pk/',right_name];
    [right_signal,fs] = audioread(right_str);
    [left_signal,~] = audioread(left_str);
    win_tol = 0.20; %window length for analysis
    lpc_order = 20; %order of prediction polynomial
    lifter_order = 15; %order of cepstral lifter coefficients.
    disp('performing peak picking analysis on left signal')
    left_peaks = audioread(left_pk_str);
    left_peak_ind = find(left_peaks);
    l_mperiod = median(diff(left_peak_ind));
    %pslpc
    [left_F,left_env,l_samps] = ps_lpc(left_signal,left_peak_ind,fs,win_tol,lpc_order,lifter_order);

    disp('performing peak picking analysis on right signal')
    right_peaks = audioread(right_pk_str);
    right_peak_ind = find(right_peaks);
    r_mperiod = median(diff(right_peak_ind));
    %pslpc
    [right_F,right_env,r_samps] = ps_lpc(right_signal,right_peak_ind,fs,win_tol,lpc_order,lifter_order);    

    f_ratio = ((1/l_mperiod)^(1-k)* 1/r_mperiod^k)*l_mperiod;
    
    str = char(method);
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
    pth = ['data/',lower(str),'_interpolation/'];
    
    filename = [left_name,'_', right_name,'_', num2str(k), '.wav'];
    audiowrite([pth,filename],interpolation,fs)
end