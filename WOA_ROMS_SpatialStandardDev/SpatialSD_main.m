%Spatial map of number of standard deviations model output is away from WOA
clear;
addpath('/home/jjacob2/matlab/Evaluation/SpatialSD/Subroutines/')

%Load Model Output
Fdir = '/home/jjacob2/matlab/Evaluation/SpatialSD/WC12_WOA_Output/';
Fname = 'WOADomain_20200416_darwin_6p4z_noread2_p6_2020Apr16inibry.mat';
Mod = load([Fdir, Fname]);

%WOA file directory
WOAdir = '/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/';
load([WOAdir, 'WOA18_wc12Stat.mat']);

%select level
level = 12;
tstep = 25;

%select variable: temp, salt, NO3, PO4, SiO2, O2
VarName = 'NO3';
nObsThreshold = 5;

%subset variables and store in Output structure
Output = VarSubSet(Mod, VarName, tstep);

%Re-grid model to WOA grid (1D linear interp in z-dir)
IntGrd = Roms2WoaGrid(Output, VarName, WOA_stat);

%Interpolate to WOA grid
% select month to compare to
%   & compute number of standard deviations
numSD = SpatialSD_wc12(Output, VarName, nObsThreshold);

%plotting subroutine
WOA_wc12_plt(numSD, level, VarName)



%print('SpatialSD_20m','-dpng','-r150')


