%aggregate WOA climatology
clear

%select file
VarDir = '3_Mar/';
Fname = 'woa18_decav_t03_01.nc';

%Point to file directory
ParDir = '/home/jjacob2/matlab/WOA/UnprocessedData/MonthlyStat/';
FilDir = [ParDir,VarDir];
File = [FilDir, Fname];

%read variables
PreDat.lat = ncread(File, 'lat');
PreDat.lon = ncread(File, 'lon');
PreDat.dep = ncread(File, 'depth');
PreDat.oxy = ncread(File, 't_mn');          %statistical mean
PreDat.NumObs = ncread(File, 't_dd');       %number of Obs
PreDat.Ostdev=ncread(File, 't_sd');         %standard deviation

%subset locations same as initial condition file
RefFile = '/home/jjacob2/BoundaryInitialFiles/2019Dec13/wc12_hycom_20090101_dnref99_ini_Darwin_NuteMap.nc';
Ref.lat = ncread(RefFile,'lat_rho');
Ref.lon = ncread(RefFile,'lon_rho');

%select every point at .5 degree intervals
RefLat = squeeze(Ref.lat(1,6:10:176));  
RefLon = squeeze(Ref.lon(6:10:186,1));

%indices of WOA lat within wc12
Datlat = NaN(size(RefLat'));
for n = 1:length(RefLat)
    Datlat(n) = find(PreDat.lat == RefLat(n));
end

%indices of WOA lon within wc12
Datlon = NaN(size(RefLon'));
for n = 1:length(RefLon)
    Datlon(n) = find(PreDat.lon == RefLon(n));
end

%subset WOA data
WOA_wc12.lat = PreDat.lat(Datlat);
WOA_wc12.lon = PreDat.lon(Datlon);
WOA_wc12.temp = PreDat.oxy(Datlon,Datlat,:);
WOA_wc12.tempSD = PreDat.Ostdev(Datlon,Datlat,:);
WOA_wc12.tempObs = PreDat.NumObs(Datlon,Datlat,:);
WOA_wc12.depth = PreDat.dep;

%save to structure
save('WOA_Tstat_03.mat','WOA_wc12')