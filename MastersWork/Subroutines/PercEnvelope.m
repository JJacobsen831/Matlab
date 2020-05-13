function Env = PercEnvelope(CTI, JDtime)
%compute percentiles

Int = min(JDtime):1:max(JDtime);
P5 = NaN([size(Int)-1, 1]); P25 = P5; P75 = P5; 
P95 = P5; Med = P5; 
for n = 1:(length(Int)-1)
    %break data up into daily intervals
    VarBin = CTI(JDtime >= Int(n) & JDtime < Int(n+1),:);
    
    %Compute 5%
    P5(n) = prctile(VarBin,5);
    P25(n) = prctile(VarBin,25);
    P75(n) = prctile(VarBin,75);
    P95(n) = prctile(VarBin,95);
    
    %compute median
    Med(n) = nanmedian(VarBin);
    
end

Env.P5 = P5;
Env.P25 = P25;
Env.P75 = P75;
Env.P95 = P95;
Env.Med = Med;


return