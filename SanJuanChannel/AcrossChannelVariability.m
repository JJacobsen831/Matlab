clear;
addpath('/home/jjacob2/matlab/GSW/')
%Cross channel variation 
%Process pressure data with Godin Filter

%Load Datums
East = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrEAST_A.mat');
West = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrWEST.mat');
SampleTime = load('/home/jjacob2/matlab/SanJuanChannel/ProfileData/XChannelTimes.mat');

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
addpath('/home/jjacob2/matlab/GSW/')
%Cross channel variation 
%Process pressure data with Godin Filter

%Load Datums
East = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrEAST_A.mat');
West = load('/home/jjacob2/matlab/SanJuanChannel/MooringData/rbrWEST.mat');
SampleTime = load('/home/jjacob2/matlab/SanJuanChannel/ProfileData/XChannelTimes.mat');

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

%find nearest index where samples were taken
SampIDX = NaN(size(SampleTime.t));
for n = 1:length(SampIDX)
    SampIDX(n) = find(abs(Var.time - SampleTime.t(n))== min(abs(Var.time - SampleTime.t(n))));
end

% [FloodPks, FloodLocs] = findpeaks(Var.EastVarRes);
% [EbbPks, EbbLocs] = findpeaks(-Var.EastVarRes);

%compute spectra Define full width bin (not 8 as default)
ts = 3600;
fs = 1/ts;
[pxx,F] = pwelch(Var.VarDiff, length(Var.VarDiff),[],[], fs);

%compute linear regression dp/dt on dp/dy
X = [ones(length(diff(Var.EastVarRes)), 1) diff(Var.EastVarRes)];
b = X\Var.VarDiff(1:end-1);
Lin = X*b;
R2 = 1 - sum((Var.VarDiff(1:end-1) - Lin).^2)/sum((Var.VarDiff(1:end-1) - nanmean(Var.VarDiff(1:end-1))).^2);

%compute u_geo
g = 9.81;           %gravity
f = gsw_f(48.5);    %intertial frequency
L = 3.15*1000;      %channel width (m)
U_geo = g/f.*Var.VarDiff./L;

[pxxGeo, Fgeo] = pwelch(U_geo, length(U_geo),[],[],fs);

Ro = mean(abs(U_geo))/(f*L);

