function IntGrd = Roms2WoaGrid_Clim(Output,VarName, WOA_stat)
%interpolate ROMS depth to WOA regular grid on wc12 domain

%check depth is positive to be consistent with WOA
if (nanmean(nanmean(nanmean(Output.depth))) < 0)
    Output.depth = -1*Output.depth;
end

%load WOA
% load('/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/WOA18_wc12Stat.mat');
W_grd = WOA_stat.phys;
W_grd.depth = WOA_stat.phys.depth;

DepMax = max(W_grd.depth);


I_grd = NaN(length(W_grd.lon), length(W_grd.lat), length(W_grd.depth));
for m = 1:length(W_grd.lon)
    for n = 1:length(W_grd.lat)
        
        %model values
        Mdep = squeeze(Output.depth(m,n,:));
        Mval = squeeze(Output.(VarName)(m,n,:));
        
        %check if depth is empty (ie land mask)
        if (isnan(Mdep(5)) == 0)
            %find depth range of WOA in model output
            ModDepMaxIDX = find(min(abs(Mdep - DepMax)) == abs(Mdep - DepMax));
            
            %subset Model to match WOA
            ModDep = Mdep(ModDepMaxIDX:end);
            ModVal = Mval(ModDepMaxIDX:end);
            
            %remove nan
            [ModVal, ModDep] = Clean2Var(ModVal, ModDep);
            
            %interpolate
            if (isempty(Mval) == 0)
                Int = interp1(ModDep, ModVal, W_grd.depth, 'linear');
                Int(Int < 0) = NaN;
                I_grd(m,n,1:length(Int)) = Int;
            end
            
            
            %check interpolation
            if (nansum(I_grd(m,n, :) < 0) > 0)
                disp('BigOlNope')
                return
            end
        end
    end
end

IntGrd = I_grd;

return