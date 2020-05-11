function wc12_plot(GrdData, level, lon, lat)

%Land Mask Vertices 
Lon = [-115.5, -115.5, -116.5, -117.5, -118.5, -119.5, -120.5, -120.5, ...
    -121.5, -122.5, -122.5, -123.5, -123.5, -123.5, -124.5, -123.5, -123.5, ...
    -123.5, -123.5, -124.5];
Lat = [47.5, 30.5, 30.5, 33.5, 34.5, 34.5, 34.5, 35.5, 36.5, 37.5, 38.5, ...
    39.5, 40.5, 41.5, 42.5, 43.5, 44.5, 45.5, 46.5, 47.5];
    
%color map
cmap = cmocean('balance',12);

%plotting
contourf(lon', lat, squeeze(GrdData(:,:,level)), 'edgecolor','none');
colormap(cmap);
h = colorbar;
caxis([-6, 6]);
patch(Lon,Lat, [0.5, 0.5, 0.5]);
set(get(h,'label'),'string','Difference')
title({'Experimental - ', 'Reference Run'})

return