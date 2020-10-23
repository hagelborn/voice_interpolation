function [sampmat,peakmat] = get_samps(path)
contents =dir(path);
samp_len = 0.04; %ms
fs = 16000;
samps = 2^nextpow2(round(fs*samp_len));
n_voices=size(contents,1)-2;
sampmat = zeros(n_voices,samps);
peakmat = zeros(n_voices,samps);
for i = 1:n_voices
    p = strcat(contents(i+2).folder,'/');
    p = strcat(p,contents(i+2).name);
    aud = audioread(p);
    [peaks] = find_peaks(aud(:,1),fs);
    half_len = round(length(aud)/2);
    sampmat(i,:) = aud(half_len+1:half_len + samps,1);
    peakmat(i,:) = peaks(half_len+1:half_len + samps);
end
end