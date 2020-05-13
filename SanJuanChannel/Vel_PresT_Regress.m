clear;
addpath('/home/jjacob2/matlab/GSW/')
%compute and evaluate different regressions for V based on Pt

%Load Bottom pressure data
East = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrEAST_A.mat');
West = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrWEST.mat');

%Filter Data
Var = AppGodin(East.ctd.time, East.ctd.pr, West.ctd.time, West.ctd.pr);

%load NOAA Currents
load('/home/jjacob2/matlab/SanJuanChannel/NOAA_Data/noaa.mat')

%equalize time
Ind = NaN(size(Var.time));
for n = 1:length(Var.time)
    Idx = find(abs(Var.time(n) - noaa.time) == min(abs(Var.time(n) - noaa.time)));
    if (length(Idx) > 1)
        ID = Idx(1);
    else
        ID = Idx;
    end
    Ind(n) = ID;
end

%currents at obs pressure time cm/s -> m/s
cur = noaa.vel(Ind)./100;

Pt = diff(Var.EastVarRes);
%zero lag
% scatter(Var.VarDiff, cur)

%cross corr
[r, lags] = xcorr(Var.EastVarRes, cur, 'Normalized');
figure(2)
stem(lags,r)
MaxLag = lags(max(abs(r))==abs(r))
MaxR = r(max(abs(r))==abs(r));

LagPres = Var.EastVarRes(abs(MaxLag):end-1);
LagVel = cur(1:end-abs(MaxLag));

% Xlag = [ones(size(LagPres)), LagPres];
% B = Xlag\LagVel;
% LinLag = Xlag*B;


figure(1)
scatter(LagPres, LagVel,60, 'filled')
xlim([-2, 1.5])
title('Tidal Velocity Propagates as a Standing Wave','FontSize',18)
xlabel('Tidal Amplitude [dbar] (4 hour Lag)')
ylabel('NOAA Predicted Velocity')
grid on
set(gca,'FontSize',18)

% stem(lags(lags >=0),r(lags>=0))bb

% 0 lag for Pt and V_geo R2 = 0.591
%negative 1 lag, or lead by 1 hour -> pressure diff changes 1 hour before
%velocity change (r = 0.795 r^2 = 0.6321)

%regression at 1 hour lag Pt and noaa current
XL = [ones(length(Pt), 1) Pt];
bL = XL\cur(2:end);
LinL = XL*bL;
R2L = 1 - sum((cur(2:end) - LinL).^2)/sum((cur(2:end) - nanmean(cur(2:end))).^2);

%compute Vgeo
g = 9.81;           %gravity
f = gsw_f(48.5);    %intertial frequency
L = 3.15*1000;      %channel width (m)
V_geo = g/f.*Var.VarDiff./L;

[r_geo, lags_geo] = xcorr(Var.EastVarRes, V_geo, 'Normalized');
lags_geo(max(abs(r_geo)) == abs(r_geo))

%compute linear regression dp/dt on V_geo
b = XL\V_geo(1:end-1);
Lin = XL*b;
R2 = 1 - sum((V_geo(1:end-1) - Lin).^2)/sum((V_geo(1:end-1) - nanmean(diff(Var.EastVarRes))).^2);

figure(2)
%Pt vs Vel
scatter(Pt, cur(2:end),[],'b','.')
hold on;
%Px vs V_geo
scatter(Pt,V_geo(1:end-1),'r','.')
%Px vs Pt
% scatter(Pt,Var.VarDiff(1:end-1)./L,'r','.')
%fits
plot(Pt, LinL,'b')
plot(Pt,Lin,'r')
% ylim([-1 1])
xlabel('P_t')
ylabel('V (m/s)')
grid on;
legend('NOAA Velocity (k = -1)','V_{geo} (k = 0)','Location','southeast')

[rvel, lagsvel] = xcorr(V_geo, cur, 'Normalized');
figure(2)
stem(lagsvel,rvel)
MaxLag = lags(max(abs(rvel))==abs(rvel))
MaxR = rvel(max(abs(rvel))==abs(rvel));

figure(3)
scatter(V_geo(1:end-1),cur(2:end),60,'filled')
xlabel('NOAA Velocity (lead 1 hour)')
ylabel('V_{geo}')
grid on
text(-1,0.3,['R^2 = ', num2str(MaxR, 3)])

