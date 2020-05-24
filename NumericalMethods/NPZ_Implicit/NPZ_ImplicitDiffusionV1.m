function [Nnew, Pnew, Znew] = NPZ_ImplicitDiffusionV1(...
    Nute, Phyt, Zoo, ...
    zvec, dt, Kv,...
    Vm, Ks, Kext, Rm, Lambda, gamma, m, g)
% Input vectors of Nute, Phyt, Zoo, and other param.
% Compute diffustion, then Implicit Euler, (then sinking)


% Implicit backward Euler NPZD (Update Ecosystem)
% Nutrient Uptake
C_up1 = Vm*dt;
C_up = Phyt.*C_up1.*exp(Kext.*zvec)./(Ks+Nute);
% --> Implicit NPZD starts at base of food chain (nute uptake)
Nute = Nute./(1+C_up);
Phyt = Phyt+C_up.*Nute;
% Grazing & phytoplankton mortality
C_Gr1 = Rm*dt;
C_Gr2 = m*dt;
C_Gr3 = Lambda*Lambda;
C_Gr = Zoo.*Phyt.*C_Gr1./(C_Gr3+Phyt.*Phyt);
% --> Now with updated N and P, grazing is considered, 
%       and N, P, Z, and D are re-calculated
Phyt = Phyt./(1+C_Gr+C_Gr2);
Zoo = Zoo+Phyt.*C_Gr.*(1-gamma);
% Detr = Detr+Phyt.*(C_Gr2+C_Gr.*(gamma-Exc));
Nute = Nute + Phyt.*C_Gr; %.*Exc;
% Zooplankton Excretion and mortality
C_Ex1 = 1/(1+(g+Md)*dt); %repaced g+Md with g
%C_Ex2 = g*dt;
% C_Ex3 = Md*dt;
% --> Next level of food chain, Z N & D updated with excretion
Zoo = Zoo*C_Ex1;
% Nute = Nute + Zoo*C_Ex2;
% Detr = Detr + Zoo*C_Ex3; 
% Detritus Remin
% C_rr1 = RR*dt;
% C_rr2 = 1/(1+C_rr1);
% --> Last level of food chain, detritus is remin to nutes
% Detr = Detr*C_rr2;
% Nute = Nute + Detr*C_rr1;
%
% Diffusion
%
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
FluxN = NaN((nz_w-1),1);
FluxP = FluxN; FluxZ=FluxN;
for n = 1:nz_w-1
    FluxN(n) = (dNdz_pad(n+1)-dNdz_pad(n))/(z_w(n+1)-z_w(n));
    FluxP(n) = (dPdz_pad(n+1)-dPdz_pad(n))/(z_w(n+1)-z_w(n));
    FluxZ(n) = (dZdz_pad(n+1)-dZdz_pad(n))/(z_w(n+1)-z_w(n));
end
% Update NPZ with diffusive flux
Nute = Nute + FluxN;
Phyt = Phyt + FluxP;
Zoo = Zoo + FluxZ;


% define output parameters
Nnew = Nute;
Pnew = Phyt;
Znew = Zoo;
%Dnew = Detr;
return