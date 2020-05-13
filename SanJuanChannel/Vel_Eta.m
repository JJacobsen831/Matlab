clear;
%tidal height and velocity
Tide = load('/home/jjacob2/matlab/SanJuanChannel/NOAA_Data/SCJ_Tide.mat');
load('/home/jjacob2/matlab/SanJuanChannel/NOAA_Data/noaa.mat');

%equilize time, same sample interval
STRT = find(noaa.time == Tide.time(1));

Vel = noaa.vel(STRT:end)./100;
Eta = Tide.eta;

[r, k] = xcorr(Vel,Eta,'Normalized');
Lag = k(abs(r) == max(abs(r)));
Lag_Hr = Lag.*(6/60);
rHR=r(r == max(r));
R2 = rHR*rHR;

X = [ones(length(Eta(Lag:end-1)), 1) Eta(Lag:end-1)];
b = X\Vel(1:end-Lag);
Lin = X*b;

scatter(Eta(Lag:end-1),Vel(1:end-Lag),[],'k','.')
hold on
plot(Eta(Lag:end-1),Lin,'r', 'LineWidth',2)
xlim([-0.75 2.75])
ylim([-0.8 0.8])
xlabel('Eta (m)')
ylabel('NOAA Velocity (m/s)')
title('Observed Tidal Height and Predicted Velocity')
text(-0.4,0.7, ['\eta lags NOAA Velocity by ' num2str(Lag_Hr), ' Hours'])
text(-0.4,0.6,['R^{2} = ' num2str(R2, 3)])
text(-0.4,0.5, ['Slope = ', num2str(b(2))])
text(-0.4,0.4,['Int = ', num2str(b(1))])