figure(1)
h1= subplot(5,1,1);
plot(Var.time, Var.EastVarRes,'LineWidth',2)
ylabel('[dbar]')
hold on;
scatter(SampleTime.t, Var.EastVarRes(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
set(gca,'XTickLabel',[]);
title('Bottom Pressure East', 'FontSize',18)
set(gca,'FontSize',18)

h2=subplot(5,1,2);
plot(Var.time, Var.WestVarRes,'LineWidth',2)
ylabel('[dbar]')
hold on;
scatter(SampleTime.t, Var.WestVarRes(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
set(gca,'XTickLabel',[]);
title('Bottom Pressure West ','FontSize',18)
set(gca,'FontSize',18)

h3=subplot(5,1,3);
plot(Var.time, Var.VarDiff, 'LineWidth',2)
ylabel('[dbar]')
hold on;
scatter(SampleTime.t, Var.VarDiff(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('Pressure Difference (East - West)','FontSize',18)
set(gca,'XTickLabel',[]);
yline(0);
set(gca,'FontSize',18)

h4=subplot(5,1,4);
plot(Var.time, U_geo, 'LineWidth',2)
ylabel('[m s^{-1}]')
hold on
scatter(SampleTime.t, U_geo(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('Along Channel Geostrophic Velocity','FontSize',18)
set(gca,'XTickLabel',[])
yline(0);
set(gca,'FontSize',18)

h5 = subplot(5,1,5);
plot(Var.time, cur, 'LineWidth',2)
ylabel('[m s^{-1}]')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('NOAA Predicted Velocity','FontSize',18)
datetick('x','mm-dd-hh')
yline(0);
set(gca,'FontSize',18)
linkaxes([h1, h2, h3,h4,h5],'x')

%currents at obs pressure time cm/s -> m/s
cur = noaa.vel(Ind)./100;

%find nearest index where samples were taken
SampIDX = NaN(size(SampleTime.t));
for n = 1:length(SampIDX)
    SampIDX(n) = find(abs(Var.time - SampleTime.t(n))== min(abs(Var.time - SampleTime.t(n))));
end

% [FloodPks, FloodLocs] = findpeaks(Var.EastVarRes);
% [EbbPks, EbbLocs] = findpeaks(-Var.EastVarRes);

%compute spectra Define full width bin (not 8 as default)
ts = 3600;
fs = 1/ts;
[pxx,F] = pwelch(Var.VarDiff, length(Var.VarDiff),[],[], fs);

%compute linear regression dp/dt on dp/dy
X = [ones(length(diff(Var.EastVarRes)), 1) diff(Var.EastVarRes)];
b = X\Var.VarDiff(1:end-1);
Lin = X*b;
R2 = 1 - sum((Var.VarDiff(1:end-1) - Lin).^2)/sum((Var.VarDiff(1:end-1) - nanmean(Var.VarDiff(1:end-1))).^2);

%compute u_geo
g = 9.81;           %gravity
f = gsw_f(48.5);    %intertial frequency
L = 3.15*1000;      %channel width (m)
U_geo = g/f.*Var.VarDiff./L;

[pxxGeo, Fgeo] = pwelch(U_geo, length(U_geo),[],[],fs);

Ro = mean(abs(U_geo))/(f*L);

figure(1)
h1= subplot(5,1,1);
plot(Var.time, Var.EastVarRes,'LineWidth',2)
ylabel('[N m^{-2}]')
hold on;
scatter(SampleTime.t, Var.EastVarRes(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
set(gca,'XTickLabel',[]);
title('Bottom Pressure East', 'FontSize',18)
set(gca,'FontSize',18)

h2=subplot(5,1,2);
plot(Var.time, Var.WestVarRes,'LineWidth',2)
ylabel('[N m^{-2}]')
hold on;
scatter(SampleTime.t, Var.WestVarRes(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
set(gca,'XTickLabel',[]);
title('Bottom Pressure West','FontSize',18)
set(gca,'FontSize',18)

h3=subplot(5,1,3);
plot(Var.time, Var.VarDiff, 'LineWidth',2)
ylabel('[N m^{-2}]')
hold on;
scatter(SampleTime.t, Var.VarDiff(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('Pressure Difference (East - West)','FontSize',18)
set(gca,'XTickLabel',[]);
yline(0);
set(gca,'FontSize',18)

h4=subplot(5,1,4);
plot(Var.time, U_geo, 'LineWidth',2)
ylabel('[m s^{-1}]')
hold on
scatter(SampleTime.t, U_geo(SampIDX),[],'r','filled')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('Along Channel Geostrophic Velocity','FontSize',18)
set(gca,'XTickLabel',[])
yline(0);
set(gca,'FontSize',18)


h5 = subplot(5,1,5);
plot(Var.time, cur, 'LineWidth',2)
ylabel('NOAA Velocity')
xlim([nanmin(Var.time+0.000001), nanmax(Var.time-0.000001)])
title('Along Channel Predicted Velocity','FontSize',18)
datetick('x','mm-dd-hh')
yline(0);
set(gca,'FontSize',18)
linkaxes([h1, h2, h3,h4,h5],'x')

figure(2); 
scatter(diff(Var.EastVarRes), Var.VarDiff(1:end-1))
hold on;
plot(diff(Var.EastVarRes),Lin)
xlabel('P_{t}')
ylabel('P_{y}')
xline(0); yline(0);
title('Time Derivative of Pressure vs Cross Channel Pressure gradient')
text(-0.4,0.035,['R^{2} = ' num2str(R2)])
text(-0.4,0.03, ['Slope = ', num2str(b(2))])
text(-0.4,0.025,['Int = ', num2str(b(1))])


figure(3)
loglog(1./F/3600,pxx,'LineWidth',2); 
set(gca,'xdir','reverse');
xline(12+25.2/60);
title('Spectra of Across Channel Pressure Difference','FontSize',18)
xlabel('Period (Hr)')
ylabel('Spectral Density')
text(10,10^1.5, 'M2 Tide (12.4 hrs)')
set(gca,'FontSize',18)

