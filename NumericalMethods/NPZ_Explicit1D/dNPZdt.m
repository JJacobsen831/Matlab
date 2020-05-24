function [dNdt, dPdt, dZdt] = dNPZdt(Nute, Phyt, Zoo, z, Vm, Ks, Kext,...
    Rm, Lambda, gamma, m, g)
NuteUptake = (Vm*Nute*Phyt/(Ks+Nute))*exp(Kext*z);
Graze = Rm*Zoo*(1-exp(-Lambda*Phyt));
ZooAssim = (1-gamma)*Graze;
SloopyFeed = gamma*Graze;
PhytMort = m*Phyt;
ZooMort = g*Zoo;
dPdt = NuteUptake-Graze-PhytMort;
dZdt = ZooAssim-ZooMort;
dNdt = -NuteUptake+SloopyFeed+PhytMort+ZooMort;
return