clear; close all;
addpath('/home/jjacob2/matlab/CCS_ObsData/THLFigures/Fig7/')
filedir = '/home/jjacob2/matlab/CCS_ObsData/TrinidadHeadLine/THL_Mat_Data/';
matfile = 'THL_MoClimOI10_May-2010_Oct-2017.mat';
load([filedir matfile]);
load([filedir 'THL_bathy']);
bathy= th_bathy.bathy;
load([filedir 'THL_LonOI.mat']);
Toi = Tclim; Soi = Sclim; Doi = Dclim;

A = ones(size(Tclim));

Dep = A.*depth;

Dcalc = sw_pden(squeeze(Sclim(:,:,1)),squeeze(Tclim(:,:,1)), squeeze(Dep(:,:,1)), 0);

SMLclim = nan*ones(length(lonOI),12);
for d=1:12
    for n=1:length(lonOI)
        SML_N = find(BVclim(:,n,d) == max(BVclim(:,n,d)));
        SMLclim(n,d) = depth(SML_N);
    end
end
%Chl=log10(CHLAclim);
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
DenMax = max(max(max(Doi)))-1000;
DenMax = ceil(DenMax);
DenMin = min(min(min(Doi)))-1000;
DenMin = floor(DenMin);
DenSeq = DenMin:0.5:26.0;
DateName = ['Jan'; 'Feb'; 'Mar'; 'Apr'; ...
    'May'; 'Jun'; 'Jul'; 'Aug'; ...
    'Sep'; 'Oct'; 'Nov'; 'Dec'];
for n =7:10
    AvgGV(:,:,n) = GVclim(:,:,n);
    AvgDn(:,:,n) = sw_pden(squeeze(Sclim(:,:,n)),squeeze(Tclim(:,:,n)), squeeze(Dep(:,:,n)), 0)-1000;
    AvgSML(:,:,n) = SMLclim(:,n);
end
GV = AvgGV(:,:,7:10);
Den = AvgDn(:,:,7:10);
SML = AvgSML(:,:,7:10);
TITLE = DateName(7:10,:);
set(gcf,'Position',[680, 40, 1237, 1041]);
for n=1:4
%select data
AveGV = GV(:,:,n);
AveDoi = Den(:,:,n);
AveSML = SML(:,n);

%ploting
h1 = subaxis(2,2,n,'Spacing',0.05,'Padding',0.0,'Margin',0.1);

[~,h] = contourf(distGV,depth,AveGV);
cmapT = cmocean('balance',11);


colormap(h1, cmapT);
set(h, 'edgecolor','none');
caxis([-0.2 0.2]);
k = get(gca,'Position');

%colorbar labels
if (n == 2 || n == 4)
    hcb = colorbar('XTickLabel',{'-0.2','-0.1','0','0.1','0.2'}, ...
               'XTick', -0.2:0.1:02);
    set(get(hcb,'Title'),'String','m s^{-1}');
end

set(gca, 'Position',k)
axis ij
%add shelf
patch([dist(1) dist(end) dist(end) fliplr(dist)], ...
	[bathy(1) bathy(1) bathy(end) fliplr(bathy)],[0.5 0.5 0.5])
%add isopycnals
hold on
CL = [0.5 0.5 0.5];

[c, h_pden] = contour(dist,depth, AveDoi, DenSeq, 'linecolor', CL);
clabel(c,h_pden,'Color',CL);
set(h_pden,'linewidth',0.8);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
%highlight 26.5 and 26.25
hold on
CVal = [26.5 26.25];
[c, h_pden] = contour(dist,depth, AveDoi, CVal, 'linecolor',CL);
% clabel(c,h_pden, 'Color',CL)
set(h_pden,'linewidth',2);
axis ij
ylim([DepMin DepMax]);
xlim([LonMinOI LonMaxOI]);
title(TITLE(n,:));
%axis labels on out side
if (n == 1 || n == 3)
    ylabel('Depth (m)');
end

if(n == 3 || n == 4)
    xlabel('Km from Shore')
end

end


%print('Fig5_GVJulOct','-dpng','-r300')