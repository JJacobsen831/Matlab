clear all; close all;
%load DO in umol
filedir = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_DO/';
THLDO04 = load([filedir 'TH04_DOumol.mat']);
DO04=THLDO04.DO;
THLDO05 = load([filedir 'TH05_DOumol.mat']);
DO05=THLDO05.DO;
%load density 
filedir2 = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/';
matfile3 = 'TH04_dataComplete.mat';
TH04 = load([filedir2 matfile3]);
matfile4 = 'TH05_dataComplete.mat';
TH05 = load([filedir2 matfile4]);
Sal04 = TH04.sal;
Temp04 = TH04.temp;
Pres04 = TH04.pres;
Den04 = sw_pden(Sal04, Temp04, Pres04, 1);
Ptemp04 = sw_ptmp(Sal04, Temp04, Pres04,1);
% AOU04 = aou(Sal04, Temp04,DO04);
Sal05 = TH05.sal;
Temp05 = TH05.temp;
Pres05 = TH05.pres;
Den05 = sw_pden(Sal05, Temp05, Pres05,1);
Ptemp05 = sw_ptmp(Sal05,Temp05,Pres05,1);
% AOU05 = aou(Sal05,Temp05,DO05);
times = load([filedir2 'THL_timeComplete.mat']);
CruDate = times.time04;
time=CruDate;

Den04id = abs(Den04-1026.5);
Den05id = abs(Den05-1026.5);
TH04_26_5_DO = nan*ones(length(Den04(1,:)),1);
TH05_26_5_DO = TH04_26_5_DO;
% TH04_26_5_AOU = TH04_26_5_DO;
% TH05_26_5_AOU = TH05_26_5_DO;
for n=1:length(Den04(1,:))
   idx04 = find(Den04id(:,n) == min(Den04id(:,n)));
   TH04_26_5_DO(n) = DO04(idx04,n);
%    TH04_26_5_AOU(n) = AOU04(idx04,n);
   idx05 = find(Den05id(:,n) == min(Den05id(:,n)));
   TH05_26_5_DO(n) = DO05(idx05,n);
%    TH05_26_5_AOU(n) = AOU05(idx05,n);
   %TH04_DenBinCheck(n) = Den04(idx04,n);
end
TH04_26_5_DO = TH04_26_5_DO';
TH05_26_5_DO = TH05_26_5_DO';
%compute GV clim
THL = load([filedir2 'THL_MoClimOI10_May-2010_Oct-2017.mat']);
load([filedir2 'THL_LonOI.mat']);
load([filedir2 'THL_bathy.mat']);
bathy = th_bathy.bathy;
GV = THL.GVclim;
Den = THL.Dclim;
dens = abs(Den-1026.5);
GV265 = nan*ones(76,12);
Den265 = GV265;
for t=1:12
   for l=1:39
       idx = find(dens(:,l,t)==min(dens(:,l,t)));
       GV265(l,t) = GV(idx,l,t);
       Den265(l,t) = Den(idx,l,t);
   end
end
GV_265clim = nanmean(GV265,1);
%PV data from CTD casts

TH04 = load([filedir2 'THL_DataRAW_TH04_May-2010_Oct-2017.mat']);
TH05 = load([filedir2 'THL_DataRAW_TH05_May-2010_Oct-2017.mat']);

%TH04
T04 = TH04.T04raw;
S04 = TH04.S04raw;
P04 = TH04.Pres04;
%DO04 = TH04.DO04raw;
Dep04 = TH04.Dep04;
%TH05
T05 = TH05.T05raw;
S05 = TH05.S05raw;
%DO05 = TH05.DO05raw;
P05 = TH05.Pres05;
Dep05 = TH05.Dep05;
%compute potential desity
Den04 = sw_pden(S04,T04,P04, 1);
Den04 = Den04-1000;
Den05 = sw_pden(S05,T05,P05, 1);
Den05 = Den05-1000;
%find 26.5 and 26.25 isopycnals
ref1 = 26.5;
ref2 = 26.25;
dif1_04 = abs(Den04-ref1);
dif2_04 = abs(Den04-ref2);
dif1_05 = abs(Den05-ref1);
dif2_05 = abs(Den05-ref2);
ntime = length(Den05(1,:));
TH04_26_5 = nan*ones(1,ntime);
TH04_26_25 = TH04_26_5; TH05_26_5=TH04_26_5; TH05_26_25 = TH04_26_5;
%find index of 26.5 and 26.25 isopycnals
for n=1:ntime
    TH04_26_5(n)=find(dif1_04(:,n)==min(dif1_04(:,n)));
    TH04_26_25(n)=find(dif2_04(:,n)==min(dif2_04(:,n)));
    TH05_26_5(n)=find(dif1_05(:,n)==min(dif1_05(:,n)));
    TH05_26_25(n)=find(dif2_05(:,n)==min(dif2_05(:,n)));
    
