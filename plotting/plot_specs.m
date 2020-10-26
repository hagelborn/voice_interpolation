% Plot audio waveforms and frequency content

nbr_people = 6;
malepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/data/wav/male';
femalepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/data/wav/female';
savepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/figs/';

mfiles = dir(malepath);
ffiles = dir(femalepath);
mmm = 3:length(mfiles);
fff = 3:length(ffiles);

mind = datasample(mmm,nbr_people,'Replace',false);
find = datasample(fff,nbr_people,'Replace',false);

N = 2000e-3;
mind= 18;
find = 3;
f01 = 33;
harm1 = [66, 98, 130, 163, 195, 227, 260, 292, 325, 357, 389, 422];
harm2 = [99, 148, 198, 247, 296, 345, 395, 444, 493, 542, 591, 640];
f02 = 50;

for i = 1:length(mind)
    j = mind(i);
    filename = [mfiles(j).folder,'/',mfiles(j).name];
    [aud,fs] = audioread(filename);
    snip = aud(10000:10000+round(N*fs));
    [spec,envelope,ff] = extract(snip,fs);
    
    [formpks, formlks] = findpeaks(envelope,'NPeaks',4);
    [~, harm1] = findpeaks(spec,'MinPeakDistance',f01-5,'NPeaks',25);
    harm1 = harm1(2:end);
    
    figure(i)
    plot(ff,spec)
    hold on 
    plot(ff,envelope,'LineWidth',2)
    plot(ff(f01),spec(f01),'rx');
    plot(ff(harm1),spec(harm1),'o')
    
    plot(ff(formlks),envelope(formlks),'s','MarkerEdgeColor','red','MarkerSize',10,'MarkerFaceColor',[1 .6 .6])
    
    xlabel('Frequency [kHz]')
    ylabel('Log-power')
    legend('Periodogram','Smooth spectral shape','f0','Overtones','Formant frequencies')
    title('Frequency content')
    hold off
    savename = [savepath,'male',int2str(j),'.png'];
    saveas(i,savename)
    close(i)
end

for i = 1:length(find)
    j = find(i);
    filename = [ffiles(j).folder,'/',ffiles(j).name];
    [aud,fs] = audioread(filename);
    snip = aud(end/2:end/2+round(N*fs));
    [spec,envelope,ff] = extract(snip,fs);
    
    [formpks, formlks] = findpeaks(envelope,'NPeaks',3);
    [~, harm2] = findpeaks(spec,'MinPeakDistance',f02-5,'NPeaks',25);
    harm2 = harm2(2:end);
    
    figure(i)
    plot(ff,spec)
    hold on 
    plot(ff,envelope,'LineWidth',2)
    plot(ff(f02),spec(f02),'rx');
    plot(ff(harm2),spec(harm2),'o')
    
    plot(ff(formlks),envelope(formlks),'s','MarkerEdgeColor','red','MarkerSize',10,'MarkerFaceColor',[1 .6 .6])
    
    xlabel('Frequency [kHz]')
    ylabel('Log-power')
    legend('Periodogram','Smooth spectral shape','f0','Overtones','Formant frequencies')
    title('Frequency content')
    hold off
    savename = [savepath,'female',int2str(j),'.png'];
    saveas(i,savename)
    close(i)
   
end




function [spec,envelope,ff] = extract(audio,fs)
    nfft = 2^12;
    lpc_order = 12;
    lifter_order = 15;
    
    win = hann(length(audio));
    windowed = win(:).*audio(:);
    
%     A = lpc(windowed,lpc_order);
%     [h,ff] = freqz(1,A,nfft/2);
%     envelope = log(abs(h));
    
    envelope = ceplope(windowed,nfft);
    envelope = exp(envelope).^2;
    envelope = log(envelope);
    ff = linspace(0,fs/2,nfft/2);
    ff = ff ./ 1000;
    
    pp = abs(fft(windowed,nfft));
    spec = pp(1:end/2).^2;
    spec = spec/ length(audio);
    spec = log(spec);
    
    [~, maxind] = max(spec); 
    diff = envelope(maxind) - spec(maxind);
    diff = mean(envelope) - mean(spec);
    envelope = envelope - diff;
    
end

function cep_env = ceplope(windowed,nfft)
    lifter_order = 20;
    dft = fft(windowed,nfft);
    fouri = log(abs(dft));
    cep = real(ifft(fouri));
    [lifter,pitcher] = lifter_pitcher(cep,lifter_order);
    cep_env = real(fft(lifter));
    cep_env = cep_env(1:end/2);
end

function peaks = peakpick(specs)
    [pks,lks] = findpeaks(specs,'NPeaks',11,'MinPeakHeight',-12);
    peaks = [lks(:) pks(:)];
end