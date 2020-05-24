function [Nnew, Pnew, Znew, Dnew] = NPZD_Imp1D(...
    Nute, Phyt, Zoo, Detr, ...
    zvec, dt, ...
    Vm, Ks, Kext, Rm, Lambda, gamma, m, g, Md, RR, Exc)
% Use Implicit backward Euler in food chain order to compute 
% Nutrients, Phytoplankton, Zooplankton, and Detritus
% Inputs include...
% Nute = Nutrient; Phyt = Phytoplankton; Zoo = Zooplankton
% Detr = Detritus; Vm = max nutrient uptake rate;
% Ks = Michaelis-menton half saturation value;
% Kext = e-folding scale of PAR with depth;
% Rm = Max grazing rate; Lambda = level of saturated grazing;
% gamma = percent of sloppy grazing (1-Gamma) is assimialtion eff.;
% m = phytoplankton mortality; g = zooplankton mortality
% Md = Zooplankton death bits rate; RR = Detritus remin rate;
% Exc = zooplankton excretion rate

% Nutrient Uptake
C_up1 = Vm*dt;
C_up = Phyt*C_up1*exp(Kext*zvec(1))/(Ks+Nute);
% --> Implicit NPZD starts at base of food chain (nute uptake)
Nute = Nute/(1+C_up);
Phyt = Phyt+C_up*Nute;
% Grazing & phytoplankton mortality
C_Gr1 = Rm*dt;
C_Gr2 = m*dt;
C_Gr3 = Lambda*Lambda;
C_Gr = Zoo*Phyt*C_Gr1/(C_Gr3+Phyt*Phyt);
% --> Now with updated N and P, grazing is considered, 
%       and N, P, Z, and D are re-calculated
Phyt = Phyt/(1+C_Gr+C_Gr2);
Zoo = Zoo+Phyt*C_Gr*(1-gamma);
Detr = Detr+Phyt*(C_Gr2+C_Gr*(gamma-Exc));
Nute = Nute + Phyt*C_Gr*Exc;
% Zooplankton Excretion
C_Ex1 = 1/(1+(g+Md)*dt);
C_Ex2 = g*dt;
C_Ex3 = Md*dt;
% --> Next level of food chain, Z N & D updated with excretion
Zoo = Zoo*C_Ex1;
Nute = Nute + Zoo*C_Ex2;
Detr = Detr + Zoo*C_Ex3; % diverges here
% Detritus Remin
C_rr1 = RR*dt;
C_rr2 = 1/(1+C_rr1);
% --> Last level of food chain, detritus is remin to nutes
Detr = Detr*C_rr2;
Nute = Nute + Detr*C_rr1;

Nnew = Nute;
Pnew = Phyt;
Znew = Zoo;
Dnew = Detr;

return