end

TH04_CU_den=nan*ones(1,ntime);
TH04_26_25dep=TH04_CU_den;
TH04_26_5dep=TH04_CU_den;
TH04_26_5_Temp=TH04_CU_den;
TH04_26_5_Sal=TH04_CU_den;
TH05_CU_den=TH04_CU_den;
TH05_26_25dep=TH04_CU_den;
TH05_26_5dep=TH04_CU_den;
TH05_26_5_Temp=TH04_CU_den;
TH05_26_5_Sal=TH04_CU_den;
for n=1:ntime
    TH04_CU_den(n) = Den04(TH04_26_5(n),n);
    TH04_26_25dep(n) = Dep04(TH04_26_25(n),n);
    TH04_26_5dep(n) = Dep04(TH04_26_5(n),n);
    TH04_26_5_Temp(n) = T04(TH04_26_5(n),n);
    TH04_26_5_Sal(n) = S04(TH04_26_5(n),n);
    TH05_CU_den(n) = Den05(TH05_26_5(n),n);
    TH05_26_25dep(n) = Dep05(TH05_26_25(n),n);
    TH05_26_5dep(n) = Dep05(TH05_26_5(n),n);
    TH05_26_5_Temp(n) = T05(TH05_26_5(n),n);
    TH05_26_5_Sal(n) = S05(TH05_26_5(n),n);
end
TH04_DZ = TH04_26_5dep - TH04_26_25dep;
TH05_DZ = TH05_26_5dep - TH05_26_25dep;

%TH05_26_5_DO = DO05(TH05_26_5);
%compute PV
f= 2*7.2921150e-5*sind(41.03);
g= 9.80665;
AveDoi = [Den04 Den05];
rho0 = nanmean(nanmean(AveDoi))+1000;
Drho = 0.25;
TH04_PV = f*(g/rho0).*(Drho./TH04_DZ);
TH05_PV = f*(g/rho0).*(Drho./TH05_DZ);
%compute AOU
% TH05_PTemp = sw_ptmp(TH05_26_5_Sal, TH05_26_5_Temp, TH05_26_5dep,1);
% TH05_AOU = TH05_26_5_AOU';%aou(TH05_26_5_Sal, TH05_PTemp, TH05_26_5_DO);
% TH04_PTemp = sw_ptmp(TH04_26_5_Sal, TH04_26_5_Temp, TH04_26_5dep,1);
% TH04_AOU = TH04_26_5_AOU';%aou(TH04_26_5_Sal, TH04_PTemp, TH04_26_5_DO);
% average TH04 and TH05
% for n=1:ntime
%     UC_Z5(n) = nanmean([TH04_26_5dep(n) TH05_26_5dep(n)]);
%     UC_Z25(n) = nanmean([TH04_26_25dep(n) TH05_26_25dep(n)]);
%     UC_PV(n) = nanmean([TH04_PV(n) TH05_PV(n)]);
%     UC_Temp(n) = nanmean([TH04_26_5_Temp(n) TH05_26_5_Temp(n)]);
%     UC_Sal(n) = nanmean([TH04_26_5_Sal(n) TH05_26_5_Sal(n)]);
%     UC_DO(n) = nanmean([TH04_26_5_DO(n) TH05_26_5_DO(n)]);
%     UC_AOU(n) = nanmean([TH04_26_5_AOU(n) TH05_26_5_AOU(n)]);
% end
% save('THL_Undercurrent_TimeSeries','UC_Z5', 'UC_Z25', 'UC_PV', 'UC_Temp',...
%     'UC_Sal','UC_DO','UC_AOU');
% compile monthly climatology
% TH04_AOU = TH04_26_5_AOU';
% TH05_AOU = TH05_26_5_AOU';
year = 2010:2017; nyear = length(year);
month = 1:12; nmonth = length(month);
TH04_Z5mo =nan*ones(nmonth, nyear, 2); 
TH04_Z25mo = TH04_Z5mo; 
TH04_DZmo = TH04_Z5mo; 
TH04_PVmo= TH04_Z5mo;
TH04_Tmo = TH04_Z5mo;
TH04_Smo = TH04_Z5mo;
TH04_DOmo = TH04_Z5mo;
% TH04_AOUmo = TH04_Z5mo;
%
TH05_Z5mo= TH04_Z5mo; 
TH05_Z25mo= TH04_Z5mo; 
TH05_DZmo= TH04_Z5mo;
TH05_PVmo= TH04_Z5mo;
TH05_Tmo = TH04_Z5mo;
TH05_Smo = TH04_Z5mo;
TH05_DOmo = TH04_Z5mo;
% TH05_AOUmo = TH04_Z5mo;
time=CruDate;
for n = 1:nyear
  for m = 1:nmonth
    if m ~= 12
      itime = find(time >= datenum(year(n),m,1) & ...
		time < datenum(year(n),m+1,1));
    else
      itime = find(time >= datenum(year(n),12,1) & ...
		time <= datenum(year(n),12,31));
    end
