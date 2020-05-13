%Compute cross-shelf and along-shore spatial correlation of nutrients along
%density surfaces
clear;

%load data
filedir = '/home/jjacob2/matlab/CCS_ObsData/';
fid = 'RegionalNutrients.mat';
fidLoc = 'RegionalStnLocation.mat';
fidDis = 'DistFromShore.mat';
load([filedir fid]);
load([filedir fidLoc]);
load([filedir fidDis]);

%Import data
Date = RegionNute.Date; 
Lat = StnLocation.Lats;
Lons = StnLocation.Lons;

%convert lons to decimal degrees
Lon = NaN(size(Lons));
for m = 1:length(Lons(:,1))
    for n = 1:length(Lons(1,:))
        if (Lons(m,n) > 200)
            Lon(m,n) = Lons(m, n) - 360;
        elseif (Lons(m,n) < 150)
            Lon(m,n) = -1*Lons(m,n);
        end
    end
end

%select density level
rholevels = {'23.5', '24.0', '24.5', '25.0', '25.5', '26.0', '26.5',...
    '27.0', '27.5'};
r = menu('Select Density Level:', rholevels);
RhoName = rholevels{r};

%Select Nutrient
NuteNum = menu('Choose Variable: ', 'NO3', 'NO2', 'NH4', 'PO4',...
    'SiO4', 'DO');
if (NuteNum == 1)
    NuteR = RegionNute.NO3(:,r);
    NuteName = 'NO3';
elseif (NuteNum == 2)
    NuteR = RegionNute.NO2(:,r);
    NuteName = 'NO2';
elseif (NuteNum == 3)
    NuteR = RegionNute.NH4(:,r);
    NuteName = 'NH4';
elseif (NuteNum == 4)
    NuteR = RegionNute.PO4(:,r);
    NuteName = 'PO4';
elseif (NuteNum == 5)
    NuteR = RegionNute.SiO4(:,r);
    NuteName = 'SiO4';
elseif (NuteNum == 6)
    NuteR = RegionNute.DO(:,r);
    NuteName = 'DO';
end

%subset other data along density surface
DateR = Date(:,r);
LonR = Lon(:,r);
LatR = Lat(:,r);
DisR = DistShore(:,r);

%Select Inshore Boundary
ISB = menu('Select Inshore Boundary: ', '25 km', '50 km', '75 km', '100 km');
if (ISB ==1)
    InshoreBoundary = 25;
    ISBname = '25 km';
elseif (ISB == 2)
    InshoreBoundary = 50;
    ISBname = '50 km';
elseif (ISB == 3)
    InshoreBoundary = 75;
    ISBname = '75 km';
elseif (ISB == 4)
    InshoreBoundary = 100;
    ISBname = '100 km';
end

%Separate data into inshore and offshore
DisRnd = NaN(size(DisR));
for n = 1:length(DisR)
    if (DisR(n) <= InshoreBoundary)
        DisRnd(n) = 50;
    else
        Temp = round(DisR(n),-2);
        if (Temp < 100)
            DisRnd(n) = 100;
        else
            DisRnd(n) = Temp;
        end
    end
end

%find unique bands of distance from shore
ID = unique(DisRnd);
ID(isnan(ID)) = [];

