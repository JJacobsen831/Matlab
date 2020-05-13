function [StnDist, StnCorr] = CalCrossShelfCorr(r, N)
% computes Cross shelf spatial correaltion given density and nutrient
% number

filedir = '/home/jjacob2/matlab/CCS_ObsData/';
filedirCal = '/home/jjacob2/matlab/CCS_ObsVisualization/CalCOFI/CalCOFI_Processing/CTD_Bottle/Bottle_Data/';

fid = 'RegionalNutrients.mat';
fidLoc = 'RegionalStnLocation.mat';
fidDis = 'DistFromShore.mat';
fidCal = 'SMLDeepRhoBinCalCOFIDate.mat';

load([filedir fid]);
load([filedir fidLoc]);
load([filedir fidDis]);
load([filedirCal fidCal]);

%Import data
Date = RegionNute.Date; 
CalLines = DEEP.Line;

%select nutrient
if (N == 1)
    Nutes = RegionNute.NO3;
elseif (N == 2)
    Nutes = RegionNute.NO2;
elseif (N==3)
    Nutes = RegionNute.NH4;
elseif (N==4)
    Nutes = RegionNute.PO4;
elseif (N==5)
    Nutes = RegionNute.SiO4;
elseif (N==6)
    Nutes = RegionNute.DO;
end
  

%CalCOFI
CalDist = DistShore(1:63000,r);
CalLine = CalLines(:,r);
CalDate = Date(1:36000,r);
CalNute = Nutes(1:63000,r);

CalLineName = [76.7, 80.0, 83.3, 86.7, 90.0, 93.3];

CalStnPairDist = NaN(550, length(CalLineName));
CalStnPairR = CalStnPairDist;


for n = 1:length(CalLineName)
    %locate specific line
    LineIDX = find(CalLine == CalLineName(n));
    
    %subset nutrient value
    LineNute = CalNute(LineIDX);
    
    %subset date
    LineDate = CalDate(LineIDX);
    
    %subset distance value rounded to nearest 10 km
    LineDist = round(CalDist(LineIDX),-1);
    DistID = unique(LineDist);
    DistIDn = length(DistID);
    
    %compute all combinations of stations
    combo = nchoosek(1:DistIDn,2);
    comboN = length(combo(:,1));
    
    for m = 1:comboN
        StnOne = find(LineDist == DistID(combo(m,1)));
        StnTwo = find(LineDist == DistID(combo(m,2)));
        
        %check if data exists
        if (isempty(StnOne) == 0 && isempty(StnTwo) == 0)
            DateOne = LineDate(StnOne);
            DateOneID = unique(DateOne);
            DateOneIDn = length(DateOneID);
            
            DateTwo = LineDate(StnTwo);
            DateTwoID = unique(DateTwo);
            DateTwoIDn = length(DateTwoID);
            
            %check if stations are occupied more than 10 times
            if (DateOneIDn > 10 && DateTwoIDn > 10)            
                
                %compute distances between station pairs
                CalStnPairDist(m,n) = abs(LineDist(StnOne(1)) - LineDist(StnTwo(1)));
                
                %subset nutrients
                NuteOne = LineNute(StnOne);
                NuteTwo = LineNute(StnTwo);
                
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
                
                StnPairCor = corrcoef([TSone, TStwo], 'Rows', 'pairwise');
                CalStnPairR(m,n) = StnPairCor(2);
            else
                CalStnPairDist(m,n) = nan;
                CalStnPairR(m,n) = nan;
            end
        else
            CalStnPairDist(m,n) = nan;
            CalStnPairR(m,n) = nan;
        end
    end
end

