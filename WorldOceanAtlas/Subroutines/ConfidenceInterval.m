function CI = ConfidenceInterval(Nute, Rho)
%compute confidence intervals

Int = min(Rho):0.5:max(Rho);
for n = 1:(length(Int)-1)
    %break data up into 0.1 intervals in Rho
    bin = find(Rho >= Int(n) & Rho < Int(n+1));
    NuteBin = Nute(bin);
    
    %Compute mean and stdev in each bin
    nNuteBin = size(NuteBin,1);
    BinMean = nanmean(NuteBin);
    
    %Compute standard error of the mean at each value of Rho within interval
    BinSEM = nanstd(NuteBin)/sqrt(nNuteBin);
    
    %95% probability intervals of t-distribution
    CI95s = tinv([0.025 0.975], nNuteBin-1);
    
    %95% confidence intervals
    CI95 = bsxfun(@times,BinSEM, CI95s(:));
    
    CI.low(n) = BinMean + CI95(1);
    CI.hi(n) = BinMean + CI95(2);
    CI.rho(n) = nanmean(Rho(bin));
end






%multiply it by the 95% values of the t distribution