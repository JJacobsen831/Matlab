%Emergence of poleward flow
clear;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7ENSOAvg/');


%load
filedir = '/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7ENSOAvg/';
load([filedir 'THL_bathy.mat']);
load([filedir 'THL_DataOI10Bathy_May-2010_Oct-2017.mat']);
THL_LI = load([filedir 'THL_Data_May-2010_Oct-2017.mat']);
clear lon;
load([filedir 'THL_LonOI.mat']);
load([filedir 'THL_OI10Bathy_GeoVel.mat']);
load([filedir 'THL_timeComplete.mat']);

%import variables
T = Toib; S = Soib; pden = Doib;
bathy = th_bathy.bathy;
StationLon = THL_LI.th_hydro.lon;
ndepth = length(THL_LI.th_hydro.pres);
nlon = length(lonOI);

time = time01; clear time01 time02 time03 time04 time05
ntime = length(time);

timeyear = [year(datetime(datestr(time))), month(datetime(datestr(time)))];
Years = unique(year(datetime(datestr(time))));


YearIDX = NaN(12,length(Years));
for n = 1:length(Years)
    IDX = find(timeyear(:,1) == Years(n));
    nIDX = length(IDX);
    YearIDX(1:nIDX,n) = IDX;
end


%useful things
lats = 41.03*ones(1,length(lonOI));
distdif = sw_dist(lats, lonOI, 'km');
dist=5+cumsum(distdif);
dist = -1*fliplr(dist);
distGV = dist;
dist = [dist -5];
LonMaxOI = max(dist);
LonMinOI = min(dist);
DepMax = 425;
DepMin = 0;
% DenMax = max(max(max(Doi)))-1000;
% DenMax = ceil(DenMax);
% DenMin = min(min(min(Doi)))-1000;
% DenMin = floor(DenMin);
% DenSeq = DenMin:0.5:26.0;

for m = 1:size(YearIDX,2)
    figure(m)
    for n = 1:sum(~isnan(YearIDX(:,m)))
        h1 = subaxis(3,4,timeyear(YearIDX(n, m),2),'Spacing',0.05,'Padding',0.0,'Margin',0.1);
        %main plotting
        [~,h] = contourf(distGV,depth, squeeze(GeoVel(:,:,YearIDX(n,m))));
        axis ij
        ylim([0, 425]);
        title(num2str(YearIDX(n,m)));
        %colormap
        cmapV = cmocean('balance',11);
        colormap(h1, cmapV);
        set(h, 'edgecolor','none');
        caxis([-0.2 0.2]);
        k = get(gca,'Position');
        
        %colorbar
        if (n == 3)
            hcb = colorbar('XTickLabel',{'-0.2','-0.1','0','0.1','0.2'}, ...
                'XTick', -0.2:0.1:02);
            set(get(hcb,'Title'),'String','m s^{-1}');
        end
        set(gca, 'Position',k)
        
        %add shelf
        patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
            [bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
        
    end
end

FlowVec = [2, 4, 11, 12, 13, 19, 25, 26, 27, ...
    29:33, 36, 37, 42, 45, 46, 51, 52];
FlowTime = datestr(time(FlowVec,:));
save('FlowTime.mat','FlowTime')