function [NuteClean, RhoClean] = Clean2Var(Nute, Rho)
%clean NaN from two variables

%clean based on first variable
inan1 = isnan(Nute);
Rho(inan1) = [];
Nute(inan1) = [];

%clean based on remaining second variable
inan2 = isnan(Rho);
Nute(inan2) = [];
Rho(inan2) = [];

NuteClean = Nute;
RhoClean = Rho;

return