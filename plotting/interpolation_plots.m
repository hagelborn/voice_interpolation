%% load signals
[left,fs] = audioread('data/seconds/male/male1.wav');
[right] = audioread('data/seconds/female/female1.wav');
% create all interpolations.
win_dur = 0.04;
win_len = round(fs*win_dur);
left_win = left(1:win_len);
right_win = right(1:win_len);

lifter_order = 20;
lpc_order = 19;
%%
steps = 5;

left_win_d = left_win.*hann(numel(left_win));
right_win_d = right_win.*hann(numel(right_win));

a_left = cep_env_lpc(left_win_d,lpc_order,lifter_order);
a_right = cep_env_lpc(right_win_d.*hann(numel(right_win)),lpc_order,lifter_order);

resol = 2^10;
frequencies = (0:(resol-1))/(resol-1) *fs/2000;
close all
%area interpolation
a_mat_area = area_geodesic(a_left,a_right,steps);
area_response = amat2responsemat(a_mat_area,resol);
area_roots = polar_roots(a_mat_area);
%reflection coefficient interpolation
a_mat_rc = rc_geodesic(a_left,a_right,steps);
rc_response = amat2responsemat(a_mat_rc,resol);
rc_roots = polar_roots(a_mat_rc);

%optimal mass transport interpolation
[a_mat_omt,interp_mat] = omt_lpc_geodesic(left_win_d,right_win_d,lpc_order,lifter_order,steps);
omt_response = amat2responsemat(a_mat_omt,resol);
omt_roots = polar_roots(a_mat_omt);

%line spectral frequencies interpolation
a_mat_lsf = lsf_geodesic(a_left,a_right,steps);
lsf_response = amat2responsemat(a_mat_lsf,resol);
lsf_roots = polar_roots(a_mat_lsf);

for i = 1:steps
    tau = (i-1)/(steps-1);
    
    str = [strcat('\tau =',string(tau))];
    if tau == 1/2
        str = [str,'Reflection coefficient']
    end
    y_lim = [-4,5];
    x_lim = [0,frequencies(end)]; 
    figure(1)
    
    subplot(4,steps,i)
    %reflection coefficients
    plot(frequencies,log(abs(area_response(i,:))),'Linewidth',1.5)
    title(str)
    %xlabel('hz')
    if i == 1
        ylabel('log|H(z)|')
    end
    ylim(y_lim)
    xlim(x_lim)
    
    subplot(4,steps,steps+i)
    %area 
    plot(frequencies,log(abs(rc_response(i,:))),'Linewidth',1.5)
    %xlabel('hz')
    if i == 1 
        ylabel('log|H(z)|')
    end
    ylim(y_lim)
    xlim(x_lim)
    
    subplot(4,steps,2*steps+i)
    %line spectral frequencies
    plot(frequencies,log(abs(lsf_response(i,:))),'Linewidth',1.5)
    %xlabel('hz')
    if i == 1
        ylabel('log|H(z)|')
    end
    ylim(y_lim)
    xlim(x_lim)
    
    subplot(4,steps,3*steps+i)
    %optimal mass transport
    plot(frequencies,log(abs(omt_response(i,:))),'Linewidth',1.5)
    xlabel('Frequency[khz]')
    if i == 1
        ylabel('log|H(z)|')
    end
    ylim(y_lim)
    xlim(x_lim)
    
    subplot(4,steps,steps+3)
    title('Tube area')
    subplot(4,steps,2*steps+3)
    title('Line spectral frequencies')
    subplot(4,steps,3*steps+3)
    title('Optimal mass transport')
    %set(gcf,'PaperPositionMode','auto');
    set(gcf,'Position',[100 100 1400 800])
end
saveas(gcf,'figures/interpolation/grid','png')
%%
steps = 64;
close all
%area interpolation
a_mat_area = area_geodesic(a_left,a_right,steps);
area_response = amat2responsemat(a_mat_area,resol);
area_roots = polar_roots(a_mat_area);
%reflection coefficient interpolation
a_mat_rc = rc_geodesic(a_left,a_right,steps);
rc_response = amat2responsemat(a_mat_rc,resol);
rc_roots = polar_roots(a_mat_rc);

%optimal mass transport interpolation
[a_mat_omt,interp_mat] = omt_lpc_geodesic(left_win_d,right_win_d,lpc_order,lifter_order,steps);
omt_response = amat2responsemat(a_mat_omt,resol);
omt_roots = polar_roots(a_mat_omt);

%line spectral frequencies interpolation
a_mat_lsf = lsf_geodesic(a_left,a_right,steps);
lsf_response = amat2responsemat(a_mat_lsf,resol);
lsf_roots = polar_roots(a_mat_lsf);

cc = cool;
close all
figure %rc roots

for i = 2:steps-1
    polarplot(rc_roots(i,:),'x','Color',cc(i,:))
    hold on
end
for i = [1,steps]
    polarplot(rc_roots(i,:),'o','Color','k')
    hold on
end
pax = gca;
pax.ThetaAxisUnits = 'radians';
title('Poles in reflection coefficient interpolation')
saveas(gcf,'figures/interpolation/rc_roots','png')
figure %area roots

for i = 2:steps-1
    polarplot(area_roots(i,:),'x','Color',cc(i,:))
    hold on
end
for i = [1,steps]
    polarplot(area_roots(i,:),'o','Color','k')
    hold on
end
pax = gca;
pax.ThetaAxisUnits = 'radians';
title('Poles in area interpolation')
saveas(gcf,'figures/interpolation/area_roots','png')
figure%line spectral frequency roots

for i = 2:steps-1
    polarplot(lsf_roots(i,:),'x','Color',cc(i,:))
    hold on
end
for i = [1,steps]
    polarplot(lsf_roots(i,:),'o','Color','k')
    hold on
end
pax = gca;
pax.ThetaAxisUnits = 'radians';
title('Poles in line spectral frequency interpolation')
saveas(gcf,'figures/interpolation/lsf_roots','png')
figure %optimal mass transport roots

for i = 2:steps-1
    polarplot(omt_roots(i,:),'x','Color',cc(i,:))
    hold on
end
for i = [1,steps]
    polarplot(omt_roots(i,:),'o','Color','k')
    hold on
end
title('Poles in optimal mass transport interpolation')
saveas(gcf,'figures/interpolation/omt_roots','png')
%%
mag = abs(lsf_roots);
ang = angle(lsf_roots);
figure
for i = 2:steps-1
    plot(ang(i,:),mag(i,:),'x','Color',cc(i,:))
    hold on
end
for i = [1,steps]
    plot(ang(i,:),mag(i,:),'o','Color','k')
end
    

