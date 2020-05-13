%aggregate WOA analyzed fields with 1 degree buffer outside of wc12 domain 
clear;

%set parent directory
ParDir = '/home/jjacob2/matlab/WOA/UnprocessedData/';

%Extract each variable into WOA pre-process
WOApp.lat = ncread([ParDir, 'Temperature/woa18_decav_t00_01.nc'], 'lat');
WOApp.lon = ncread([ParDir, 'Temperature/woa18_decav_t00_01.nc'], 'lon');
WOApp.depth = ncread([ParDir, 'Temperature/woa18_decav_t00_01.nc'], 'depth');
WOApp.NO3 = ncread([ParDir, 'Nitrate/woa18_all_n00_01.nc'], 'n_an');
WOApp.Oxy = ncread([ParDir, 'Oxygen/woa18_all_o00_01.nc'], 'o_an');
WOApp.PO4 = ncread([ParDir, 'Phosphate/woa18_all_p00_01.nc'], 'p_an');
WOApp.Sal = ncread([ParDir, 'Salinity/woa18_decav_s00_01.nc'], 's_an');
WOApp.SiO4 = ncread([ParDir, 'Silicate/woa18_all_i00_01.nc'], 'i_an');
WOApp.Temp = ncread([ParDir, 'Temperature/woa18_decav_t00_01.nc'], 't_an');

%subset WOA to wc12 domain
%location reference from initial condition file
RefFile = '/home/jjacob2/BoundaryInitialFiles/2019Dec13/wc12_hycom_20090101_dnref99_ini_Darwin_NuteMap.nc';
Ref.lat = ncread(RefFile,'lat_rho');
Ref.lon = ncread(RefFile,'lon_rho');

%select every point at .5 degree intervals with 1 degree outside of wc12
%domain included
RefLat = [min(min(Ref.lat,[],2))-0.5, squeeze(Ref.lat(1,6:10:176)), max(max(Ref.lat,[],2))+0.5];  
RefLon = [min(min(Ref.lon,[],2))-0.5; squeeze(Ref.lon(6:10:186,1)); max(max(Ref.lon,[],2))+1];

%indices of WOA lat within wc12
Datlat = NaN(size(RefLat'));
for n = 1:length(RefLat)
    Datlat(n) = find(WOApp.lat == RefLat(n));
end

%indices of WOA lon within wc12
Datlon = NaN(size(RefLon'));
for n = 1:length(RefLon)
    Datlon(n) = find(WOApp.lon == RefLon(n));
end

%put data into WOA analyzed
WOAan.lat = WOApp.lat(Datlat);
WOAan.lon = WOApp.lon(Datlon);
WOAan.depth = WOApp.depth;
WOAan.temp = WOApp.Temp(Datlon,Datlat,:);
WOAan.sal = WOApp.Sal(Datlon,Datlat,:);
WOAan.NO3 = WOApp.NO3(Datlon,Datlat,:);
WOAan.Oxy = WOApp.Oxy(Datlon,Datlat,:);
WOAan.PO4 = WOApp.PO4(Datlon,Datlat,:);
WOAan.SiO4 = WOApp.SiO4(Datlon,Datlat,:);

%Compute density
den = NaN(size(WOAan.temp));
for m = 1:size(WOAan.temp,1)
    for n = 1:size(WOAan.temp,2)
        
        if (isnan(WOAan.temp(m,n,2)) == 0)
            
            den(m,n,:) = sw_pden(squeeze(WOAan.sal(m,n,:)),...
                squeeze(WOAan.temp(m,n,:)),...
                sw_pres(WOAan.depth, WOAan.lat(n)), 0);
        end
    end
end
            
WOAan.rho = den - 1000;

save('WOAan_wc12buffer.mat','WOAan')