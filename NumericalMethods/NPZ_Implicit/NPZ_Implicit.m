function [Nnew, Pnew, Znew] = NPZ_Implicit(...
    Nute, Phyt, Zoo, ...
    zvec, dt,...
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
C_m = m*dt;
C_Gr = Zoo.*Phyt.*C_Gr1./((Lambda*Lambda)+(Phyt.*Phyt));

% --> Now with updated N and P, grazing is considered, 
%       and N, P, Z, and D are re-calculated
Phyt = Phyt./(1+C_Gr+C_m);
Zoo = Zoo+Phyt.*C_Gr.*(1-gamma);
Nute = Nute + Phyt.*C_Gr*gamma + Phyt.*C_m;

% Zooplankton mortality
C_Ex = g*dt; 

% --> Next level of food chain, Z N & D updated with excretion
Zoo = Zoo./(1+C_Ex);
Nute = Nute + Zoo.*C_Ex;
%keyboard

% define output parameters
Nnew = Nute;
Pnew = Phyt;
Znew = Zoo;
%Dnew = Detr;
return