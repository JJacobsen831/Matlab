clear; close all;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig8EmergePersist/');
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7ENSOAvg/');
Avfiledir = '/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig8EmergePersist/';
matfile = 'WarmMoAvg.mat';
load([Avfiledir matfile]);
Tclim = Warm.Temp;
Sclim = Warm.Sal;
Dclim = Warm.Rho;
GVclim = Warm.GV;


filedir = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/';
load([filedir 'THL_bathy']);
clear DOclim;
% DOfiledir = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_DO/';
% Oxy = load([DOfiledir 'THL_DO_Clim.mat']);
% DOclim = Oxy.DOclim;
% load([filedir 'THL_LI_AOUclim.mat']);
THL = load([Avfiledir, 'THL_DataOI10Bathy_May-2010_Oct-2017']);
depth = THL.depth;
bathy= th_bathy.bathy;
load([filedir 'THL_LonOI.mat']);
lats = 41.03*ones(1,length(lonOI));
distdif = sw_dist(lats, lonOI, 'km');
dist=5+cumsum(distdif);
dist = -1*fliplr(dist);
dist = [dist -5];
pres = depth*ones(1,76);

%weights
WarmN = [1, 2, 2; 2, 2, 2; 0, 2, 2; 3, 2, 2];
WarmSeasN = sum(WarmN,2);
for n = 1:size(WarmSeasN,1)
    WarmWts(n,:) = WarmN(n,:)./WarmSeasN(n);
end

%Dec Jan Feb 
DJF = [1 2 12];
DJF_Told = nanmean(Tclim(:,:,DJF),3);

DJF_T = Tclim(:,:,12)*WarmWts(1,1)+Tclim(:,:,DJF(1))*WarmWts(1,2)+Tclim(:,:,2)*WarmWts(1,3);
MAM_T = Tclim(:,:,3)*WarmWts(2,1)+Tclim(:,:,4)*WarmWts(2,2)+Tclim(:,:,2)*WarmWts(2,3);

DJF_S = nanmean(Sclim(:,:,1:3),3);
DJF_D = nanmean(Dclim(:,:,DJF),3)-1000;
% DJF_DO = nanmean(DOclim(:,:,DJF),3);
% DJF_AOU = nanmean(AOUclim(:,:,DJF),3);
DJF_GV = nanmean(GVclim(:,:,DJF),3);
DJF_GV_std = nanstd(GVclim(:,:,DJF),0,3);
DJF_GV_StdEr = DJF_GV_std./sqrt(10);
% DJF_BV = sw_bfrq(DJF_S, DJF_T, pres);
% DJF_SML = nan*ones(length(lonOI),1);
% for n=1:length(lonOI)
%     SML_N = find(DJF_BV(:,n) == max(DJF_BV(:,n)));
%     DJF_SML(n) = depth(SML_N);
% end
%Mar Apr May 
MAM = 3:1:5;
MAM_T = nanmean(Tclim(:,:,MAM),3);
MAM_S = nanmean(Sclim(:,:,MAM),3);
MAM_D = nanmean(Dclim(:,:,MAM),3)-1000;
% MAM_DO = nanmean(DOclim(:,:,MAM),3);
% MAM_AOU = nanmean(AOUclim(:,:,MAM),3);
MAM_GV = nanmean(GVclim(:,:,MAM),3);
MAM_GV_std = nanstd(GVclim(:,:,MAM),0,3);
MAM_GV_StdEr = MAM_GV_std./sqrt(14);
% MAM_BV = sw_bfrq(MAM_S, MAM_T, pres);
% MAM_SML = nan*ones(length(lonOI),1);
% for n=1:length(lonOI)
%     SML_N = find(MAM_BV(:,n) == max(MAM_BV(:,n)));
%     MAM_SML(n) = depth(SML_N);
% end
%Jun Jul Aug 
JJA = 6:1:8;
JJA_T = nanmean(Tclim(:,:,JJA),3);
JJA_S = nanmean(Sclim(:,:,JJA),3);
JJA_D = nanmean(Dclim(:,:,JJA),3)-1000;
% JJA_DO = nanmean(DOclim(:,:,JJA),3);
% JJA_AOU = nanmean(AOUclim(:,:,JJA),3);
JJA_GV = nanmean(GVclim(:,:,JJA),3);
JJA_GV_std = nanstd(GVclim(:,:,JJA),0,3);
JJA_GV_StdEr = JJA_GV_std./sqrt(15);
% JJA_BV = sw_bfrq(JJA_S, JJA_T, pres);
% JJA_SML = nan*ones(length(lonOI),1);
% for n=1:length(lonOI)
%     SML_N = find(JJA_BV(:,n) == max(JJA_BV(:,n)));
%     JJA_SML(n) = depth(SML_N);
% end
%Sep Oct Nov 
SON = 9:1:11;
SON_T = nanmean(Tclim(:,:,SON),3);
SON_S = nanmean(Sclim(:,:,SON),3);
SON_D = nanmean(Dclim(:,:,SON),3)-1000;
% SON_DO = nanmean(DOclim(:,:,SON),3);
% SON_AOU = nanmean(AOUclim(:,:,SON),3);
SON_GV = nanmean(GVclim(:,:,SON),3);
SON_GV_std = nanstd(GVclim(:,:,SON),0,3);
SON_GV_StdEr = SON_GV_std./sqrt(15);
SON_BV = sw_bfrq(SON_S, SON_T, pres);
% SON_SML = nan*ones(length(lonOI),1);
% for n=1:length(lonOI)
%     SML_N = find(SON_BV(:,n) == max(SON_BV(:,n)));
%     SON_SML(n) = depth(SML_N);
% end
%useful things
LonMaxOI = max(dist);
LonMinOI = -36;
DepMax = 425;
DepMin = 0;
DenMax = max(max(max(Dclim)))-1000;
DenMax = ceil(DenMax);
DenMin = min(min(min(Dclim)))-1000;
DenMin = floor(DenMin);
DenSeq = DenMin:0.5:26.0;
% DOmin = 0; DOmax=250; DOseq=DOmin:25:DOmax;

