%Cummulaitve Vertical Transport
clear;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig3C_CUTI/')

File = 'CUTI_daily.nc';

%indices of data
LatIDX = find(ncread(File,'latitude') == 41);

Year = ncread(File,'year');
UniYr = unique(Year);
UniYr(end) = [];


%CUTI at 41N
CUTI = NaN(366, length(UniYr));
for n = 1:length(UniYr)
    YrTime = find(UniYr(n) == Year);
    StrtTime = YrTime(1);
    nTime = length(YrTime);
    CUTI(1:nTime,n) = ncread(File,'CUTI',[LatIDX, StrtTime], [1, nTime]);
end

%Cumulative CUTI
CTI = cumsum(CUTI(:,25:31));
JDtime = 1:365;

for n = 1:size(CTI,2)
    HARMO(:,n) = FitHarmonic(JDtime', CTI(1:365,n));
end

CC = ['k';'b'; 'r'; 'g'; 'm'; 'y'; 'c'];

LAST = HARMO(365,:);
YrTxt = num2str(UniYr(25:31));


for n = [1, 3, 4, 6, 7]
    plot(HARMO(:,n), CC(n));
    hold on;
    plot(CTI(:,n), [':',CC(n)])
    text(370, LAST(n), YrTxt(n,:))
end


%median 
MED = nanmedian(CTI(1:365,:),2);


%Fit sine function to median
y = MED;
x = 1:365;
yu = max(y);
yl = min(y);
yr = (yu-yl);                               % Range of ‘y’
yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(y);                               % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                             % Least-Squares cost function
s = fminsearch(fcn, [yr;  per;  -1;  ym]);                     % Minimise Least-Squares
xp = linspace(min(x),max(x));               %Fit time
% figure(1)
% plot(x,y,'b',  xp,fit(s,xp), 'r')
% grid

%min and max and peak
for n = 1:length(CTI(1,:))
    CTImin(n) = find(CTI(:,n) == min(CTI(:,n)));
    CTImax(n) = find(CTI(:,n) == max(CTI(:,n)));
end
SpringTrans = mean(JDtime(CTImin));
FallTrans = mean(JDtime(CTImax));
PeakUP = ceil(xp(diff(fit(s,xp)) == max(diff(fit(s,xp)))));

%El Nino vs Not 2006 - 2018
CoolTimeIDX = [find(UniYr == 2008),...
    find(UniYr == 2011):find(UniYr==2013),...
    find(UniYr == 2017):find(UniYr == 2018)];
CoolText = {'2008','2011','2012','2013','2017','2018'};

WarmTimeIDX = [find(UniYr == 2006):find(UniYr == 2007),...
    find(UniYr == 2009):find(UniYr == 2010),...
    find(UniYr == 2014):find(UniYr == 2016)];
WarmText = {'2006', '2007', '2009', '2010', '2014','2015', '2016'};



figure(1)
%plot all years 2006 - 2018
for n = 26:31%1:length(CTI(1,:))
    plot(JDtime', CTI(:,31),'Color',[0.2 0.2 0.2])
    hold on
end
datetick('x','mmm')

%plot start and end of upwelling season
for n = 1:length(CTI(1,:))
    scatter(JDtime(CTImin(n)), CTI(CTImin(n),n),[],[0.7 0.7 0.7],'>')
    scatter(JDtime(CTImax(n)), CTI(CTImax(n),n),[],[0.7 0.7 0.7], '<')
    hold on
end

%plot median and sine fit
plot(JDtime(1:365),MED, ':k','LineWidth',2)
hold on
plot(xp, fit(s,xp), 'k','LineWidth',2)

%Cool Time
for n = 1:length(CoolTimeIDX)
    plot(JDtime, CTI(:,CoolTimeIDX(n)),'b')
    if (n ~= 4)
        text(370,CTI(365,CoolTimeIDX(n)),CoolText(n),'Color','b')
    else
        text(370,CTI(365,CoolTimeIDX(n))-5,CoolText(n),'Color','b')
    end
    hold on
end

%warm Time
for n = 1:length(WarmTimeIDX)
    plot(JDtime, CTI(:,WarmTimeIDX(n)),'r')
    if (n ~= 5)
        text(370,CTI(365,WarmTimeIDX(n)),WarmText(n),'Color','r')
    else
        text(370,CTI(365,WarmTimeIDX(n))-5,WarmText(n),'Color','r')
    end
    hold on
end

%Seasonal Lines
plot([SpringTrans, SpringTrans],[-100 350],'k')
plot([PeakUP, PeakUP],[-100, 350],'k')
plot([FallTrans, FallTrans],[-100, 350], 'k')
title('Cumulative CUTI 41^{\circ}N 1988 - 2018')
ylabel('Cumulative CUTI')
xlabel('Day of Year')
text(95, 340, 'Building Upwelling')
text(230, 340, 'Declining Upwelling')
text(330, 340, 'Storm Season')
text(10, 340, 'Storm Season')