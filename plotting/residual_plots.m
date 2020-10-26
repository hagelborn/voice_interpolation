mpath = 'data/16wav/male';
fpath = 'data/16wav/female';
[male_samps,male_peaks] = get_samps(mpath);
[female_samps,female_peaks] = get_samps(fpath);
all_samps = [male_samps;female_samps];
all_peaks = [male_peaks;female_peaks];
[n_samps,samp_len] = size(all_samps);
%%
fs = 16000;
max_hz = 1000;
min_hz = 70;
min_period = floor(fs/max_hz);
max_period = floor(fs/min_hz);

order = 20;
order2 =3;
alpha = 0.5;

normal_lpc_order = 12;
lpc_order = 100;
lifter_order = 20;

half_area = 5;
N = 16;
resolution = 2^N;
frequencies = ((1:resolution/2)-1)/(resolution/2-1)*fs/2000;

for i = 3:3
    samp = all_samps(i,:);
    peaks = all_peaks(i,:);
    tau = median(diff(find(peaks)));
    cte = exp(cheap_trick_envelope(samp,tau)); %cheap trick envelope
    tre = te(samp,2,lifter_order);           %true envelope
    le = exp(cepstral_envelope(samp,lifter_order)); %lifter envelope
    
    a_cte = spectrum2lpc(cte,lpc_order,samp_len);
    a_te = spectrum2lpc(tre,lpc_order,samp_len);
    a_le = spectrum2lpc(le,lpc_order,samp_len);
    a_lpc = lpc(samp,normal_lpc_order);
    
    res_cte = filter(a_cte,1,samp);
    res_cte = res_cte(samp_len/2:end);
    psd_cte = log(abs(fft(res_cte,resolution)));
    psd_cte = psd_cte(1:resolution/2);
    
    res_te = filter(a_te,1,samp);
    res_te = res_te(samp_len/2:end);
    psd_te = log(abs(fft(res_te,resolution)));
    psd_te = psd_te(1:resolution/2);
    
    res_le = filter(a_le,1,samp);
    res_le = res_le(samp_len/2:end);
    psd_le = log(abs(fft(res_le,resolution)));
    psd_le = psd_le(1:resolution/2);
    
    res_lpc = filter(a_lpc,1,samp);
    res_lpc = res_lpc(samp_len/2:end);
    psd_lpc = log(abs(fft(res_lpc,resolution)));
    psd_lpc = psd_lpc(1:resolution/2);
    
    
    
    figure(1)
    clf
    subplot(411)
    plot(res_lpc)
    ylim([-0.01,0.01])
    xlim([1,samp_len/2])
    xlabel('sample')
    ylabel('Amplitude')
    title('LPC')
    
    subplot(412)
    plot(res_le)
    ylim([-0.01,0.01])
    xlim([1,samp_len/2])
    xlabel('sample')
    ylabel('Amplitude')
    title('Rectangular lifter')
    
    subplot(413)
    plot(res_te)
    xlabel('sample')
    ylabel('Amplitude')
    ylim([-0.01,0.01])
    xlim([1,samp_len/2])
    title('True envelope')
    
    subplot(414)
    plot(res_cte)
    xlabel('sample')
    ylabel('Amplitude')
    ylim([-0.01,0.01])
    xlim([1,samp_len/2])
    title('Cheap trick')
    
    set(gcf,'Position',[100 100 800 800])
    %saveas(gcf,'figures/modeling/residuals/res','png')
    
    figure(2)
    clf
    subplot(411)
    plot(frequencies,psd_lpc)
    xlabel('Frequency [kHz]')
    ylabel('Log-amplitude')
    ylim([-10,0])
    title('LPC')
    
    subplot(412)
    plot(frequencies,psd_le)
    xlabel('Frequency [kHz]')
    ylabel('Log-amplitude')
    ylim([-10,0])
    title('Rectangular lifter')
    
    subplot(413)
    plot(frequencies,psd_te)
    xlabel('Frequency [kHz]')
    ylabel('Log-amplitude')
    ylim([-10,0])
    title('True envelope')
    
    subplot(414)
    plot(frequencies,psd_cte)
    xlabel('Frequency [kHz]')
    ylabel('Log-amplitude')
    ylim([-10,0])
    title('Cheap trick')
    set(gcf,'Position',[100 100 800 800])
    %saveas(gcf,'figures/modeling/residuals/spectra','png')
    
    w = waitforbuttonpress;
end