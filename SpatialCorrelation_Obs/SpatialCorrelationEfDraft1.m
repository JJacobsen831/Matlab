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
DateR = Date(1:63000,r);
LonR = Lon(1:63000,r);
LatR = Lat(1:63000,r);
DisR = DistShore(1:63000,r);

%Select Inshore Boundary
InshoreBoundary = 100;
ISBname = '100 km';

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
[CrossShelfDist, CrossShelfR] = CalCrossShelfCorr(r, NuteNum);

% exponential fits
% long-shelf nearshore
 [L1, SigmaL, L2, SigmaL2, Scale, Sigma_bf] = ParameterError(StnPairDist, StnPairR);
 
%offshore
OffshoreDist = reshape(StnPairDist(:,2:end),...
    [length(StnPairDist(:,1))*length(StnPairDist(1,2:end)), 1]);
OffshoreR = reshape(StnPairR(:,2:end),...
    [length(StnPairR(:,1))*length(StnPairR(1,2:end)), 1]);

%clean NaNs
inan1 = isnan(OffshoreDist);
OffshoreDist(inan1) = [];
OffshoreR(inan1) = [];
inan2 = isnan(OffshoreR);
OffshoreR(inan2) = [];
OffshoreDist(inan2) = [];

%fit
OffshoreExp = fit(OffshoreDist,OffshoreR,'exp1');
RMSos = sqrt((1/length(OffshoreDist))*sum((OffshoreR - feval(OffshoreExp,OffshoreDist)).^2));

%Cross-shelf exponetial fit
XShelfDist = reshape(CrossShelfDist, ...
    [length(CrossShelfDist(:,1))*length(CrossShelfDist(1,:)), 1]);
XShelfR = reshape(CrossShelfR, ...
    [length(CrossShelfR(:,1))*length(CrossShelfR(1,:)), 1]);

%clean NaNs
inan1 = isnan(XShelfDist);
XShelfDist(inan1) = [];
XShelfR(inan1) = [];
inan2 = isnan(XShelfR);
XShelfR(inan2) = [];
XShelfDist(inan2) = [];

%fit
XShelfExp = fit(XShelfDist, XShelfR, 'exp1');
RMSxs = sqrt((1/length(XShelfDist))*sum((XShelfR - feval(XShelfExp,XShelfDist)).^2));

%individual cross shelf fits
EXPval = NaN(78,2,length(CrossShelfDist(1,:)));
RMS = NaN(length(CrossShelfDist(1,:)),1);
for n = 1:length(CrossShelfDist(1,:))
    %select transect
    DIST = CrossShelfDist(:,n);
    R = CrossShelfR(:,n);
    
    %remove nans
    inan1 = isnan(DIST);
    DIST(inan1) = [];
    R(inan1) = [];
    inan2 = isnan(R);
    R(inan2) = [];
    DIST(inan2) = [];
        
    EXP = fit(DIST, R, 'exp1');
    vals = feval(EXP, DIST);
    [dist, I] = sort(DIST);
    
    EXPval(1:length(DIST),1:2,n) = [dist, vals(I)];
    
    RMS(n) = sqrt((1/length(DIST))*sum((R - feval(EXP, DIST)).^2));
    
end

%plot labels and titles
TITLE0 = ['Correlation Length Scale of ', NuteName, ...
    ' along ', RhoName, ' \sigma_\theta']; 
TITLE1 = {TITLE0, 'in Along-Shore Direction'};
TITLE3 = {TITLE0, ' in Cross-Shore Direction'};
LAB1 = 'Offshore Data';
LAB2 = ['Data Inshore of ', ISBname];
TITLE_NSR = ['Nearshore Residuals, RMS = ', num2str(RMSns, 2)];
TITLE_OSR = ['Offshore Residuals, RMS = ', num2str(RMSos, 2)];
TITLE_XSR = ['Cross-Shelf Residuals, RMS = ', num2str(RMSxs, 2)];
%plotting
set(gcf,'position',[1 35 1920 1046]);

subplot(3,2,1)
p1 = scatter(NearshoreDist,NearshoreR,'b');
hold on 
plot(NearshoreExp,'b')
p2 = scatter(OffshoreDist,OffshoreR,'k');
plot(OffshoreExp,'k');
line([0, 450], [0, 0], 'Color', 'm')
xlim([0, 450]);
ylim([-0.1, 1]);
title(TITLE1)
xlabel(' ');
ylabel('Correlation (r)');
legend([p2, p1],{LAB1, LAB2}, 'Location', 'northeast')

subplot(3,2,3)
scatter(NearshoreDist, NearshoreR - feval(NearshoreExp,NearshoreDist), 'b')
hold on
line([0, 450], [0, 0],'Color','b')
title(TITLE_NSR)
xlabel(' ')
ylabel('Residual Correlation')

subplot(3,2,5)
scatter(OffshoreDist, OffshoreR - feval(OffshoreExp,OffshoreDist), 'k')
hold on
line([0, 450], [0, 0],'Color','k')
title(TITLE_OSR)
xlabel('Alongshore Distance between stations (km)')
ylabel('Residual Correlation')


subplot(2,2,2)
for p = 1:6
    scatter(CrossShelfDist(:,p), CrossShelfR(:,p))
    hold on
end
hold on
plot(XShelfExp)
line([0, 700], [0, 0], 'Color', 'm');
xlim([0, 700]);
ylim([-0.1 1]);
xlabel(' ');
ylabel('Correlation (r)');
title(TITLE3);
legend('CalCOFI 76.7','CalCOFI 80.0','CalCOFI 83.3', 'CalCOFI 86.7', ...
    'CalCOFI 90.0','CalCOFI 93.3', 'Location','northeast')

subplot(2,2,4)
scatter(XShelfDist, XShelfR - feval(XShelfExp, XShelfDist))
hold on
line([0, 700], [0, 0], 'Color', 'r');
title(TITLE_XSR);
ylabel('Residual Correlation')
xlabel('Cross-Shore Distance between stations (km)');

%plot individual cross shelf fits
colvec = ['b', 'k', 'r', 'g', 'c', 'm'];
TitleLine = {['CalCOFI 76.7, RMS = ', num2str(RMS(1),2)],...
    ['CalCOFI 80.0, RMS = ', num2str(RMS(2),2)],...
    ['CalCOFI 83.3, RMS = ', num2str(RMS(3),2)],...
    ['CalCOFI 86.7, RMS = ', num2str(RMS(4),2)], ...
    ['CalCOFI 90.0, RMS = ', num2str(RMS(5),2)],...
    ['CalCOFI 93.3, RMS = ', num2str(RMS(6),2)]};
figure(2)
for n = 1:6
    subplot(3,2,n)
    scatter(CrossShelfDist(:,n),CrossShelfR(:,n), colvec(n))
    ylim([0, 1]);
    xlim([0, 600]);
    hold on
    plot(EXPval(:,1,n), EXPval(:,2,n), colvec(n))
    plot(XShelfExp, '--k')
    title(TitleLine(n));
    ylabel('correlation (r)')
    if (n == 5 || n == 6)
        xlabel('Offshore Distance (km)')
    else
        xlabel(' ')
    end
end
