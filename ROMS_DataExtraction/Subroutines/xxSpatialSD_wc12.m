function numSD = SpatialSD_wc12(Output, VarName)
%compute number of standard deviations model output is away WOA

%load WOA
load('/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/WOA18_wc12Stat.mat');

%check size of argument matches WOA

%define depth tolerance
DepTol = 2.5;

% Preallocate variables 
nSD = NaN(size(WOA_stat.phys.lon,1), ...
    size(WOA_stat.phys.lat,1), ...
    size(WOA_stat.phys.depth,1));
WOA_nOb = nSD;
WOA_dep = nSD;
Mod_dep = nSD;
Zdif = nSD;
%
for lon = 1:size(nSD,1)
    for lat = 1:size(nSD,2)
        for dep = 1:size(nSD,3)
            
            %select standard WOA depth
            WOAdepth = WOA_stat.phys.depth(dep);
            
            %locate nearest OUTPUT depth
            AbsDep = abs(squeeze(Output.depth(lon,lat,:)) - WOAdepth);
            OP_Zind = find(min(AbsDep) == AbsDep);
            
            %determine if WOA depth and OUTPUT depth are similar
            if (AbsDep(OP_Zind) < DepTol)
                
                %Extract WOA data
                %WOA depth indice
                WOA_Zind = find(WOAdepth == WOA_stat.phys.depth);
                
                %WOA variable
                WOA_Var = squeeze(WOA_stat.(VarName).val(lon,lat,WOA_Zind));
                
                %WOA standard deviation
                WOA_SD = squeeze(WOA_stat.(VarName).SD(lon,lat,WOA_Zind));
                
                %[SAVE] WOA number of observations 
                WOA_nOb(lon,lat,dep) = squeeze(WOA_stat.(VarName).nObs(lon,lat,WOA_Zind));
                
                %[SAVE] WOA depth 
                WOA_dep(lon,lat,dep) = squeeze(WOA_stat.phys.depth(WOA_Zind));
                
                %Extract OUTPUT data
                %OUTPUT variable
                Mod_Var = squeeze(Output.(VarName)(lon,lat,OP_Zind));
                
                %[SAVE] OUTPUT depth 
                Mod_dep(lon,lat,dep) = squeeze(Output.depth(lon,lat,OP_Zind));
                
                %[SAVE] Compute number of standard deviations 
                nSD(lon,lat,dep) = (Mod_Var - WOA_Var)./(WOA_SD);
                
                %[SAVE] Depth difference 
                Zdif(lon,lat,dep) = Mod_dep(lon,lat,dep) - WOA_dep(lon,lat,dep);
                
            end
        end
    end
end
                
%Exclude points with low number of WOA observations
ibad = find(WOA_nOb < 5);
nSD(ibad) = nan;
WOA_dep(ibad) = nan;
Mod_dep(ibad) = nan;
Zdif(ibad) = nan;

%save variables in structure for export
numSD.lon = WOA_stat.phys.lon;
numSD.lat = WOA_stat.phys.lat;
numSD.nSD = nSD;
numSD.WOA_depth = WOA_dep;
numSD.Output_depth = Mod_dep;
numSD.DepDif = Zdif;

return