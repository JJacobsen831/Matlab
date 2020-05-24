addpath('/auto/home/jjacob2/matlab/roms_wilkin/')
addpath('/auto/home/jjacob2/matlab/roms_wilkin/snctools/')
addpath('/auto/home/jjacob2/runs/GridChange/AnaFileChange/CourserGridDT750/')
% Set dir
filedir1 = '/auto/home/jjacob2/runs/bio_toy/bio01/'; % select file
filename1 = 'ocean_his.nc';
File = [filedir1, filename1];
phyt = ncread(File,'phytoplankton');



% load grid file 
g = roms_get_grid(File,File);
% Extract ocean time
ntime = length(squeeze(phyt(1,1,1,:)));
ndepth = length(squeeze(phyt(1,1,:,1)));
% compute plotting grid based on length of time
Pgrid = ceil(sqrt(ntime));
% Extract cross-section view for each ocean time t
for t = 1:ntime
    T_jslice = roms_jslice(File,'phytoplankton', t,5,g);
    subplot(Pgrid, Pgrid, t);
    contourf(T_jslice);
    colorbar;
    caxis([0.02 0.09]);
    axis ij
end

p_pro = NaN(ndepth,ntime);
for t=1:ntime
    p_pro(:,t) = squeeze(phyt(4,4,:,t));
end
