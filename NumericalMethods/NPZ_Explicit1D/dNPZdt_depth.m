function [dNdt, dPdt, dZdt] = dNPZdt_depth(Nute, Phyt, Zoo, zvec, ...
    Vm, Ks, Kext, Rm, Lambda, gamma, m, g)
dPdt = nan*ones(length(zvec),1);
dZdt = dPdt; dNdt = dPdt;
for iz = length(zvec):-1:1
    %define depth level
    z = zvec(iz);
    %compute terms
    NuteUptake = (Vm*Nute(iz)*Phyt(iz)/(Ks+Nute(iz)))*exp(Kext.*z);
    Graze = Rm*Zoo(iz)*(1-exp(-Lambda*Phyt(iz)));
    ZooAssim = (1-gamma)*Graze;
    SloopyFeed = gamma*Graze;
    PhytMort = m*Phyt(iz);
    ZooMort = g*Zoo(iz);
    %compute derivative
    dPdt(iz) = NuteUptake-Graze-PhytMort;
    dZdt(iz) = ZooAssim-ZooMort;
    dNdt(iz) = -NuteUptake+SloopyFeed+PhytMort+ZooMort;
end
return