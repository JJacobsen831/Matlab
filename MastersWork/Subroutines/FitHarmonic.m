function [Harmonic, Coefs] = FitHarmonic(x, y)
%fit least squares harmonic of form [b1]*sin(2pi*x/[b2]+2pi/[b3]) + [b4]

%limits of dependent variable to be fit
y_mx = max(y);
y_mn = min(y);

%range of dependent
y_rng = (y_mx - y_mn);

%center at half amplitude
y_cent = y - y_mx + (y_rng/2);

%estimate period and offset
%find zero crossing
% zero_crs = x(y_cent.*circshift(y_cent, [0 1]) <= 0);
zero_crs = [1 x(y == y_mn)];
EstPer = 2*mean(diff(zero_crs));
EstOff = mean(y);

%form of harmonic
fit = @(b,x) b(1).*(cos(2*pi*x./b(2) + b(3))) + b(4);

% find coefs by minimize least squares
lst_sqr = @(b) sum((fit(b,x) - y).^2);

Coefs = fminsearch(lst_sqr, [y_rng; EstPer; -1; EstOff]);

%evaluate harmonic
Harmonic = fit(Coefs,x);

return

