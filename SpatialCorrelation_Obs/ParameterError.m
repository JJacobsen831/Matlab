function [L1, SigmaL, L2, SigmaL2, Scale, Sigma_bf] = ParameterError(StnPairDist, StnPairR)
% compute variablility/error of exponential parameter fit

%clean variables
NearshoreDist = StnPairDist;
NearshoreR = StnPairR;

inan1 = isnan(NearshoreDist);
NearshoreDist(inan1) = [];
NearshoreR(inan1) = [];

inan2 = isnan(NearshoreR);
NearshoreR(inan2) = [];
NearshoreDist(inan2) = [];

%define independent variable and obs
x = NearshoreDist;
yi = NearshoreR;

%model elements
N = length(NearshoreR);
sigma = std(yi);

% length scale guess between 50 and 600 km <==== CHANGE THIS IF ERROR =====
L = 50:(550/length(x)):599;

%force scale parameter to go through 1
y0 = 1;

%compute X2 for different length scales using sd of obs
X2o = NaN(length(x),1);
for m = 1:length(x)
    X2o(m) = (1/(N-1))*sum((yi-y0*exp(-x/L(m))).^2)/sigma^2;
end

%find optimum length scale
Scale = L(X2o == min(X2o));

% standard deviation/residual for best fit
Sigma_bf = (1/(N-1))*sum((yi-y0*exp(-x/Scale)).^2);

% recompute X2 using best fit residual
X2 = NaN(length(x),1);
for m = 1:length(x)
    X2(m) = (1/(N-1))*sum((yi-y0*exp(-x/L(m))).^2)/Sigma_bf;
end

%divide domain into two
X2a = X2(1:find(X2 == min(X2)));
X2b = X2(find(X2 == min(X2)):end);

% find length scale for above and below optimum model
ScaleERlow = L(X2a == X2a(abs(X2a-2*min(X2)) == min(abs(X2a - 2*min(X2)))));
ScaleER = L(X2b == X2b(abs(X2b-2*min(X2)) == min(abs(X2b - 2*min(X2)))));

%compute sigmas
SigmaL = abs(ScaleER - Scale);
SigmaL2 = abs(ScaleERlow - Scale);

L1 = ScaleER;
L2 = ScaleERlow;
return
% scatter(L, X2)
% hold on
% line([ScaleER ScaleER], [0 3])
% line([ScaleERlow ScaleERlow], [0 3])
% line([Scale Scale], [0 3])