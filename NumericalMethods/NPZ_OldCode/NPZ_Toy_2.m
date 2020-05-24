clear;
Vm = 2.0;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;    % e-folding scale of PAR with depth
Rm = 0.5;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1;       % phytoplankton mortality
g = 0.2;       % zooplankton mortality

% set depth level
 z = -45;
% set timestep
 tau = 0.1; maxstep = 5000;
 %begin loop here
 Nute = 0.0321;
 Phyt = 4.2365;
 Zoo = 5.7314;
 for istep=1:maxstep
     %* record conditions for plotting
     yplot_N(istep) = Nute;
     yplot_P(istep) = Phyt;
     yplot_Z(istep) = Zoo;
     %* Compute terms
     NuteUptake = (Vm*Nute*Phyt/(Ks+Nute))*exp(Kext*z);
     Graze = Rm*Zoo*(1-exp(-Lambda*Phyt));
     PhytMort = m*Phyt;
     
     ZooAssim = (1-gamma)*Rm*Zoo*(1-exp(-Lambda*Phyt));
     ZooMort = g*Zoo;
     
     SloppyFeed = gamma*Rm*Zoo*(1-exp(-Lambda*Phyt));
     %* Assemble equations
     Phyt_new = NuteUptake - Graze - PhytMort;
     Zoo_new = ZooAssim - ZooMort;
     Nute_new = -NuteUptake + SloppyFeed + PhytMort + ZooMort;
     %* Euler Step
     Phyt = Phyt + Phyt_new*tau;
     Zoo = Zoo + Zoo_new*tau;
     Nute = Nute + Nute_new*tau;
 end
 
 
 plot(1:maxstep, yplot_N, 'k')
hold on;
plot(1:maxstep, yplot_P, '-g')
hold on;
plot(1:maxstep, yplot_Z, '-.r')
title('a) depth = 35 m')