if ~isempty(itime)  
      if length(itime) > 1
          TH04_Z5mo(m,n,1) = TH04_26_5dep(:,itime(1));
          TH04_Z5mo(m,n,2) = TH04_26_5dep(:,itime(2));
          TH04_Z25mo(m,n,1) = TH04_26_25dep(:,itime(1));
          TH04_Z25mo(m,n,2) = TH04_26_25dep(:,itime(2));
          TH04_DZmo(m,n,1) = TH04_DZ(:,itime(1));
          TH04_DZmo(m,n,2) = TH04_DZ(:,itime(2));
          TH04_PVmo(m,n,1) = TH04_PV(:,itime(1));
          TH04_PVmo(m,n,2) = TH04_PV(:,itime(2));
          TH04_Tmo(m,n,1) = TH04_26_5_Temp(:,itime(1));
          TH04_Tmo(m,n,2) = TH04_26_5_Temp(:,itime(2));
          TH04_Smo(m,n,1) = TH04_26_5_Sal(:,itime(1));
          TH04_Smo(m,n,2) = TH04_26_5_Sal(:,itime(2));
          TH04_DOmo(m,n,1) = TH04_26_5_DO(:,itime(1));
          TH04_DOmo(m,n,2) = TH04_26_5_DO(:,itime(2));
%           TH04_AOUmo(m,n,1) = TH04_AOU(:,itime(1));
%           TH04_AOUmo(m,n,2) = TH04_AOU(:,itime(2));
          %
          TH05_Z5mo(m,n,1) = TH05_26_5dep(:,itime(1));
          TH05_Z5mo(m,n,2) = TH05_26_5dep(:,itime(2));
          TH05_Z25mo(m,n,1) = TH05_26_25dep(:,itime(1));
          TH05_Z25mo(m,n,2) = TH05_26_25dep(:,itime(2));
          TH05_DZmo(m,n,1) = TH05_DZ(:,itime(1));
          TH05_DZmo(m,n,2) = TH05_DZ(:,itime(2));
          TH05_PVmo(m,n,1) = TH05_PV(:,itime(1));
          TH05_PVmo(m,n,2) = TH05_PV(:,itime(2));
          TH05_Tmo(m,n,1) = TH05_26_5_Temp(:,itime(1));
          TH05_Tmo(m,n,2) = TH05_26_5_Temp(:,itime(2));
          TH05_Smo(m,n,1) = TH05_26_5_Sal(:,itime(1));
          TH05_Smo(m,n,2) = TH05_26_5_Sal(:,itime(2));
          TH05_DOmo(m,n,1) = TH05_26_5_DO(:,itime(1));
          TH05_DOmo(m,n,2) = TH05_26_5_DO(:,itime(2));
