%ispycnal slope
clear;

%load time
load('/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/THL_timeComplete');
load('/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/THL_OI10Bathy_GeoVel.mat');
time = time01; clear time01 time02 time03 time04 time05
Jdate = day(datetime(time, 'ConvertFrom','datenum'),'dayofyear');
Ydate = year(datetime(time, 'ConvertFrom','datenum'));

%load CTD data
filedir = '/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig9IsopycnalSlope/';
TH04 = load([filedir, 'THL_DataRAW_TH04_May-2010_Oct-2017.mat']);
TH05 = load([filedir, 'THL_DataRAW_TH05_May-2010_Oct-2017.mat']);

THL = load('/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/THL_DataOI10Bathy_May-2010_Oct-2017.mat');
depth = THL.depth;

temp = THL.Toib;
%depth
TH04_dep = TH04.Dep04;
TH05_dep = TH05.Dep05;

%compute density
TH04_rho = sw_pden(TH04.S04raw, TH04.T04raw, TH04.Pres04, 0);
TH05_rho = sw_pden(TH05.S05raw, TH05.T05raw, TH05.Pres05, 0);

%Remove data below 150m
R04 = NaN(1500,54); D04 = R04;
R05 = R04; D05 = R04;
for n = 1:size(TH04_dep,2)
    Den04 = TH04_rho(TH04_dep(:,n) <= 150, n);
    Dep04 = TH04_dep(TH04_dep(:,n) <= 150, n);
    n04 = length(Den04);
    R04(1:n04,n) = Den04;
    D04(1:n04,n) = Dep04;
    
    Den05 = TH05_rho(TH05_dep(:,n) <= 150, n);
    Dep05 = TH05_dep(TH05_dep(:,n) <= 150, n);
    n05 = length(Den05);
    R05(1:n05,n) = Den05;
    D05(1:n05,n) = Dep05;
end

Max04 = max(R04,[],1);
Max05 = max(R05,[],1);
RHO = 1026;
for r = 1:length(RHO)
    
    for n=1:54
        MaxDep04(r,n) = D04(abs(R04(:,n)-RHO(r)) == min(abs(R04(:,n)-RHO(r))));
        MaxDep05(r,n) = D05(abs(R05(:,n)-RHO(r)) == min(abs(R05(:,n)-RHO(r))));
        SLOPE(r,n) = (MaxDep05 - MaxDep04)/(sw_dist([41.05 41.05], [124.433 124.583])*1000);
    end
end

%time series of isopycnal depth
RHOs = [1026.0 1026.25];
MaxDep04 = NaN(1,54); MaxDep05 = MaxDep04; MaxDep04S = MaxDep04; MaxDep05S = MaxDep04;
for n=1:54
    
    MaxDep04(n) = D04(abs(R04(:,n)-RHOs(1)) == min(abs(R04(:,n)-RHOs(1))));
    MaxDep05(n) = D05(abs(R05(:,n)-RHOs(1)) == min(abs(R05(:,n)-RHOs(1))));
    
    MaxDep04S(n) = D04(abs(R04(:,n)-RHOs(2)) == min(abs(R04(:,n)-RHOs(2))));
    MaxDep05S(n) = D05(abs(R05(:,n)-RHOs(2)) == min(abs(R05(:,n)-RHOs(2))));
    
end
SLOPE = (MaxDep05 - MaxDep04)/(sw_dist([41.05 41.05], [124.433 124.583])*1000);

DiffRho04 = abs(MaxDep04 - MaxDep04S);
DiffRho05 = abs(MaxDep05 - MaxDep05S);

%sample GV along average depth of 26.0
AvgDepth = mean([MaxDep04; MaxDep05],1);
for n = 1:54
    GVdep(n) = nanmean(GeoVel(min(abs(depth - AvgDepth(n))) == abs(depth - AvgDepth(n)),:,n));
    Tdep(n) = nanmean(temp(min(abs(depth - AvgDepth(n))) == abs(depth - AvgDepth(n)),:,n));
end

scatter(Tdep, GVdep)

%Depth vs GV
figure(1)
subplot(2,3,1)
scatter(MaxDep04, GVdep)
% hold on
% scatter(MaxDep04(SLOPE < 0), GVdep(SLOPE < 0))
title('Depth of 26.0 TH04')
xlabel('Depth')
ylabel('GV (m/s)')

subplot(2,3,2)
scatter(MaxDep05, GVdep)
% hold on
% scatter(MaxDep05(SLOPE < 0), GVdep(SLOPE < 0))
title('Depth of 26.0 TH05')
xlabel('Depth')

%Slope vs GV
subplot(2,3,3)
scatter(SLOPE, GVdep)
% hold on
% scatter(SLOPE(MaxDep04 < 50 & SLOPE <0), GVdep(MaxDep04 < 50 & SLOPE < 0))
title('Slope of 26.0')
xlabel('Slope')

%PV proxy vs GV

subplot(2,2,3)
scatter(DiffRho04, GVdep)
xlabel('Depth b/t 26.0 & 26.5 TH04')
ylabel('GV')
%temp(26) vs GV
subplot(2,2,4)
scatter(Tdep, GVdep)
xlabel('Avg T along 26')
ylabel('GV')


figure(3)
subplot(3,1,1)
scatter(time,MaxDep04)
title('Depth of 26.0 \sigma_{\theta} at TH04')
ylabel('meters')
datetick('x','mm-yy')
axis ij

subplot(3,1,2)
scatter(time,MaxDep05)
title('Depth of 26.0 \sigma_{\theta} at TH05')
ylabel('meters')
datetick('x','mm-yy')
axis ij

subplot(3,1,3)
scatter(time,SLOPE)
title('Slope of 26.0 \sigma_{\theta} (TH05 - TH04)')
ylabel('meters/meters')
datetick('x','mm-yy')
hold on
line([1, 365], [0 0])
xlabel('Date')
jtext('Data: Trinidad Head Line 2010 to 2017')




DepDif = (MaxDep05 - MaxDep04)/(sw_dist([41.05 41.05], [124.433 124.583])*1000);   
figure(1)
subplot(3,1,1)
scatter(Jdate,MaxDep04)
title('Depth of 25.5 \sigma_{\theta} at TH04')
ylabel('meters')
datetick('x','mmm')
axis ij

subplot(3,1,2)
scatter(Jdate,MaxDep05)
title('Depth of 25.5 \sigma_{\theta} at TH05')
ylabel('meters')
datetick('x','mmm')
axis ij

subplot(3,1,3)
scatter(Jdate,DepDif)
title('Slope of 25.5 \sigma_{\theta} (TH05 - TH04)')
ylabel('meters/meters')
datetick('x','mmm')
hold on
line([1, 365], [0 0])
xlabel('Day of Year')
jtext('Data: Trinidad Head Line 2010 to 2017')


figure(2)
for r = 1:6
    subplot(6,1,r)
    scatter(Jdate, SLOPE(r,:))
    datetick('x','mmm')
        title(['Slope of ',num2str(RHO(r)), ' \sigma_{\theta} (TH05 - TH04)'])
    
    ylabel('meters/meters')
    hold on
    line([1, 365], [0 0])
    if (r < 6)
        set(gca,'YTickLabel',[]);
    else
        xlabel('Day of Year')
        
    end
end

print('IsopycnalSlope_depth','-dpng','-r150')

