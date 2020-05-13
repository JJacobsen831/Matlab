%Average seasonal rate of isopycnal deepening
clear;

%load station data 
filedir2 = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/';

TH04 = load([filedir2 'THL_DataRAW_TH04_May-2010_Oct-2017.mat']);
TH05 = load([filedir2 'THL_DataRAW_TH05_May-2010_Oct-2017.mat']);

%load time data
times = load([filedir2 'THL_timeComplete.mat']);
CruDate = times.time04;
ntime = length(CruDate);

Jdate = day(datetime(CruDate, 'ConvertFrom','datenum'),'dayofyear');
Ydate = year(datetime(CruDate, 'ConvertFrom','datenum'));



%compute density
TH04.rho = sw_pden(TH04.S04raw, TH04.T04raw, TH04.Pres04, 0);
TH05.rho = sw_pden(TH05.S05raw, TH05.T05raw, TH05.Pres05, 0);

%Reference density
%TH04
RefRhoTop04 = abs(TH04.rho - 1026);
RefRhoUP04 = abs(TH04.rho - 1026.25);
RefRhoDN04 = abs(TH04.rho - 1026.5);
%TH05
RefRhoTop05 = abs(TH05.rho - 1026);
RefRhoUP05 = abs(TH05.rho - 1026.25);
RefRhoDN05 = abs(TH05.rho - 1026.5);

%Depth of isopycnals
Z_UP04 = NaN(size(ntime)); Z_DN04 = Z_UP04;
Z_UP05 = Z_UP04; Z_DN05 = Z_UP04; Z_TP04 = Z_UP04; Z_TP05 = Z_UP04;
for n = 1:ntime
    Z_TP04(n) = TH04.Dep04(RefRhoTop04(:,n) == min(RefRhoTop04(:,n)));
    Z_UP04(n) = TH04.Dep04(RefRhoUP04(:,n) == min(RefRhoUP04(:,n)));
    Z_DN04(n) = TH04.Dep04(RefRhoDN04(:,n) == min(RefRhoDN04(:,n)));
    
    Z_TP05(n) = TH05.Dep05(RefRhoTop05(:,n) == min(RefRhoTop05(:,n)));
    Z_UP05(n) = TH05.Dep05(RefRhoUP05(:,n) == min(RefRhoUP05(:,n)));
    Z_DN05(n) = TH05.Dep05(RefRhoDN05(:,n) == min(RefRhoDN05(:,n)));
end

%transition dates
Tdate = find(Jdate > 181 & Jdate < 304);

%regression July through Oct
TrendTP05 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_TP05(Tdate)';
TrendUP05 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_UP05(Tdate)';
TrendDN05 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_DN05(Tdate)';

LineTP05 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendTP05;
LineUP05 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendUP05;
LineDN05 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendDN05;

TrendTP04 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_TP04(Tdate)';
TrendUP04 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_UP04(Tdate)';
TrendDN04 = [ones(length(Tdate), 1) Jdate(Tdate)]\Z_DN04(Tdate)';
LineTP04 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendTP04;
LineUP04 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendUP04;
LineDN04 = [ones(length(Tdate), 1) Jdate(Tdate)]*TrendDN04;


R2TP04 = 1- sum((Z_TP04(Tdate)' - LineTP04).^2)/sum((Z_TP04(Tdate) - mean(Z_TP04(Tdate))).^2);
R2UP04 = 1- sum((Z_UP04(Tdate)' - LineUP04).^2)/sum((Z_UP04(Tdate) - mean(Z_UP04(Tdate))).^2);
R2DN04 = 1- sum((Z_DN04(Tdate)' - LineDN04).^2)/sum((Z_DN04(Tdate) - mean(Z_DN04(Tdate))).^2);

R2TP05 = 1- sum((Z_TP05(Tdate)' - LineTP05).^2)/sum((Z_TP05(Tdate) - mean(Z_TP05(Tdate))).^2);
R2UP05 = 1- sum((Z_UP05(Tdate)' - LineUP05).^2)/sum((Z_UP05(Tdate) - mean(Z_UP05(Tdate))).^2);
R2DN05 = 1- sum((Z_DN05(Tdate)' - LineDN05).^2)/sum((Z_DN05(Tdate) - mean(Z_DN05(Tdate))).^2);


%TH05
subplot(3,2,1)
scatter(Jdate, Z_TP05)
hold on
plot(Jdate(Tdate),LineTP05)
title({'TH05', ['26.0 depth ', num2str(TrendTP05(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2TP05)]})
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])
ylim([0 200])
axis ij
subplot(3,2,3)
scatter(Jdate, Z_UP05)
hold on
plot(Jdate(Tdate),LineUP05)
title({['26.25 depth ', num2str(TrendUP05(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2UP05)]})
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])
ylim([0 200])
axis ij
subplot(3,2,5)
plot(Jdate(Tdate), LineDN05)
hold on
scatter(Jdate, Z_DN05)
title({['26.5 depth ', num2str(TrendDN05(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2DN05)]})
axis ij
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])    
ylim([0 200])

%TH04
subplot(3,2,2)
scatter(Jdate, Z_TP04)
hold on
plot(Jdate(Tdate),LineTP04)
title({'TH04', ['26.0 depth ', num2str(TrendTP04(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2TP04)]})
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])
ylim([0 200])
axis ij
subplot(3,2,4)
scatter(Jdate, Z_UP04)
hold on
plot(Jdate(Tdate),LineUP04)
title({'TH04', ['26.25 depth ', num2str(TrendUP04(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2UP04)]})
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])
ylim([0 200])
axis ij
subplot(3,2,6)
plot(Jdate(Tdate), LineDN04)
hold on
scatter(Jdate, Z_DN04)
title({['26.5 depth ', num2str(TrendDN04(2), 2), ' m day^{-1}'],...
    ['R^{2} = ', num2str(R2DN04)]})
axis ij
datetick('x','mmm')
xlim([min(Jdate) max(Jdate)])    
ylim([0 200])
print('RhoDepthTrend','-dpng','-r150')