%           TH05_AOUmo(m,n,1) = TH05_AOU(:,itime(1));
%           TH05_AOUmo(m,n,2) = TH05_AOU(:,itime(2));
      else
          TH04_Z5mo(m,n,1) = TH04_26_5dep(:,itime(1));
          TH04_Z25mo(m,n,1) = TH04_26_25dep(:,itime);
          TH04_DZmo(m,n,1) = TH04_DZ(:,itime);
          TH04_PVmo(m,n,1) = TH04_PV(:,itime);
          TH04_Tmo(m,n,1) = TH04_26_5_Temp(:,itime);
          TH04_Smo(m,n,1) = TH04_26_5_Sal(:,itime);
          TH04_DOmo(m,n,1) = TH04_26_5_DO(:,itime);
%           TH04_AOUmo(m,n,1) = TH04_AOU(:,itime);
          %
          TH05_Z5mo(m,n,1) = TH05_26_5dep(:,itime);
          TH05_Z25mo(m,n,1) = TH05_26_25dep(:,itime);
          TH05_DZmo(m,n,1) = TH05_DZ(:,itime);
          TH05_PVmo(m,n,1) = TH05_PV(:,itime);
          TH05_Tmo(m,n,1) = TH05_26_5_Temp(:,itime);
          TH05_Smo(m,n,1) = TH05_26_5_Sal(:,itime);
          TH05_DOmo(m,n,1) = TH05_26_5_DO(:,itime);
%           TH05_AOUmo(m,n,1) = TH05_AOU(:,itime);
              end

      clear itime

    else
      continue
    end

  end
end


TH04_Z5clim = squeeze(nanmean(TH04_Z5mo,2));
TH04_Z5clim = nanmean(TH04_Z5clim,2);
TH04_Z25clim = squeeze(nanmean(TH04_Z25mo,2));
TH04_Z25clim = nanmean(TH04_Z25clim,2);
TH04_DZclim = squeeze(nanmean(TH04_DZmo,2));
TH04_DZclim = nanmean(TH04_DZclim,2);
TH04_PVclim = squeeze(nanmean(TH04_PVmo,2));
TH04_PVclim = nanmean(TH04_PVclim,2);
TH04_Tclim = squeeze(nanmean(TH04_Tmo,2));
TH04_Tclim = nanmean(TH04_Tclim,2);
TH04_Sclim = squeeze(nanmean(TH04_Smo,2));
TH04_Sclim = nanmean(TH04_Sclim,2);
TH04_DOclim = squeeze(nanmean(TH04_DOmo,2));
TH04_DOclim = nanmean(TH04_DOclim,2);
% TH04_AOUclim = squeeze(nanmean(TH04_AOUmo,2));
% TH04_AOUclim = nanmean(TH04_AOUclim,2);
%
TH05_Z5clim = squeeze(nanmean(TH05_Z5mo,2));
TH05_Z5clim = nanmean(TH05_Z5clim,2);
TH05_Z25clim = squeeze(nanmean(TH05_Z25mo,2));
TH05_Z25clim = nanmean(TH05_Z25clim,2);
TH05_DZclim = squeeze(nanmean(TH05_DZmo,2));
TH05_DZclim = nanmean(TH05_DZclim,2);
TH05_PVclim = squeeze(nanmean(TH05_PVmo,2));
TH05_PVclim = nanmean(TH05_PVclim,2);
TH05_Tclim = squeeze(nanmean(TH05_Tmo,2));
TH05_Tclim = nanmean(TH05_Tclim,2);
TH05_Sclim = squeeze(nanmean(TH05_Smo,2));
TH05_Sclim = nanmean(TH05_Sclim,2);
TH05_DOclim = squeeze(nanmean(TH05_DOmo,2));
TH05_DOclim = nanmean(TH05_DOclim,2);
% TH05_AOUclim = squeeze(nanmean(TH05_AOUmo,2));
% TH05_AOUclim = nanmean(TH05_AOUclim,2);
% compute anomally 
TH04_Z5an = nan*ones(nmonth, 1);
TH04_Z25an = TH04_Z5an;
TH04_DZan = TH04_Z5an;
TH04_PVan = TH04_Z5an;
TH04_Tan = TH04_Z5an;
TH04_San  = TH04_Z5an;
TH04_DOan = TH04_Z5an;
%
TH05_Z5an = TH04_Z5an;
TH05_Z25an =TH04_Z5an;
TH05_DZan = TH04_Z5an;
TH05_PVan = TH04_Z5an;
TH05_Tan = TH04_Z5an;
TH05_San= TH04_Z5an;
TH05_DOan= TH04_Z5an;
MON = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' ...
    'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};
