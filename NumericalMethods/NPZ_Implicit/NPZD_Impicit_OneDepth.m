%Implicit NPZD without diffusion
clear;
Sec_day = 86400;
dt = 1; %second
dtday = dt/Sec_day; %days
z = -5; % depth
%IC 
N_tot= 10;
Nute = 4;
Phyt = 3;
Detr = 1;
Zoo = N_tot-Nute-Phyt-Detr;
% Parameters
Vm = 2.0/Sec_day;       % max nutrient uptake rate
Ks = 0.1;               % Michaelis-menton half saturation value
Kext = 0.06;            % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;       % Max grazing rate
Lambda = 0.2;           % level of saturated grazing
gamma = 0.3;            % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;        % phytoplankton mortality
g = 0.2/Sec_day;        % zooplankton mortality
Md = 0.05/Sec_day;      % Zooplankton death bits rate
RR = 0.1/Sec_day;       % Detritus remin rate
Exc = 0.15/Sec_day;     % zooplankton excretion rate


% Nutrient Uptake
C_up1 = Vm*dt;
C_up = Phyt*C_up1*exp(Kext*z)/(Ks+Nute);
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

N_Tot_Check = Nute + Phyt + Zoo + Detr