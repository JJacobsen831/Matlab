function z = ModelDepth(File)
%compute depth throughout ROMS domain. Assume average free surface

%load variables to compute depth
Vtransform = ncread(File,'Vtransform');     % vertical transform scheme
Vstretching = ncread(File,'Vstretching');    % vertical stretching scheme
igrid = 1;                          %rho points
N = length(ncread(File, 's_rho'));  %number of s-levels
theta_s = ncread(File, 'theta_s');  %s-coord surface control parameter
theta_b = ncread(File, 'theta_b');  %s-coord bottom control parameter
hc = ncread(File, 'hc');            %S-coord parameter, critical depth
h = ncread(File, 'h');              %Bathymetry at rho-points
zeta = ncread(File, 'zeta');        %Free-surface
Avg_zeta = nanmean(zeta, 3);        % ASSUME average free surface (+/- 0.04 m)

%compute depth throughout domain
z = set_depth(Vtransform, Vstretching, theta_s, theta_b, hc, N, igrid, ...
    h, Avg_zeta);

return