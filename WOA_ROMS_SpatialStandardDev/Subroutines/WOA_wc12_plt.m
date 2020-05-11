function WOA_wc12_plt(numSD, level, VarName)
%Plot number of standard deviations model output is from WOA18

%Land Mask Vertices 
Lon = [-115.5, -115.5, -116.5, -117.5, -118.5, -119.5, -120.5, -120.5, ...
    -121.5, -122.5, -122.5, -123.5, -123.5, -123.5, -124.5, -123.5, -123.5, ...
    -123.5, -123.5, -124.5];
Lat = [47.5, 30.5, 30.5, 33.5, 34.5, 34.5, 34.5, 35.5, 36.5, 37.5, 38.5, ...
    39.5, 40.5, 41.5, 42.5, 43.5, 44.5, 45.5, 46.5, 47.5];
    
%color map
cmap = cmocean('balance',12);

%plot SD
contourf(numSD.lon, numSD.lat, squeeze(numSD.nSD(:,:,level)), 'edgecolor','none');
colormap(cmap);
h = colorbar;
caxis([-3, 3]);
patch(Lon, Lat, [0.5 0.5 0.5]);
set(get(h,'label'),'string','Standard Deviation')
title({(VarName), [num2str(numSD.depth(level)),' meter Depth Level']})
jtext('Domain20180807-darwin-6p4z-noread2-p6 initial')


%plot SD 1, 2, 3, contours
% [~, c] = contour(numSD.lon, numSD.lat, squeeze(numSD.nSD(:,:,level)), -3:1:3, 'ShowText','on');
% c.LineWidth = 1;
% c.LineColor = 'k';


return