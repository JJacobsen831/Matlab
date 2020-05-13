clear;
addpath('/home/jjacob2/matlab/m_map/');
addpath('/home/jjacob2/matlab/m_map/private/');

%initialize projection
m_proj('lambert','long',[-130 -116],'lat',[28 48]);

%1 min bathymetry
[CS,CH]=m_etopo2('contourf',[-6000:1000:-1000 -500 -100 -50 0],'edgecolor','none');

%single contour along 250 m
m_etopo2('contour',[-250, -251], 'edgecolor',[0.5843    0.8157    0.9882]);

%high-res coastline
m_gshhs_h('patch',[0.7 0.7 0.7],'edgecolor','none'); 

%Grid
m_grid('linest','none','tickdir','out','box','fancy','fontsize',10);

%bathymetry colormap
colormap(m_colmap('blues'));  
caxis([-7000 000]);
[ax,h]=m_contfbar([.50 .80],.89,CS,CH,'endpiece','no','axfrac',.02);
title(ax,'meters');

%marker for Cape Mendocino
[X, Y] = m_ll2xy(-124.2, 40.50);
text(X,Y,'Cape Mendocino');

%marker for Pt Sur
[X, Y] = m_ll2xy(-121.5, 36.3);
text(X,Y,'Pt. Sur');

%marker for NHL
[X, Y] = m_ll2xy(-123.9, 44.6);
text(X, Y, 'Newport OR');

%Line for THL
m_line([-124.2 -124.58], [41.05 41.05], 'linewidth', 2, 'Color','k');
%Inset for station position (maybe use what Eric provided)

% print('Fig1_Map','-dpng','-r300')