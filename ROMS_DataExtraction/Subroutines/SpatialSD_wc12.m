function numSD = SpatialSD_wc12(Output,VarName, nObsThresh)
%compute number of standard deviations model is away from WOA19
%   Interpolates to WOA grid; Permutes matrix to be (lon, lat, depth)

%load WOA stats
load('/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/WOA18_wc12Stat.mat');

%Re-grid model to WOA 
IntGrd = Roms2WoaGrid(Output, VarName);

%compute number of standard deviations
nSD = (IntGrd - WOA_stat.(VarName).val)./WOA_stat.(VarName).SD;

%remove locations with less than nObsThreshold
nSD(WOA_stat.(VarName).nObs < nObsThresh) = NaN;

%store variables for export
numSD.nSD = permute(nSD, [2,1,3]);
numSD.depth = WOA_stat.phys.depth;
numSD.lon = WOA_stat.phys.lon;
numSD.lat = WOA_stat.phys.lat;
numSD.nObs = permute(WOA_stat.(VarName).nObs, [2,1,3]);

end

