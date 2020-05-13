clear;
filedir = '/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7/';
load([filedir 'THL_bathy.mat']);
load([filedir 'InteranTHL.mat']);
THL_LI = load([filedir 'THL_Data_May-2010_Oct-2017.mat']);
clear lon;
load([filedir 'THL_LonOI.mat']);
load([filedir 'THL_OI10Bathy_GeoVel.mat']);
load([filedir 'THL_timeComplete.mat']);
load([filedir 'THL_AveBV.mat']);

%import variables
StationLon = THL_LI.th_hydro.lon;
bathy = th_bathy.bathy;
time = time01; clear time02 time03 time04 time05
StationLon = THL_LI.th_hydro.lon;
ndepth = length(THL_LI.th_hydro.pres);
nlon = length(lonOI);
ntime = 54;
depth = THL_LI.th_hydro.pres;

%dist from shore
lats = 41.03*ones(1,length(lonOI));
distdif = sw_dist(lats, lonOI, 'km');
dist=5+cumsum(distdif);
dist = -1*fliplr(dist);
dist = [dist -5];

%comute difference
Tdiff = NINO.T - NORM.T;
Sdiff = NINO.S - NORM.S;
Gdiff = NINO.GV - NORM.GV;


%plot limits
LonMaxOI = max(dist);
LonMinOI = -36;
DepMax = 425;
DepMin = 0;
Dwt = [NINO.Den; NORM.Den];
DenMax = max(max(max(Dwt)))-1000;
DenMax = ceil(DenMax);
DenMin = min(min(min(Dwt)))-1000;
DenMin = floor(DenMin);
DenSeq = DenMin:0.5:26.0;
DOmin = 0; DOmax=250; DOseq=DOmin:25:DOmax;
AveDoi = Dwt-1000;

%ploting 
%Column 1 Norm
set(gcf,'Position',[819, 48, 1091, 1033]);
h1 = subaxis(3,3,1,'Spacing',0.05,'Padding',0.0,'Margin',0.1);
%plot T
[~,h] = contourf(dist,depth,NORM.T);
cmapT = cmocean('thermal', 11);
colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([5 15]);
%set size of subplot
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylabel('Depth (m)');
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NORM.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NORM.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden,'Color', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
title('Years 2010-2013, 2017');
text(-10, 400, '(A)','FontWeight','bold')

%column 2 Nino
h2 = subaxis(3,3,2,'Spacing',0.05,'Padding',0,'Margin',0.1);
%plot T
[~,h] = contourf(dist,depth,NINO.T);
cmapT = cmocean('thermal',11);
colormap(h2, cmapT);
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
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NINO.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden, 'Color', [0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NINO.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden);
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
title('Warm Years 2014-2016')
text(-10, 400, '(B)','FontWeight','bold')

%column 3 difference
h7 =subaxis(3,3,3,'Spacing',0.05,'Padding',0,'Margin',0.1);
pos1 = get(h7,'Position');
pos1(1) = pos1+0.5;
set(h7, 'pos',pos1)
[~,h] = contourf(dist,depth,Tdiff);
;
cmapS = cmocean('delta',22);
colormap(h7, cmapS);
set(h, 'edgecolor','none');
caxis([-2 2]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'-2','-1','0','1','2'}, ...
               'XTick', -2:1:2);
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
set(gca,'YTickLabel',[]);
% %add isopycnals
% hold on
% [c, h_pden] = contour(dist,depth, NORM.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden, 'Color', [0.5 0.5 0.5]);
% set(h_pden,'linewidth',0.8);
% axis ij
% ylim([DepMin DepMax]);
% xlim([LonMinOI LonMaxOI]);
% %highlight 26.5 and 26.0
% [c, h_pden] = contour(dist,depth, NORM.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% % clabel(c, h_pden);
% set(h_pden,'linewidth',2);
% axis ij
% ylim([DepMin DepMax]);
% xlim([LonMinOI LonMaxOI]);
% text(-10, 400, '(C)','FontWeight','bold')




%column 1 Norm sal
h3 = subaxis(3,2,3,'Spacing',0.05,'Padding',0,'Margin',0.1);
%plot T
[~,h] = contourf(dist,depth,NORM.S);
cmapS = cmocean('haline',11);
colormap(h3, cmapS);
set(h, 'edgecolor','none');
caxis([32.3 34.2]);
k = get(gca,'Position');
% hcb = colorbar;
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylabel('Depth (m)');
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NORM.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden, 'Color', [0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NORM.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden);
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
text(-10, 400, '(C)','FontWeight','bold')

%column 2 NINO sal
h4 = subaxis(3,2,4,'Spacing',0.05,'Padding',0,'Margin',0.1);
%plot T
[~,h] = contourf(dist,depth,NINO.S);
cmapS = cmocean('haline',11);
colormap(h4, cmapS);
set(h, 'edgecolor','none');
clev = 32.3:0.2:34.2;
caxis([32.3 34.2]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'32.4','32.8','33.2','33.6','34.0'}, ...
               'XTick', 32.4:0.4:34);
set(gca, 'Position',k)
axis ij
set(get(hcb,'Title'),'String','PSU');
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NINO.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden, 'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NINO.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden) 
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
text(-10, 400, '(D)','FontWeight','bold')

%Norm GV
h5 = subaxis(3,2,5,'Spacing',0.05,'Padding',0,'Margin',0.1);
%plot T
[~,h] = contourf(dist(2:end),depth,NORM.GV);
cmapG = cmocean('balance',11);
colormap(h5, cmapG);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylabel('Depth (m)');
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NORM.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NORM.Den-1000, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
% clabel(c, h_pden);
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
xlabel('Km from Shore');
text(-10, 400, '(E)','FontWeight','bold')

%Nino GV
h6 = subaxis(3,2,6,'Spacing',0.05,'Padding',0,'Margin',0.1);
%plot T
[~,h] = contourf(dist(2:end),depth,NINO.GV);
cmapG = cmocean('balance',11);
colormap(h6, cmapG);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
hcb = colorbar('XTickLabel',{'-0.2','-0.1','0','0.1','0.2'}, ...
               'XTick', -0.2:0.1:02);
set(gca, 'Position',k)
axis ij
set(get(hcb,'Title'),'String','m s^{-1}');
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, NINO.Den-1000, DenSeq, 'linecolor', [0.5 0.5 0.5]);
clabel(c, h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.0
[c, h_pden] = contour(dist,depth, NINO.Den-1000, [26.5 26.25], 'linecolor',[0.5 0.5 0.5]);
% clabel(c,h_pden);
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
xlabel('Km from Shore');
text(-10, 400, '(F)','FontWeight','bold')
% print('Fig7_Interannual','-dpng','-r300')
