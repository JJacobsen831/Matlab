%weighted average of THL
clear;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7/');

%TS and plot data
filedir = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/';
load([filedir 'THL_WtAverage']);
load([filedir 'THL_WtAvgStandardDev']);
load([filedir 'THL_AveBV.mat']);
load([filedir 'THL_bathy']);
bathy= th_bathy.bathy;
load([filedir 'THL_LonOI.mat']);
THL_LI = load([filedir 'THL_Data_May-2010_Oct-2017.mat']);

%GV and plot data
GVmat = load([filedir 'THL_WtAverage.mat']);
GVavg = GVmat.GVwt;

%plot variables
depth = THL_LI.th_hydro.pres;
lats = 41.03*ones(1,length(lonOI));
distdif = sw_dist(lats, lonOI, 'km');
dist=5+cumsum(distdif);
dist = -1*fliplr(dist);
dist = [dist -5];
LonMaxOI = max(dist);
LonMinOI = -36;
DepMax = 425;
DepMin = 0;
DenMax = max(max(max(Dwt)))-1000;
DenMax = ceil(DenMax);
DenMin = min(min(min(Dwt)))-1000;
DenMin = floor(DenMin);
DenSeq = DenMin:0.5:26.0;
AveDoi = Dwt-1000;

SP = 0.08; PD = 0; MA = 0.07;
%plotting
set(gcf,'Position',[819, 48, 1091, 1033]);
h1 = subaxis(3,2,1,'Spacing',SP,'Padding',PD,'Margin',MA);
%Temperature
[~,h] = contourf(dist,depth,Twt);
cmapT = cmocean('thermal',11);
colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([5 15]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'5','7.5','10','12.5','15'}, ...
               'XTick', 5:2.5:15);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','^{\circ}C');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
ylabel('Depth (m)');
title('Weighted Mean')
text(-10, 400, '(A)','FontWeight','bold')

%Temperature Standard Deviation
h2 = subaxis(3,2,2,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,Tstd);
cmapT = cmocean('tempo',11);
colormap(h2, cmapT);
set(h, 'edgecolor','none');
caxis([0 0.3])
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'0.05','0.1','0.15','0.2','0.25'}, ...
               'XTick', 0.05:0.05:0.25);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','^{\circ}C');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
title('Weighted SD')
text(-10, 400, '(B)','FontWeight','bold')
set(gca,'YTickLabel',[]);

%Salinity
h3 = subaxis(3,2,3,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,Swt);
cmapS = cmocean('haline',11);
colormap(h3, cmapS);
set(h, 'edgecolor','none');
caxis([32.3 34.2]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'32.4','32.8','33.2','33.6','34.0'}, ...
               'XTick', 32.4:0.4:34);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','PSU');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
ylabel('Depth (m)');
text(-10, 400, '(C)','FontWeight','bold')

%Salinity SD
h4 = subaxis(3,2,4,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,Sstd);
cmapT = cmocean('tempo',11);
colormap(h4, cmapT);
set(h, 'edgecolor','none');
caxis([0 0.14])
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'0.03','0.06','0.09','0.12'}, ...
               'XTick', 0.03:0.03:0.12);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','PSU');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
text(-10, 400, '(D)','FontWeight','bold')
set(gca,'YTickLabel',[]);

%GV
h5 = subaxis(3,2,5,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,GVwt);
cmapG = cmocean('balance',11);
colormap(h5,cmapG);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'-0.2','-0.1','0','0.1','0.2'}, ...
               'XTick', -0.2:0.1:02);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','m s^{-1}');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
ylabel('Depth (m)')
xlabel('Km from Shore')
text(-10, 400, '(E)','FontWeight','bold')

%GV SD
h6 = subaxis(3,2,6,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,GVstd);
cmapT = cmocean('tempo',8);
colormap(h6, cmapT);
set(h, 'edgecolor','none');
caxis([0 0.04])
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'0.01','0.02','0.03','0.04'}, ...
               'XTick', 0.01:0.01:0.04);
set(gca, 'Position',k)
set(get(hcb,'Title'),'String','m s^{-1}');
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, AveDoi, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
xlabel('Km from Shore');
text(-10, 400, '(F)','FontWeight','bold')
set(gca,'YTickLabel',[]);


%print('Fig2_WtMean','-dpng','-r300')           