for n = 1:ntime
    A=datestr(time(n));
    mnth = A(4:6);
    for m=1:nmonth
        if strcmp(char(MON(m)),mnth) == 1
            I=m;
        else
            continue
        end
        TH04_Z5an(n) = TH04_26_5dep(n)-TH04_Z5clim(I);
        TH04_Z25an(n) = TH04_26_25dep(n)-TH04_Z25clim(I);
        TH04_DZan(n) = TH04_DZ(n)-TH04_DZclim(I);
        TH04_PVan(n) = TH04_PV(n)-TH04_PVclim(I);
        TH04_Tan(n) = TH04_26_5_Temp(n)-TH04_Tclim(I);
        TH04_San(n) = TH04_26_5_Sal(n)-TH04_Sclim(I);
        TH04_DOan(n) = TH04_26_5_DO(n)-TH04_DOclim(I);
        %
        TH05_Z5an(n) = TH05_26_5dep(n)-TH05_Z5clim(I);
        TH05_Z25an(n) = TH05_26_25dep(n)-TH05_Z25clim(I);
        TH05_DZan(n) = TH05_DZ(n)-TH05_DZclim(I);
        TH05_PVan(n) = TH05_PV(n)-TH05_PVclim(I);
        TH05_Tan(n) = TH05_26_5_Temp(n)-TH05_Tclim(I);
        TH05_San(n) = TH05_26_5_Sal(n)-TH05_Sclim(I);
        TH05_DOan(n) = TH05_26_5_DO(n)-TH05_DOclim(I);
    end
    clear I
end


PV_TH04_DJF = nanmean([TH04_PVclim(1) TH04_PVclim(3) TH04_PVclim(12)]);
PV_TH05_DJF = nanmean([TH05_PVclim(1) TH05_PVclim(3) TH05_PVclim(12)]);
PV_DJF_Change = PV_TH04_DJF-PV_TH05_DJF;

PV_TH04_JJA = nanmean([TH04_PVclim(6) TH04_PVclim(7) TH04_PVclim(8)]);
PV_TH05_JJA = nanmean([TH05_PVclim(6) TH05_PVclim(7) TH05_PVclim(8)]);
PV_JJA_Change = PV_TH04_JJA-PV_TH05_JJA;

% plot climatology 
% TH04
minPV = 3.7e-9; maxPV = 2.3e-8;
minPVclim = 4.5e-9; maxPVclim = 1.05e-8;
minPVa = -4.0e-9; maxPVa = 1.4e-8;
minZ = 25; maxZ = 160;
minDZ = 25; maxDZ = 55;
DateName = {'Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; ...
    'Sep'; 'Oct'; 'Nov'; 'Dec'};

TH04_TclimAn = TH04_Tclim; %-nanmean(TH04_Tclim);
TH04_SclimAn = TH04_Sclim; %-nanmean(TH04_Sclim);
TH04_DOclimAn = TH04_DOclim; %-nanmean(TH04_DOclim);
TH05_TclimAn = TH05_Tclim; % -nanmean(TH05_Tclim);
TH05_SclimAn = TH05_Sclim; %-nanmean(TH05_Sclim);
TH05_DOclimAn = TH05_DOclim; % -nanmean(TH05_DOclim);
for n=1:length(TH04_DOclimAn)
    Ave_TclimAn(n) = nanmean([TH04_TclimAn(n) TH05_TclimAn(n)]);
    Ave_SclimAn(n) = nanmean([TH04_SclimAn(n) TH05_SclimAn(n)]);
    Ave_DOclimAn(n) = nanmean([TH04_DOclimAn(n) TH05_DOclimAn(n)]);
