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
[nsL1, nsSigmaL, nsL2, nsSigmaL2, nsScale, nsSigma_bf] = ParameterError(StnPairDist(:,1), StnPairR(:,1));
%order by dist
[NSDist, NSI] = sort(StnPairDist(:,1));
%Best fit exponential
nsF = 1*exp(-1*StnPairDist(:,1)/nsScale);
nsFIT = nsF(NSI);
%upper limit error
nsFlow = 1*exp(-1*StnPairDist(:,1)/nsL2);
nsFITlow = nsFlow(NSI);
%lower limit error
nsFhi = 1*exp(-1*StnPairDist(:,1)/nsL1);
nsFIThi = nsFhi(NSI);

%
%offshore
OffshoreDist = reshape(StnPairDist(:,2:end),...
    [length(StnPairDist(:,1))*length(StnPairDist(1,2:end)), 1]);
OffshoreR = reshape(StnPairR(:,2:end),...
    [length(StnPairR(:,1))*length(StnPairR(1,2:end)), 1]);
[osL1, osSigmaL, osL2, osSigmaL2, osScale, osSigma_bf] = ParameterError(OffshoreDist, OffshoreR);
%order by dist
[OSDist, OSI] = sort(OffshoreDist);
%Best fit exponential
osF = 1*exp(-1*OffshoreDist/osScale);
osFIT = osF(OSI);
%upper limit error
osFlow = 1*exp(-1*OffshoreDist/osL2);
osFITlow = osFlow(OSI);
%lower limit error
osFhi = 1*exp(-1*OffshoreDist/osL1);
osFIThi = osFhi(OSI);
%
%Cross-shelf exponetial fit
XShelfDist = reshape(CrossShelfDist, ...
    [length(CrossShelfDist(:,1))*length(CrossShelfDist(1,:)), 1]);
XShelfR = reshape(CrossShelfR, ...
    [length(CrossShelfR(:,1))*length(CrossShelfR(1,:)), 1]);
[xsL1, xsSigmaL, xsL2, xsSigmaL2, xsScale, xsSigma_bf] = ParameterError(XShelfDist, XShelfR);
%order by dist
[XSDist, XSI] = sort(XShelfDist);
%Best fit exponential
xsF = 1*exp(-1*XShelfDist/xsScale);
xsFIT = xsF(XSI);
%upper limit error
xsFlow = 1*exp(-1*XShelfDist/xsL2);
xsFITlow = xsFlow(XSI);
%lower limit error
xsFhi = 1*exp(-1*XShelfDist/xsL1);
xsFIThi = xsFhi(XSI);

% %individual cross shelf fits
% EXPval = NaN(78,2,length(CrossShelfDist(1,:)));
% RMS = NaN(length(CrossShelfDist(1,:)),1);
% for n = 1:length(CrossShelfDist(1,:))
%     %select transect
%     DIST = CrossShelfDist(:,n);
%     R = CrossShelfR(:,n);
%     
%     [sfL1, sfSigmaL, sfL2, sfSigmaL2, sfScale, sfSigma_bf] = ParameterError(OffshoreDist, OffshoreR);
%     
%    
%     [dist, I] = sort(DIST);
%     
%     EXPval(1:length(DIST),1:2,n) = [dist, vals(I)];
%     
%     RMS(n) = sqrt((1/length(DIST))*sum((R - feval(EXP, DIST)).^2));
%     
% end

%plot labels and titles
TITLE0 = ['Correlation Length Scale of ', NuteName, ...
    ' along ', RhoName, ' \sigma_\theta']; 
TITLE1 = {TITLE0, 'in Along-Shore Direction inshore of 100 km', ...
    ['is ', num2str(nsScale,3), ' km']};
TITLE2 = {TITLE0, 'in Along-Shore Direction offshore of 100 km', ...
    ['is ', num2str(osScale,3), ' km']};
TITLE3 = {TITLE0, ' in Cross-Shore Direction',...
    ['is ', num2str(xsScale,3), ' km']};

%plotting
set(gcf,'position',[1 35 1920 1046]);
subplot(2,2,1)
scatter(StnPairDist(:,1),StnPairR(:,1),'b');
hold on 
plot(NSDist, nsFIT,'b', 'LineWidth', 2)
text(100,0.8, ['L = ', num2str(nsL1,3), ' km'])
plot(NSDist, nsFITlow, '--r', 'LineWidth', 2)
text(100, 0.1, ['L = ', num2str(nsL2,3), ' km'])
plot(NSDist, nsFIThi, '--k', 'LineWidth', 2)
xlim([0 450])
ylim([-0.1 1])
ylabel('Correlation (r)');
title(TITLE1)

subplot(2,2,3)
scatter(OffshoreDist,OffshoreR,'k');
hold on 
plot(OSDist, osFIT,'k', 'LineWidth', 2)
plot(OSDist, osFITlow, '--r', 'LineWidth', 2)
text(100, 0.55, ['L = ', num2str(osL1,3), ' km'])
plot(OSDist, osFIThi, '--b', 'LineWidth', 2)
text(100, 0.05, ['L =' num2str(osL2,3), ' km'])
xlim([0 450])
ylim([-0.1 1])
title(TITLE2)
xlabel('Alongshore Distance between stations (km)')

subplot(2,2,2)
for p = 1:6
    scatter(CrossShelfDist(:,p), CrossShelfR(:,p))
    hold on
end
hold on
plot(XSDist, xsFIT, 'r', 'LineWidth', 2)
plot(XSDist, xsFITlow, '--k', 'LineWidth', 2)
text(75, 0.8, ['L =', num2str(xsL1, 3), ' km'])
text(75, 0, ['L =', num2str(xsL2,3),' km'])
plot(XSDist, xsFIThi, '--b', 'LineWidth', 2)
xlabel('Cross-Shore Distance between stations (km)');
ylabel('Correlation (r)')
ylim([-0.1, 1])
title(TITLE3);
legend('CalCOFI 76.7','CalCOFI 80.0','CalCOFI 83.3', 'CalCOFI 86.7', ...
    'CalCOFI 90.0','CalCOFI 93.3', 'Location','northeast')

subplot(2,2,4)
scatter(XShelfDist, XShelfR - feval(XShelfExp, XShelfDist))
hold on
line([0, 700], [0, 0], 'Color', 'r');
title(TITLE_XSR);
ylabel('Residual Correlation')


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
