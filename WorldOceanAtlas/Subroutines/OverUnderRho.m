function [Over, Under] = OverUnderRho(ModRho, Nute, ObsSplineVal, Rho)
%over under spline metric for nutrients

%fit spline to nutrient density relationship
Knots = 23:0.5:28.5; %origonally 23:0.25:28.5
[Nutemod, ModRho] = Clean2Var(Nute,ModRho);
[NuteSplnFun, ~, ~, ~] = SplineFitAndResidual(Nutemod, ModRho, Knots);

%compute difference from Obs Spline
NuteDiff = ObsSplineVal - fnval(NuteSplnFun,Rho);

%Under Over metric
Under = sum(NuteDiff(NuteDiff > 0));
Over = sum(NuteDiff(NuteDiff < 0));

return