%
%
%Plotting 4x3 season x parameter
%
SP = 0.05; PD = 0.0; MA = 0.08;
%
set(gcf,'Position',[680, 40, 1237, 1041]);
h1 = subaxis(3,4,1,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,DJF_T);
cmapT = cmocean('thermal',11);
colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([5 15]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, DJF_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, DJF_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
title('Winter');
text(-10, 400, '(A)','FontWeight','bold')
ylabel('Depth (m)');

%MAM
h2 = subaxis(3,4,2,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,MAM_T);
cmapT = cmocean('thermal',11);
colormap(h2, cmapT);
set(h, 'edgecolor','none');
caxis([5 15]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, MAM_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, MAM_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
title('Spring');
text(-10, 400, '(B)','FontWeight','bold')

%JJA
h3 = subaxis(3,4,3,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,JJA_T);
cmapT = cmocean('thermal',11);
colormap(h3, cmapT);
set(h, 'edgecolor','none');
caxis([5 15]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, JJA_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, JJA_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
title('Summer');
text(-10, 400, '(C)','FontWeight','bold')

%SON
h4 = subaxis(3,4,4,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,SON_T);
cmapT = cmocean('thermal',11);
colormap(h4, cmapT);
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
[c, h_pden] = contour(dist,depth, SON_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, SON_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
title('Fall');
text(-10, 400, '(D)','FontWeight','bold')
%
%
%Salinity
%
%
h1 = subaxis(3,4,5,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,DJF_S);
cmapT = cmocean('haline',11);
colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([32.3 34.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, DJF_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, DJF_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
text(-10, 400, '(E)','FontWeight','bold')
ylabel('Depth (m)');

%MAM
h2 = subaxis(3,4,6,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,MAM_S);
cmapT = cmocean('haline',11);
colormap(h2, cmapT);
set(h, 'edgecolor','none');
caxis([32.3 34.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, MAM_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, MAM_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
text(-10, 400, '(F)','FontWeight','bold')

%JJA
h3 = subaxis(3,4,7,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,JJA_S);
cmapT = cmocean('haline',11);
colormap(h3, cmapT);
set(h, 'edgecolor','none');
caxis([32.3 34.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, JJA_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, JJA_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
text(-10, 400, '(G)','FontWeight','bold')

%SON
h4 = subaxis(3,4,8,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist,depth,SON_S);
cmapT = cmocean('haline',11);
colormap(h4, cmapT);
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

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, SON_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, SON_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
text(-10, 400, '(H)','FontWeight','bold')

%
%
%Velocity
%
%

h1 = subaxis(3,4,9,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,DJF_GV);
cmapT = cmocean('balance',11);
colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, DJF_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, DJF_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
text(-10, 400, '(I)','FontWeight','bold')
ylabel('Depth (m)');
xlabel('Km from Shore');

%MAM
h2 = subaxis(3,4,10,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,MAM_GV);
cmapT = cmocean('balance',11);
colormap(h2, cmapT);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, MAM_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, MAM_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
xlabel('Km from Shore');
text(-10, 400, '(J)','FontWeight','bold')

%JJA
h3 = subaxis(3,4,11,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,JJA_GV);
cmapT = cmocean('balance',11);
colormap(h3, cmapT);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');
set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, JJA_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, JJA_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
xlabel('Km from Shore');
text(-10, 400, '(K)','FontWeight','bold')

%SON
h4 = subaxis(3,4,12,'Spacing',SP,'Padding',PD,'Margin',MA);
[~,h] = contourf(dist(2:end),depth,SON_GV);
cmapT = cmocean('balance',11);
colormap(h4, cmapT);
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

ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%add isopycnals
hold on
[c, h_pden] = contour(dist,depth, SON_D, DenSeq, 'linecolor',...
    [0.5 0.5 0.5]);
clabel(c,h_pden,'Color',[0.5 0.5 0.5]);
set(h_pden,'linewidth',0.8);
%highlight 26.5 and 26.0
[~, h_pden] = contour(dist,depth, SON_D, [26.5 26.25], 'linecolor', [0.5 0.5 0.5]);
set(h_pden,'linewidth',2);
%labels
xlabel('Km from Shore');
text(-10, 400, '(L)','FontWeight','bold')
TITLE_UP('Warm Years 2014 - 2016')
%print('Fig8B_SeasonalClimWarm','-dpng','-r300')