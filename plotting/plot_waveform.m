% Plot signals in time


nbr_people = 3;
malepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/data/wav/male';
femalepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/data/wav/female';
savepath = '/Users/alexanderhagelborn/Documents/MATLAB/spec_j/figs/';

mfiles = dir(malepath);
ffiles = dir(femalepath);
mmm = 3:length(mfiles);
fff = 3:length(ffiles);

mind = datasample(mmm,nbr_people,'Replace',false);
find = datasample(fff,nbr_people,'Replace',false);

mind= 18;
find = 3;

N = 40e-3;
q = 4;

for i=1:length(mind)
    j = mind(i);
    filename = [mfiles(j).folder,'/', mfiles(j).name];
    [aud,fs] = audioread(filename);
    aud = resample(aud,1,q);
    fs = fs/q;
    snip = aud(end/2:end/2+round(N*fs));

    figure(i)
    t = (1:length(snip))./fs * 1000;
    plot(t,snip)
    xlim([0, N*1000]);
    xlabel('Time/ms')
    ylabel('Amplitude')
    title('Waveform')
    savename = [savepath,'timemale',int2str(j),'.png'];
    saveas(i,savename)
    close(i)
end

for i=1:length(find)
    j = find(i);
    filename = [ffiles(j).folder,'/', ffiles(j).name];
    [aud,fs] = audioread(filename);
    aud = resample(aud,1,q);
    fs = fs/q;
    snip = aud(end/2:end/2+round(N*fs));
    figure(i)
    t = (1:length(snip))./fs * 1000;
    plot(t,snip)
    xlim([0, N*1000]);
    xlabel('Time/ms')
    ylabel('Amplitude')
    title('Waveform')
    savename = [savepath,'timefemale',int2str(j),'.png'];
    saveas(i,savename)
    close(i)
end