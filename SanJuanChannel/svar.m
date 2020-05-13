function s_prime = svar(salprofile)
%compute salinity variance s^2 = (s - s_bar)^2

s_bar = nanmean(salprofile);
s_anom = salprofile - s_bar;

s_prime = s_anom.*s_anom;

return