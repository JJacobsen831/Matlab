function [dNdt, dPdt, dZdt] = dNPZdt_ExplicitMM(Nute, Phyt, Zoo, zvec, ...
    Vm, Ks, Kext, Rm, Lambda, gamma, m, g)
dPdt = NaN(length(zvec),1); dZdt = dPdt; dNdt = dPdt;
for iz = length(zvec):-1:1
    
    %define depth level
    z = zvec(iz);
    
    %compute terms
    NuteUptake = (Vm*Nute(iz)*Phyt(iz)/(Ks+Nute(iz)))*exp(Kext*z);
    Graze = -Rm*Zoo(iz)*(Phyt(iz)*Phyt(iz))/((Lambda*Lambda)+(Phyt(iz)*Phyt(iz)));
    ZooAssim = (1-gamma)*Graze;
    SloppyFeed = gamma*Graze;
    PhytMort = m*Phyt(iz);
    ZooMort = g*Zoo(iz);
    
    %compute derivatives
    dPdt(iz) = NuteUptake-Graze-PhytMort;
    dZdt(iz) = ZooAssim-ZooMort;
    dNdt(iz) = -NuteUptake+SloppyFeed+PhytMort+ZooMort;
end
return