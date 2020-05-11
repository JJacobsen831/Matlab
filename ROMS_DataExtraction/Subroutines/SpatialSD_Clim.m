function numSD = SpatialSD_Clim(IntGrd, WOA_stat, VarName, nObsThresh)
%compute number of standard deviations wrt annual climatology (WOA)

nSD = (IntGrd - WOA_stat.(VarName).val)./WOA_stat.(VarName).SD;

%remove locations with less than nObsTreshold
nSD(WOA_stat.(VarName).nObs < nObsThresh) = NaN;

%store variables for export
numSD.nSD = permute(nSD, [2,1,3]);
numSD.depth = WOA_stat.phys.depth;
numSD.lon = WOA_stat.phys.lon;
numSD.lat = WOA_stat.phys.lat;

%permute to make lat alined with y-axis
numSD.nObs = permute(WOA_stat.(VarName).nObs, [2,1,3]);

return