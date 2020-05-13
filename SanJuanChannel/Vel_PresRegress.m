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

%zero lag
% scatter(Var.VarDiff, cur)

%cross corr
[r, lags] = xcorr(Var.VarDiff, cur, 'Normalized');
% stem(lags(lags >=0),r(lags>=0))bb

r(max(abs(r)) == abs(r))
%negative 1 lag, or lead by 1 hour -> pressure diff changes 1 hour before
%velocity change (r = 0.795 r^2 = 0.6321)

%regression at 1 hour lag
XL = [ones(length(Var.VarDiff(1:end-1)), 1) Var.VarDiff(1:end-1)];
bL = XL\cur(2:end);
LinL = XL*bL;
R2L = 1 - sum((cur(2:end) - LinL).^2)/sum((cur(2:end) - nanmean(cur(2:end))).^2);

%compute Vgeo
g = 9.81;           %gravity
f = gsw_f(48.5);    %intertial frequency
L = 3.15*1000;      %channel width (m)
V_geo = g/f.*Var.VarDiff./L;

%compute linear regression dp/dt on dp/dy
b = XL\diff(Var.EastVarRes);
Lin = XL*b;
R2 = 1 - sum((diff(Var.EastVarRes) - Lin).^2)/sum((diff(Var.EastVarRes) - nanmean(diff(Var.EastVarRes))).^2);

%Px vs Vel
scatter(Var.VarDiff(1:end-1)./L, cur(2:end),[],'b','.')
hold on;
%Px vs V_geo
plot(Var.VarDiff(1:end-1)./L,V_geo(1:end-1),'k')
%Px vs Pt
scatter(Var.VarDiff(1:end-1)./L,diff(Var.EastVarRes),'r','.')
%fits
plot(Var.VarDiff(1:end-1)./L, LinL,'b')
plot(Var.VarDiff(1:end-1)./L,Lin,'r')
ylim([-1 1])
xlabel('P_x')
ylabel('V (m/s)')
grid on;
legend('NOAA Velocity (k = -1)','V_{geo}','P_x','Location','southeast')

figure(2)
scatter(cur(2:end),V_geo(1:end-1))
xlabel('NOAA Velocity (k = -1)')
ylabel('V_{geo}')
grid on