%     Ave_AOUclimAn(n) = nanmean([TH04_AOUclim(n) TH05_AOUclim(n)]);
    Ave_26_5_dep(n) = nanmean([TH04_Z5clim(n) TH05_Z5clim(n)]);
    Ave_26_25dep(n) = nanmean([TH04_Z25clim(n) TH05_Z25clim(n)]);
    Ave_DZ(n) = nanmean([TH04_DZclim(n) TH05_DZclim(n)]);
    Ave_PV(n) = nanmean([TH04_PVclim(n) TH05_PVclim(n)]);
end
%  save('THL_Undercurrent_Climatology', 'Ave_TclimAn', 'Ave_SclimAn',...
%      'Ave_DOclimAn', 'Ave_AOUclimAn', 'Ave_26_5_dep' ,'Ave_26_25dep',...
%      'Ave_DZ', 'Ave_PV')
subplot(4,1,4)
plot(month, Ave_TclimAn, 'k')
ylim([7.5 8])
set(gca, 'XLim',[1 12])
set(gca, 'XTick', (1:1:12))
set(gca, 'XTick', (1:1:12),'xticklabel',[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '])
title('T_{26.5 \sigma_{\theta}}')
ylabel('^{\circ}C')

subplot(4,1,2)
plot(month, GV_265clim,'k')
set(gca, 'XLim',[1 12])
set(gca, 'XTick', (1:1:12))
set(gca, 'XTick', (1:1:12),'xticklabel',[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '])
title('V_{26.5 \sigma_{\theta}}')
ylim([-0.1 0.2]);
ylabel('m s^{-1}')

subplot(4,1,1)
plot(month, Ave_26_25dep, 'k')
axis ij
title('Z_{\sigma_{\theta} = 26.25, 26.5}')
ylabel('Depth (m)')
xlim([1 12])
ylim([50 300])
hold on 
plot(month, Ave_26_5_dep,'k')
set(gca, 'XLim',[1 12])
set(gca, 'XTick', (1:1:12))
set(gca, 'XTick', (1:1:12),'xticklabel',[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '])

subplot(4,1,4)
plot(month, Ave_PV,'k')
set(gca, 'XLim',[1 12])
set(gca, 'XTick', (1:1:12))
set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
xlim([1 12])
ylim([2e-9 4.5e-9])
title('Background PV between \sigma_{\theta} = 26.25, 26.5')
ylabel('s^{-3}');
xlabel('Month')
% 
% 
% subplot(4,1,3)
% plot(month, Ave_DOclimAn)
% ylim([80 125])
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% title('DO Climatology along 26.5 \sigma_{\theta}')
% ylabel('umol/kg')
% 
% subplot(4,1,4)
% plot(month, Ave_AOUclimAn)
% ylim([160 215])
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% title('AOU Climatology along 26.5 \sigma_{\theta}')
% ylabel('umol/kg')
% 
% %print('Fig_CU_Hydro','-dpng','-r300')
% figure(2)
% subplot(4,1,3)
% plot(month, Ave_26_25dep, '--k')
% axis ij
% title('Depth of \sigma_{\theta} = 26.25, 26.5')
% ylabel('Depth (m)')
% xlim([1 12])
% ylim([50 300])
% hold on 
% plot(month, Ave_26_5_dep,'k')
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% hold off
% subplot(4,1,2)
% plot(month, Ave_DZ)
% ylabel('Layer depth (m)')
% xlim([1 12])
% ylim([50 100])
% title('Layer Depth between \sigma_{\theta} = 26.25, 26.5')
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% 
% subplot(4,1,4)
% plot(month, Ave_PV,'k')
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% xlim([1 12])
% ylim([2e-9 4.5e-9])
% title('Background PV between \sigma_{\theta} = 26.25, 26.5')
% ylabel('s^{-3}');
% subplot(4,1,2)
% plot(month, GV_265clim,'k')
% set(gca, 'XLim',[1 12])
% set(gca, 'XTick', (1:1:12))
% set(gca, 'XTick', (1:1:12),'xticklabel',DateName)
% title('Geostrophic Velocity along 26.5 \sigma_{\theta}')
% ylim([-0.1 0.2]);
% ylabel('m/s')
% xlabel('Month')
% %print('Fig6_26_5Clim','-dpng','-r300')