function [NuteName, SplineVal, Rho] = ObsSpline(NuteNum)
% extract spline and evaluation points given 1=NO3 2=NO2 3=NH4 4=PO4 5=SiO4 6=DO

%observation spline Directory
splinedir = '/home/jjacob2/matlab/Evaluation/ModelDataComparison/ModelPerformanceMetric/ObsSplineData/';

%check if input is valid
if (NuteNum >6)
	disp('Choose valid Nutrient Number: 1=NO3 2=NO2 3=NH4 4=PO4 5=SiO4 6=DO')
	return
end
	

%load nutrient
if (NuteNum == 1)
    load([splinedir, 'NO3_ObsSpline.mat']);
    SplineVal = NO3_ObsSpline.SplineVal;
    Rho = NO3_ObsSpline.rho;
    NuteName = 'NO3';
elseif (NuteNum == 2)
    load([splinedir, 'NO2_ObsSpline.mat']);
    NuteName = 'NO2';
    SplineVal = NO2_ObsSpline.SplineVal;
    Rho = NO2_ObsSpline.rho;
elseif (NuteNum == 3)
    load([splinedir, 'NH4_ObsSpline.mat']);
    NuteName = 'NH4';
    SplineVal = NH4_ObsSpline.SplineVal;
    Rho = NH4_ObsSpline.rho;
elseif (NuteNum == 4)
    load([splinedir, 'PO4_ObsSpline.mat']);
    SplineVal = PO4_ObsSpline.SplineVal;
    Rho = PO4_ObsSpline.rho;
    NuteName = 'PO4';
elseif (NuteNum == 5)
    load([splinedir, 'SiO4_ObsSpline.mat']);
    NuteName = 'SiO2';
    SplineVal = SiO4_ObsSpline.SplineVal;
    Rho = SiO4_ObsSpline.rho;
elseif (NuteNum == 6)
    load([splinedir, 'DO_ObsSpline.mat']);
    NuteName = 'O2';
    SplineVal = DO_ObsSpline.SplineVal;
    Rho = DO_ObsSpline.rho;    
end

return