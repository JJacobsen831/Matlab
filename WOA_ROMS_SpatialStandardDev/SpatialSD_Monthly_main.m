%Spatial map of number of standard deviations model output is away from WOA
clear;
addpath('/home/jjacob2/matlab/Evaluation/SpatialSD/Subroutines/')

%Model Output directory and file name
Fdir = '/home/jjacob2/matlab/Evaluation/SpatialSD/WC12_WOA_Output/';
%Fname = 'WOADomain_20180807_darwin_6p4z_noread2_p6.mat';
% Fname = 'WOADomain_20191213_darwin_6p4z_noread2_p6_2019Dec13inibry.mat';
Fname = 'WOADomain_20200214_darwin_6p4z_noread2_p6_2020Feb14inibry.mat';
%WOA file directory
WOAdir = '/home/jjacob2/matlab/WOA/ProcessedData/wc12_domain/MonthlyStats/';

%select level
level = 5;
tstep = 130;

%select variable: temp, salt, NO3, PO4, SiO2, O2
VarName = 'temp';
nObsThreshold = 1;

%subset variables and store in Output structure
Mod = load([Fdir, Fname]);
Output = VarSubSet(Mod, VarName, tstep);

%Select WOA dataset
[WOA_fname, MoName] = WOA_MonthFileName(Output);
load([WOAdir, WOA_fname]);

%Re-grid model to WOA grid (1D linear interp in z-dir)
IntGrd = Roms2WoaGrid(Output, VarName, WOA_stat);

%Compute number of standard deviations
numSD = SpatialSD_Monthly(IntGrd, WOA_stat, VarName, nObsThreshold);

ObsPerLev = squeeze(sum(sum(~isnan(numSD.nSD),1),2))

%plotting subroutine
figure(2)
nSD_Month_plt(numSD, level, VarName, MoName, Fname)



