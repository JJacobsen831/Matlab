function [dNdt, dPdt, dZdt] = NPZterms(Nute,Phyt,Zoo,z) %,zvec)
%parameters
Vm = 2.0;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;    % e-folding scale of PAR with depth
Rm = 0.5;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1;       % phytoplankton mortality
g = 0.2;       % zooplankton mortality
%depth
%zvec=linspace(0,z_bot,5);

%nzvec=length(zvec);
% for iz = 1:nzvec
    %z=0; %zvec(iz);

%* Compute terms
     NuteUptake = (Vm*Nute*Phyt/(Ks+Nute))*exp(Kext*z);
     Graze = Rm*Zoo*(1-exp(-Lambda*Phyt));
     ZooAssim = (1-gamma)*Graze;
     SloppyFeed = gamma*Graze;
     PhytMort = m*Phyt;   
     ZooMort = g*Zoo;    
     %* Assemble equations
     dPdt = NuteUptake - Graze - PhytMort;
     dZdt = ZooAssim - ZooMort;
     dNdt = -NuteUptake + SloppyFeed + PhytMort + ZooMort;
%end