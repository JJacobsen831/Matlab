function numSD = SpatialSD_Monthly(IntGrd, WOA_stat, VarName, nObsThresh)
%compute number of standard deviations model is away from WOA over wc12 domain

%Fix oxygen name
if (VarName(1) == 'O')
    VarName = 'DO';
    numSD.depth = WOA_stat.(VarName).depht;

elseif (VarName(1) == 'S')
    VarName = 'SiO4';
    
else
    numSD.depth = WOA_stat.(VarName).depth;
end

%compute number of standard deviations
nSD = (IntGrd - WOA_stat.(VarName).val)./WOA_stat.(VarName).SD;

%remove locations with less than nObsThreshold
nSD(WOA_stat.(VarName).nObs < nObsThresh) = NaN;

%store variables for export
numSD.nSD = permute(nSD, [2,1,3]);
% ;
numSD.lon = WOA_stat.phys.lon;
numSD.lat = WOA_stat.phys.lat;

%permute to make lat alined with y-axis
numSD.nObs = permute(WOA_stat.(VarName).nObs, [2,1,3]);

return