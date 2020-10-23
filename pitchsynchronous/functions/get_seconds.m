function [] = get_seconds(s_path,t_path,t,gender)
contents =dir(s_path);
samp_len = 0.04; %ms

n_frames = round(t/samp_len);
fs = 16000;
frame_len = round(fs*samp_len);
n_voices=size(contents,1)-2;

for i = 1:n_voices
    p = strcat(contents(i+2).folder,'\');
    p = strcat(p,contents(i+2).name);
    [aud,fs] = audioread(p);
    pk = find_peaks(aud,fs);
    tot_wins = floor(length(aud)/frame_len);
    nrg_vec = zeros(tot_wins,1);
    for j = 1:tot_wins
        tot_wins(j) = var(aud(1+(j-1)*frame_len:j*frame_len));
    end
    o = ones(n_frames,1);
    s = conv(tot_wins,o,'valid');
    [~,idx] = max(s);
    n_aud = aud(1+(idx-1)*frame_len:(idx+n_frames-1)*frame_len);
    pk = pk(1+(idx-1)*frame_len:(idx+n_frames-1)*frame_len);
    aud_filename = strcat(t_path,'\');
    pk_filename = strcat(t_path,'pk\');
    mkdir(pk_filename);
    mkdir(aud_filename);
    nm = strcat(gender,int2str(i));
    nm = strcat(nm,'.wav');
    pk_filename = strcat(pk_filename,nm);
    aud_filename = strcat(aud_filename,nm);
    audiowrite(aud_filename,n_aud,fs);
    audiowrite(pk_filename,pk,fs);
end
end