% %NHL
% NHLDist = DistShore(63001:(2*63000),r);
% NHLDate = Date(63001:(2*63000),r);
% NHLNute = Nutes(63001:(2*63000),r);
% 
% NHLStnPairDist = NaN(550,1);
% NHLStnPairR = NHLStnPairDist;
% 
% %subset distance value rounded to nearest 10 km
% LineDist = round(NHLDist,-1);
% DistID = unique(LineDist);
% DistID(isnan(DistID)) = [];
% DistIDn = length(DistID);
%     
% %compute all combinations of stations
% combo = nchoosek(1:DistIDn,2);
% comboN = length(combo(:,1));
%     
% for m = 1:comboN
%     StnOne = find(LineDist == DistID(combo(m,1)));
%     StnTwo = find(LineDist == DistID(combo(m,2)));
%     
%     %check if data exists
%     if (isempty(StnOne) == 0 && isempty(StnTwo) == 0)
%         DateOne = NHLDate(StnOne);
%         DateOneID = unique(DateOne);
%         DateOneIDn = length(DateOneID);
%         
%         DateTwo = NHLDate(StnTwo);
%         DateTwoID = unique(DateTwo);
%         DateTwoIDn = length(DateTwoID);
%         
%         %check if stations are occupied more than 10 times
%         if (DateOneIDn > 5 && DateTwoIDn > 5)            
%             
%             %compute distances between station pairs
%             NHLStnPairDist(m) = abs(LineDist(StnOne(1)) - LineDist(StnTwo(1)));
%             
%             %subset nutrients
%             NuteOne = NHLNute(StnOne);
%             NuteTwo = NHLNute(StnTwo);
%             
%             %select station with fewest obs
%             if (DateOneIDn < DateTwoIDn)
%                 SelectDate = DateOneID;
%             else
%                 SelectDate = DateTwoID;
%             end
%             SelectDateN = length(SelectDate);
%             
%             TSone = NaN(SelectDateN,1); TStwo = TSone;
%             for t = 1:SelectDateN
%                 TSone(t) = nanmean(NuteOne(DateOne == SelectDate(t)));
%                 TStwo(t) = nanmean(NuteTwo(DateTwo == SelectDate(t)));
%             end
%             inanONE = isnan(TSone);
%             TStwo(inanONE) = [];
%             TSone(inanONE) = [];
%             inanTWO = isnan(TStwo);
%             TSone(inanTWO) = [];
%             TStwo(inanTWO) = [];
%             if (length(TSone) > 5 && length(TStwo) > 5)
%                           
%                 StnPairCor = corrcoef([TSone, TStwo], 'Rows', 'pairwise');
%                 NHLStnPairR(m) = StnPairCor(2);
%             else
%                 NHLStnPairDist(m) = nan;
%                 NHLStnPairR(n) = nan;
%             end
%         else
%             NHLStnPairDist(m) = nan;
%             NHLStnPairR(n) = nan;
%         end
%     else
%         NHLStnPairDist(m) = nan;
%         NHLStnPairR(m) = nan;
%     end
% end
% 
% %THL
% THLDist = DistShore((2*63000+1):(3*63000),r);
% THLDate = Date((2*63000+1):(3*63000),r);
% THLNute = Nutes((2*63000+1):(3*63000),r);
% 
% THLStnPairDist = NaN(550,1);
% THLStnPairR = THLStnPairDist;
% 
% %subset distance value rounded to nearest 10 km
% LineDist = round(THLDist,-1);
% DistID = unique(LineDist);
% DistID(isnan(DistID)) = [];
% DistIDn = length(DistID);
%     
% %compute all combinations of stations
% combo = nchoosek(1:DistIDn,2);
% comboN = length(combo(:,1));
%     
% for m = 1:comboN
%     StnOne = find(LineDist == DistID(combo(m,1)));
%     StnTwo = find(LineDist == DistID(combo(m,2)));
%     
%     %check if data exists
%     if (isempty(StnOne) == 0 && isempty(StnTwo) == 0)
%         DateOne = THLDate(StnOne);
%         DateOneID = unique(DateOne);
%         DateOneIDn = length(DateOneID);
%         
%         DateTwo = THLDate(StnTwo);
%         DateTwoID = unique(DateTwo);
%         DateTwoIDn = length(DateTwoID);
%         
%         %check if stations are occupied more than 10 times
%         if (DateOneIDn > 5 && DateTwoIDn > 5)            
%             
%             %compute distances between station pairs
%             THLStnPairDist(m) = abs(LineDist(StnOne(1)) - LineDist(StnTwo(1)));
%             
%             %subset nutrients
%             NuteOne = THLNute(StnOne);
%             NuteTwo = THLNute(StnTwo);
%             
%             %select station with fewest obs
%             if (DateOneIDn < DateTwoIDn)
%                 SelectDate = DateOneID;
%             else
%                 SelectDate = DateTwoID;
%             end
%             SelectDateN = length(SelectDate);
%             
%             TSone = NaN(SelectDateN,1); TStwo = TSone;
%             for t = 1:SelectDateN
%                 TSone(t) = nanmean(NuteOne(DateOne == SelectDate(t)));
%                 TStwo(t) = nanmean(NuteTwo(DateTwo == SelectDate(t)));
%             end
%             inanONE = isnan(TSone);
%             TStwo(inanONE) = [];
%             TSone(inanONE) = [];
%             inanTWO = isnan(TStwo);
%             TSone(inanTWO) = [];
%             TStwo(inanTWO) = [];
%             if (length(TSone) > 5 && length(TStwo) > 5)
%                           
%                 StnPairCor = corrcoef([TSone, TStwo], 'Rows', 'pairwise');
%                 THLStnPairR(m) = StnPairCor(2);
%             else
%                 THLStnPairDist(m) = nan;
%                 THLStnPairR(n) = nan;
%             end
%         else
%             THLStnPairDist(m) = nan;
%             THLStnPairR(n) = nan;
%         end
%     else
%         THLStnPairDist(m) = nan;
%         THLStnPairR(m) = nan;
%     end
% end

StnDist = [CalStnPairDist]; % , NHLStnPairDist, THLStnPairDist];
StnCorr = [CalStnPairR]; %, NHLStnPairR, THLStnPairR];

return