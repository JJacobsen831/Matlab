clear;
filedir = '/home/jjacob2/matlab/CCS_ObsData/THLFigures/';
load([filedir 'THL_bathy.mat']);
load([filedir 'THL_DataOI10Bathy_May-2010_Oct-2017.mat']);
THL_LI = load([filedir 'THL_Data_May-2010_Oct-2017.mat']);
clear lon;
load([filedir 'THL_LonOI.mat']);
load([filedir 'THL_OI10Bathy_GeoVel.mat']);
load([filedir 'THL_timeComplete.mat']);
load([filedir 'THL_AveBV.mat']);

%import variables
StationLon = THL_LI.th_hydro.lon;
T = Toib; S = Soib; pden = Doib;
bathy = th_bathy.bathy;
time = time01; clear time02 time03 time04 time05
StationLon = THL_LI.th_hydro.lon;
ndepth = length(THL_LI.th_hydro.pres);
nlon = length(lonOI);
ntime = 54;
%compute BV
BV = nan*ones(ndepth-1,nlon,ntime);
for m=1:length(time)
    for n=1:nlon
        BV(:,n,m) = sw_bfrq(S(:,n,m),T(:,n,m), depth);
    end
end

%index of nino and norm years
Nino = 26:47;
nNino = length(Nino);
NinoYr = [2014:2016];
nNinoYr = 3;

Norm = [1:25, 48:54];
nNorm = length(Norm);
NormYr = [2010:2013, 2017];
nNormYr = 5;

%subset nino and norm years
NinoDate = datetime(time(Nino), 'ConvertFrom','datenum');
NinoT = T(:,:,Nino);
NinoS = S(:,:,Nino);
NinoD = pden(:,:,Nino);
NinoBV = BV(:,:,Nino);
NinoGV = GeoVel(:,:,Nino);

NormDate = datetime(time(Norm), 'ConvertFrom', 'datenum');
NormT = T(:,:,Norm);
NormS = S(:,:,Norm);
NormD = pden(:,:,Norm);
NormBV = BV(:,:,Norm);
NormGV = GeoVel(:,:,Norm);

%weighted avgerage for Norm years
NormMth = unique(month(NormDate)); 
NormWtAvgT = NaN(200,76,length(NormMth));
NormWtAvgS = NormWtAvgT; WtAvgD = NormWtAvgT;
NormWtAvgBV = NaN(199,76,length(NormMth));
NormWtAvgGV = NaN(200,75,length(NormMth));
NormWt = NaN(length(NormMth),1);
for m = 1:length(NormMth)
    MthIDX = find(month(NormDate) == NormMth(m));
    NormWt(m) = length(MthIDX)/length(NormDate);
    NormWtAvgT(:,:,m) = NormWt(m).*nanmean(NormT(:,:,MthIDX),3);
    NormWtAvgS(:,:,m) = NormWt(m).*nanmean(NormS(:,:,MthIDX),3);
    WtAvgD(:,:,m) = NormWt(m).*nanmean(NormD(:,:,MthIDX),3);
    NormWtAvgBV(:,:,m) = NormWt(m).*nanmean(NormBV(:,:,MthIDX),3);
    NormWtAvgGV(:,:,m) = NormWt(m).*nanmean(NormGV(:,:,MthIDX),3);
end
NORM.T = sum(NormWtAvgT,3);
NORM.S = sum(NormWtAvgS,3);
NORM.Den = sum(WtAvgD,3);
NORM.BV = sum(NormWtAvgBV,3);
NORM.GV = sum(NormWtAvgGV,3);

%weigthed average for Nino Years
NinoMth = unique(month(NinoDate)); 
NinoWtAvgT = NaN(200,76,length(NinoMth));
NinoWtAvgS = NinoWtAvgT; WtAvgD = NinoWtAvgT;
NinoWtAvgBV = NaN(199,76,length(NinoMth));
NinoWtAvgGV = NaN(200,75,length(NinoMth));
NinoWt = NaN(length(NinoMth),1);
for m = 1:length(NinoMth)
    MthIDX = find(month(NinoDate) == NinoMth(m));
    NinoWt(m) = length(MthIDX)/length(NinoDate);
    NinoWtAvgT(:,:,m) = NinoWt(m).*nanmean(NinoT(:,:,MthIDX),3);
    NinoWtAvgS(:,:,m) = NinoWt(m).*nanmean(NinoS(:,:,MthIDX),3);
    WtAvgD(:,:,m) = NinoWt(m).*nanmean(NinoD(:,:,MthIDX),3);
    NinoWtAvgBV(:,:,m) = NinoWt(m).*nanmean(NinoBV(:,:,MthIDX),3);
    NinoWtAvgGV(:,:,m) = NinoWt(m).*nanmean(NinoGV(:,:,MthIDX),3);
end
NINO.T = sum(NinoWtAvgT,3);
NINO.S = sum(NinoWtAvgS,3);
NINO.Den = sum(WtAvgD,3);
NINO.BV = sum(NinoWtAvgBV,3);
NINO.GV = sum(NinoWtAvgGV,3);

save('InteranTHL.mat','NORM','NINO');
%T S GV Norm on Left, Nino on Right


