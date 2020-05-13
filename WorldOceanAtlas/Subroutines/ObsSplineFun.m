function [NuteName, SplineFun, Rho] = ObsSplineFun(NuteNum)
% extract spline and evaluation points given 1=NO3 2=NO2 3=NH4 4=PO4 5=SiO4 6=DO

%observation spline Directory
splinedir = '/home/jjacob2/matlab/ModelDataComparison/ModelPerformanceMetric/ObsSplineData/';

%check if input is valid
if (NuteNum >6)
	disp('Choose valid Nutrient Number: 1=NO3 2=NO2 3=NH4 4=PO4 5=SiO4 6=DO')
	return
end
	

%load nutrient
if (NuteNum == 1)
    load([splinedir, 'NO3_ObsSpline.mat']);
    SplineFun = NO3_ObsSpline.SplineFun;
    Rho = NO3_ObsSpline.rho;
    NuteName = 'NO3';
elseif (NuteNum == 2)
    load([splinedir, 'NO2_ObsSpline.mat']);
    NuteName = 'NO2';
    SplineFun = NO2_ObsSpline.SplineFun;
    Rho = NO2_ObsSpline.rho;
elseif (NuteNum == 3)
    load([splinedir, 'NH4_ObsSpline.mat']);
    NuteName = 'NH4';
    SplineFun = NH4_ObsSpline.SplineFun;
    Rho = NH4_ObsSpline.rho;
elseif (NuteNum == 4)
    load([splinedir, 'PO4_ObsSpline.mat']);
    NuteName = 'PO4';
    SplineFun = PO4_ObsSpline.SplineFun;
elseif (NuteNum == 5)
    load([splinedir, 'SiO4_ObsSpline.mat']);
    NuteName = 'SiO2';
    SplineFun = SiO4_ObsSpline.SplineFun;
    Rho = SiO4_ObsSpline.rho;
elseif (NuteNum == 6)
    load([splinedir, 'DO_ObsSpline.mat']);
    NuteName = 'O2';
    SplineFun = DO_ObsSpline.SplineFun;
    Rho = DO_ObsSpline.rho;    
end

return