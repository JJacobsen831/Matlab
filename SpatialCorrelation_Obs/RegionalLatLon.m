%Compute cross-shelf and along-shore spatial correlation of nutrients along
%density surfaces
clear;

%load data to workspace
filedir = '/home/jjacob2/matlab/CCS_ObsData/';
fid = 'RegionalNutrients.mat';
load([filedir fid]);

filedirCal = '/home/jjacob2/matlab/CCS_ObsVisualization/CalCOFI/CalCOFI_Processing/CTD_Bottle/Bottle_Data/';
fidCal = 'SMLDeepRhoBinCalCOFIDate.mat';
load([filedirCal fidCal]);

Rhos = RegionNute.Rho;
Stns = RegionNute.Stn;
NO3s = RegionNute.NO3;
NO2s = RegionNute.NO2;
NH4s = RegionNute.NH4;
PO4s = RegionNute.PO4;
SiO4s = RegionNute.SiO4;
DOs = RegionNute.DO;

%define offsets to access THL and NHL
offsetNHL = 63000;
offsetTHL = 2*63000;

%convert CalCOFI ID to lat lon
[CalLat, CalLon] = cc2lat(DEEP.Line, DEEP.Stn);

%NHL lat and lon
NHLstn = Stns((offsetNHL+1):offsetTHL,:);

NHL_Lat = 44.65*ones(size(NHLstn));

%NHL longitude
%           5        15       20       25       35       45       65     85
NHL_lons = [124.183, 124.416, 124.533, 124.65 , 124.883, 125.117, 125.6, 126.05];

NHL_Lon = NaN(size(NHLstn));
for n = 1:length(NHLstn(:,1))
    for m = 1:length(NHLstn(1,:))
        if (NHLstn(n,m) == 5)
            NHL_Lon(n,m) = NHL_lons(1);
        elseif (NHLstn(n,m) == 15)
            NHL_Lon(n,m) = NHL_lons(2);
        elseif (NHLstn(n,m) == 20)
            NHL_Lon(n,m) = NHL_lons(3);
        elseif (NHLstn(n,m) == 25)
            NHL_Lon(n,m) = NHL_lons(4);
        elseif (NHLstn(n,m) == 35)
            NHL_Lon(n,m) = NHL_lons(5);
        elseif (NHLstn(n,m) == 45)
            NHL_Lon(n,m) = NHL_lons(6);
        elseif (NHLstn(n,m) == 65)
            NHL_Lon(n,m) = NHL_lons(7);
        elseif (NHLstn(n,m) == 85)
            NHL_Lon(n,m) = NHL_lons(8);
        else 
            NHL_Lon(n,m) = nan;
        end
    end
end

% match nans for Lat
NHL_Lat(isnan(NHL_Lon)) = nan;

%THL lat and lon
THLstn = Stns((offestTHL+1):end,:);

THL_Lat = 41.05*ones(size(THLstn));

%THL longitude
THL_lons = [124.2, 124.267, 124.333, 124.433, 124.583, 124.75];
THL_Lon = NaN(size(THLstn));
for n = 1:length(THLstn(:,1))
    for m = 1:length(THLstn(1,:))
        if (THLstn(n,m) == 1)
            THL_Lon(n,m) = THL_lons(1);
        elseif (THLstn(n,m) == 2)
            THL_Lon(n,m) = THL_lons(2);
        elseif (THLstn(n,m) == 3)
            THL_Lon(n,m) = THL_lons(3);
        elseif (THLstn(n,m) == 3)
            THL_Lon(n,m) = THL_lons(3);
        elseif (THLstn(n,m) == 4)
            THL_Lon(n,m) = THL_lons(4);
        elseif (THLstn(n,m) == 5)
            THL_Lon(n,m) = THL_lons(5);
        elseif (THLstn(n,m) == 6)
            THL_Lon(n,m) = THL_lons(6);
        else
            THL_Lon(n,m) = nan;
        end
    end
end
THL_Lat(isnan(THL_Lon)) = nan;

StnLocation.Lats = vertcat(CalLat, NHL_Lat, THL_Lat);
StnLocation.Lons = vertcat(CalLon, NHL_Lon, THL_Lon);

% save('RegionalStnLocation.mat', 'StnLocation');

