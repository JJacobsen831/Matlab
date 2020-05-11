%Extract Model Output on WC12 grid to match WOA grid
clear;

addpath('/home/jjacob2/matlab/Evaluation/SpatialSD/Subroutines/');

%load WOA 
load('/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/WOA18_wc12Stat.mat');

%file location
% FileDir = '/home/pmattern/da/ref_runs/20180807_darwin_6p4z_noread2_p6/Output/';
% FileDir = '/home/pmattern/da/ref_runs/20191213_darwin_6p4z_noread2_p6_2019Dec13inibry/Output/';
% FileDir = '/home/pmattern/free_runs/20200214_darwin_6p4z_noread2_p6_2020Feb14inibry/output/';
%FileDir = '/home/jmattern/free_runs/20200416_darwin_6p4z_noread2_p6_2020Apr16inibry/Output/';
FileDir = '/home/pmattern/free_runs/20200416_darwin_6p4z_noread2_p6_2020Apr16inibry/output/';
File = 'wc12_his.nc';

%extract model locations
ModLat = ncread([FileDir, File],'lat_rho');
ModLon = ncread([FileDir, File],'lon_rho');

%extract WOA locations
WOALat = WOA_stat.phys.lat;
WOALon = WOA_stat.phys.lon;

%ID WOA locations in model output (WC12 only!!!)
IdxLat = 6:10:176;
IdxLon = 6:10:186;

%extraction parameters
% Lon, Lat, Depth, Time
VarNames = {'temp'; 'salt'; 'NO3'; 'PO4'; 'SiO2'; 'O2'};

start = [6, 6, 1, 1];
count = [length(WOALon), length(WOALat), Inf, Inf];
stride = [10, 10, 1, 14];
ntime = ceil(length(ncread([FileDir, File],'ocean_time'))/stride(end));

%Extract Variables
tic
Output.temp = ncread([FileDir, File], VarNames{1}, start, count, stride);
Output.salt = ncread([FileDir, File], VarNames{2}, start, count, stride);
Output.NO3 = ncread([FileDir, File], VarNames{3}, start, count, stride);
Output.PO4 = ncread([FileDir, File], VarNames{4}, start, count, stride);
Output.SiO2 = ncread([FileDir, File], VarNames{5}, start, count, stride);
Output.O2 = ncread([FileDir, File], VarNames{6}, start, count, stride);
toc

%physical variables
lon = ModLon(IdxLon, IdxLat);
lat = ModLat(IdxLon, IdxLat);
Output.lon = lon;
Output.lat = lat;

depth = ModelDepth([FileDir, File]);
Output.depth = depth(IdxLon, IdxLat,:);

mod_time = ncread([FileDir, File], 'ocean_time', 1, Inf, 14);

Output.time = mod_time;

for n = 1:length(mod_time)
    T(n) = dayvec(mod_time(n));
end

save('WOADomain_20200416_darwin_6p4z_noread2_p6_2020Apr16inibry','Output')
