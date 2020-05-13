function [lss, SplnVal, NuteSplnResidual, RHO] = OptSplineFit(Nutes, Rhos, Knots)
%Least squares spline, knots: 23:0.25:28.5 w/ 2 cont. deriv and residual

% find size of input and reshape to mx1
RowSize = length(Nutes(:,1));
ColSize = length(Nutes(1,:));
NuteVector = reshape(Nutes,[RowSize*ColSize, 1]);
RhoVector = reshape(Rhos,[RowSize*ColSize, 1]);

%Clean NaN
[NuteVec, RhoVec] = Clean2Var(NuteVector, RhoVector);

%sort based on rho
[RHO, I] = sort(RhoVec);
Nute = NuteVec(I);

%reduce size of input


%Knots and derivs order for spline
L = Knots;          % number of interior polynomial pieces (Knots)
K = 4;              % K - 2 continuous derivatives

%compute spline
lss2 = spap2(L,K,RHO,Nute);
lss1 = spap2(newknt(lss2), K, RHO,Nute);
lss = spap2(newknt(lss1), K, RHO,Nute);

%evaluate spline
SplnVal = fnval(lss,RHO);

%compute residual from spline
NuteSplnResidual = Nute - SplnVal;

return