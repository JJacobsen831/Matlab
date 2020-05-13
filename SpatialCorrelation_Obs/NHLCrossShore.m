%THL
THLDist = DistShore((2*63000+1):(3*63000),r);
THLDate = Date((2*63000+1):(3*63000),r);
THLNute = RegionNute.NO3((2*63000+1):(3*63000),r);

THLStnPairDist = NaN(500,1);
THLStnPairR = THLStnPairDist;

%subset distance value rounded to nearest 10 km
LineDist = round(THLDist,-1);
DistID = unique(LineDist);
DistID(isnan(DistID)) = [];
DistIDn = length(DistID);
    
%compute all combinations of stations
combo = nchoosek(1:DistIDn,2);
comboN = length(combo(:,1));
    
for m = 1:comboN
    StnOne = find(LineDist == DistID(combo(m,1)));
    StnTwo = find(LineDist == DistID(combo(m,2)));
    
    %check if data exists
    if (isempty(StnOne) == 0 && isempty(StnTwo) == 0)
        DateOne = THLDate(StnOne);
        DateOneID = unique(DateOne);
        DateOneIDn = length(DateOneID);
        
        DateTwo = THLDate(StnTwo);
        DateTwoID = unique(DateTwo);
        DateTwoIDn = length(DateTwoID);
        
        %check if stations are occupied more than 10 times
        if (DateOneIDn > 5 && DateTwoIDn > 5)            
            
            %compute distances between station pairs
            THLStnPairDist(m) = abs(LineDist(StnOne(1)) - LineDist(StnTwo(1)));
            
            %subset nutrients
            NuteOne = THLNute(StnOne);
            NuteTwo = THLNute(StnTwo);
            
            %select station with fewest obs
            if (DateOneIDn < DateTwoIDn)
                SelectDate = DateOneID;
            else
                SelectDate = DateTwoID;
            end
            SelectDateN = length(SelectDate);
            
            TSone = NaN(SelectDateN,1); TStwo = TSone;
            for t = 1:SelectDateN
                TSone(t) = nanmean(NuteOne(DateOne == SelectDate(t)));
                TStwo(t) = nanmean(NuteTwo(DateTwo == SelectDate(t)));
            end
            inanONE = isnan(TSone);
            TStwo(inanONE) = [];
            TSone(inanONE) = [];
            inanTWO = isnan(TStwo);
            TSone(inanTWO) = [];
            TStwo(inanTWO) = [];
            if (length(TSone) > 5 && length(TStwo) > 5)
                          
                StnPairCor = corrcoef([TSone, TStwo], 'Rows', 'pairwise');
                THLStnPairR(m) = StnPairCor(2);
            else
                THLStnPairDist(m) = nan;
                THLStnPairR(n) = nan;
            end
        else
            THLStnPairDist(m) = nan;
            THLStnPairR(n) = nan;
        end
    else
        THLStnPairDist(m) = nan;
        THLStnPairR(m) = nan;
    end
end