%Compare each station to other stations at similar distance from shore
StnPairR = NaN(5e2,length(ID));
StnPairDist = StnPairR;
for s = 1:length(ID)
    %select distace from shore
    STNidx = find(DisRnd == ID(s));
    
    StnLon = LonR(STNidx);
    StnLat = LatR(STNidx);
    StnDate = DateR(STNidx);
    StnNute = NuteR(STNidx);
        
    %unique latitudes used to find station paris
    [LatID, Latidx] = unique(StnLat);
    LonID = StnLon(Latidx);
    LonIDn = length(LonID);
    
    
    %Define all possible station pairs
    combos = nchoosek(1:LonIDn,2);
    combosN = length(combos(:,1));
    
   
    for m = 1:combosN
        StnOne = find(StnLat == LatID(combos(m,1)));
        StnTwo = find(StnLat == LatID(combos(m,2)));
        
        if (isempty(StnOne) == 0 && isempty(StnTwo) == 0)
            %compute distances between station pairs
            StnPairDist(m,s) = sw_dist([StnLat(StnOne(1)), StnLat(StnTwo(1))],...
                [StnLon(StnOne(1)), StnLon(StnTwo(1))],'km');
            
            
            NuteOne = StnNute(StnOne);
            NuteTwo = StnNute(StnTwo);
            
            %round date to quarterly obs
            DateOne = dateshift(datetime(datestr(StnDate(StnOne)),...
                'InputFormat','dd-MMM-yyyy'),'start','quarter');
            DateOneID = unique(DateOne);
            DateOneN = length(DateOneID);
            
            DateTwo = dateshift(datetime(datestr(StnDate(StnTwo)),...
                'InputFormat','dd-MMM-yyyy'),'start','quarter');
            DateTwoID = unique(DateTwo);
            DateTwoN = length(DateTwoID);
            
            %select station with fewest obs assuming larger set contains elements of
            %smaller set
            if ((DateOneN > 10) && (DateTwoN > 10))
                if (DateOneN < DateTwoN)
                    SelectDate = DateOneID;
                else
                    SelectDate = DateTwoID;
                end
                SelectDateN = length(SelectDate);
                
                %for each station pair determine Nute at station1 vs Nute at station2
                %to generate 'time series' of property-property similarity and then
                %compute correlation for specific station pairs that are bin average based 
                %on quarterly obs 
                
                TSOne = NaN(SelectDateN,1); TSTwo = TSOne;
                for n = 1:SelectDateN
                    TSOne(n) = nanmean(NuteOne(DateOne == SelectDate(n)));
                    TSTwo(n) = nanmean(NuteTwo(DateTwo == SelectDate(n)));
                end
                
                StnPairCor = corrcoef([TSOne, TSTwo], 'Rows','pairwise');
                StnPairR(m,s) = StnPairCor(2);
            else
                StnPairR(m,s) = nan;
            end
        else
            StnPairDist(m,s) = nan;
            StnPairR(m,s) = nan;
        end
    end
end

% cross shelf correlation
[CrossShelfDist, CrossShelfR] = CrossShelfCorr(r, NuteNum);



%plot labels and titles
TITLE0 = ['Correlation Length Scale of ', NuteName, ...
    ' along ', RhoName, ' \sigma_\theta']; 
TITLE1 = {TITLE0, 'in Along-Shore Direction'};
TITLE3 = {TITLE0, ' in Cross-Shore Direction'};
LAB1 = 'Offshore Data';
LAB2 = ['Data Inshore of ', ISBname];

%plotting
set(gcf,'position',[1 35 1920 1046]);

subplot(1,2,1)
for p=2:length(ID)
    p2 = scatter(StnPairDist(:,p), StnPairR(:,p), [], 'k', 'filled');
    hold on
end
p1 = scatter(StnPairDist(:,1), StnPairR(:,1), [], 'b');
ylim([-1, 1]);
title(TITLE1)
xlabel('Alongshore Distance between stations (km)');
ylabel('Correlation (r)');
legend([p2, p1],{LAB1, LAB2}, 'Location', 'southwest')

subplot(1,2,2)
for p = 1:8
    scatter(CrossShelfDist(:,p), CrossShelfR(:,p))
    hold on
end
ylim([-1 1]);
xlabel('Cross-Shore Distance between stations (km)');
ylabel('Correlation (r)');
title(TITLE3);
legend('CalCOFI 76.7','CalCOFI 80.0','CalCOFI 83.3', 'CalCOFI 86.7', ...
    'CalCOFI 90.0','CalCOFI 93.3', 'Newport', 'Trinidad', ...
    'Location','southeast')