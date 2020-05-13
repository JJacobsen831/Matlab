%San Jaun Channel CTD profiles
load('/home/jjacob2/matlab/SanJuanChannel/2019_08_05.mat')

%long channel stn index
stnidx = [1:6, 9];

AlongChan.sal = ctd.sal(:,stnidx);
AlongChan.temp = ctd.temp(:,stnidx);

%distance along transect
lat0 = ctd.lat(1);
lon0 = ctd.lon(1);

for n = stnidx
    lats = ctd.lat(n);
    lons = ctd.lon(n);
    dist(n) = sw_dist([lat0, lats], [lon0, lons]);
end
AlongChan.dist = dist(stnidx);

%s_bar
s_prime = NaN(size(AlongChan.sal));
for n = 1:size(AlongChan.sal, 2)
    s_prime(:,n) = svar(AlongChan.sal(:,n));
end
AlongChan.s_prim = s_prime;


figure(1)
subplot(2,1,1)
[~,h] = contourf(AlongChan.dist, ctd.depth, AlongChan.sal);
axis ij 
colorbar
set(h,'edgecolor','none')
ylim([0,120])
title('Along Channel Salinity')
xlabel('Km from southern station')
ylabel('depth (m)')

subplot(2,1,2)
[~,h] = contourf(AlongChan.dist, ctd.depth, AlongChan.s_prim);
axis ij 
colorbar
set(h,'edgecolor','none')
ylim([0,120])
title('Along Channel S^{prime}')
xlabel('Km from southern station')
ylabel('depth (m)')