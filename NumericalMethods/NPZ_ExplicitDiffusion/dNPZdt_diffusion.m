function [dNdt, dPdt, dZdt] = dNPZdt_diffusion(Nute, Phyt, Zoo, zvec, ...
    Vm, Ks, Kext, Rm, Lambda, gamma, m, g, Kv)
nz = length(zvec);
%generate staggared line
zw = NaN(1,nz-1);
dz = abs(zvec(1)-zvec(2));
for n = 1:(nz-1)
   zw(n) = (zvec(n)+zvec(n+1))/2; % w points
end
nzw = length(zw);
z_w = [zw(1)-dz zw zw(nzw)+dz]; % extend w points 1 step at each end
nz_w = length(z_w);
%vertical derivatives
dNdz = NaN(1,nz-1);
dPdz = dNdz; dZdz = dNdz;
for n = 1:(nz-1)
    dNdz(n) = Kv*((Nute(n+1)-Nute(n))/(zvec(n+1)-zvec(n)));
    dPdz(n) = Kv*((Phyt(n+1)-Phyt(n))/(zvec(n+1)-zvec(n)));
    dZdz(n) = Kv*((Zoo(n+1)-Zoo(n))/(zvec(n+1)-zvec(n)));
end
% zero flux at ends 
dNdz_pad = [0 dNdz 0]; 
dPdz_pad = [0 dPdz 0];
dZdz_pad = [0 dZdz 0];
%compute diffusion flux
FluxN = NaN(1,(nz_w-1));
FluxP = FluxN; FluxZ=FluxN;
for n = 1:nz_w-1
    FluxN(n) = (dNdz_pad(n+1)-dNdz_pad(n))/(z_w(n+1)-z_w(n));
    FluxP(n) = (dPdz_pad(n+1)-dPdz_pad(n))/(z_w(n+1)-z_w(n));
    FluxZ(n) = (dZdz_pad(n+1)-dZdz_pad(n))/(z_w(n+1)-z_w(n));
end

dPdt = nan*ones(length(zvec),1);
dZdt = dPdt; dNdt = dPdt;
for iz = 1:nz
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
    dPdt(iz) = NuteUptake-Graze-PhytMort+FluxP(iz);
    dZdt(iz) = ZooAssim-ZooMort+FluxZ(iz);
    dNdt(iz) = -NuteUptake+SloopyFeed+PhytMort+ZooMort+FluxN(iz);
end
return