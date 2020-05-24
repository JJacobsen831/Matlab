% NPZ model coupled to physical model with diffustion
% based on Edwards et al., 2000
clear; 

% Variables
%*Set IC (could do prompt as in text)
Nute = .57;    % Nutrient concentration
Phyt = 0.042;    % Phytoplankton concentration
Zoo = .39;     % Zooplankton concentration
tau = 0.0001;     % Time-step
maxstep = 20000;

dz = 1;      % meters
%z = 1:dz:z_tot;       % depth 
% Make z a range 
% Loop through time and at each timestep
% loop through vertical dimension
% All parameters set to macro-zooplankton from Edwards et al 2000
Vm = 2.0;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;    % e-folding scale of PAR with depth
Rm = 0.5;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1;       % phytoplankton mortality
g = 0.2;       % zooplankton mortality
N_tot = 10;

% find stable points
%P_star = -1*log(1-(g/((1-gamma)*Rm)))/Lambda;
%Z_star = P_star*((Vm

z_tot = 65;  % meters
%**start loop
%  Without diffusion


xplot = nan*ones(length(1:z_tot),length(1:maxstep));
yplot_N = xplot;
yplot_P = xplot;
yplot_Z = xplot;
Nute_new = xplot; Phyt_new = xplot; Zoo_new = xplot;
for istep=1:maxstep
    for z=1:dz:z_tot
        %*record conditions for plotting
        xplot(z,istep) = istep; %independent axis is time step
        yplot_N(z,istep) = Nute;
        yplot_P(z,istep) = Phyt;
        yplot_Z(z,istep) = Zoo;
        % Set Current time
        t = (istep-1)*tau; 
        %*Calculate each term for the 3 equations
        NuteUptake = ((Vm*Nute*Phyt)/(Ks + Nute))*exp(Kext*z);
        SloppyFeed = gamma*Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        PhytMort = m*Phyt;
        ZooMort = g*Zoo;
        GrazeRate = Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        ZooUptake = (1-gamma)*Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        %*Calculate the new set of conditions
        %   Assemble terms for each equation
        Nute_new(z,istep) = -1*NuteUptake+SloppyFeed+PhytMort+ZooMort;
        Phyt_new(z,istep) = NuteUptake-GrazeRate-PhytMort;
        Zoo_new(z,istep) = ZooUptake - ZooMort;
        %   Euler Step
        %   Multiply above "assembly" by tau & add previous condition
        Nute = Nute+Nute_new(z,istep)*tau;
        Phyt = Phyt+Phyt_new(z,istep)*tau;
        Zoo = Zoo+Zoo_new(z,istep)*tau;
    end
end

subplot(5,1,1)
plot(1:maxstep, yplot_N(5,:), 'k')
hold on;
plot(1:maxstep, yplot_P(5,:), '-g')
hold on;
plot(1:maxstep, yplot_Z(5,:), '-.r')
title('a) depth = 5 m')

subplot(5,1,2)
plot(1:maxstep, yplot_N(25,:), 'k')
hold on;
plot(1:maxstep, yplot_P(25,:), '-g')
hold on;
plot(1:maxstep, yplot_Z(25,:), '-.r')
title('a) depth = 25 m')

subplot(5,1,3)
plot(1:maxstep, yplot_N(35,:), 'k')
hold on;
plot(1:maxstep, yplot_P(35,:), '-g')
hold on;
plot(1:maxstep, yplot_Z(35,:), '-.r')
title('a) depth = 35 m')

subplot(5,1,4)
plot(1:maxstep, yplot_N(45,:), 'k')
hold on;
plot(1:maxstep, yplot_P(45,:), '-g')
hold on;
plot(1:maxstep, yplot_Z(45,:), '-.r')
title('a) depth = 45 m')

subplot(5,1,5)
plot(1:maxstep, yplot_N(55,:), 'k')
hold on;
plot(1:maxstep, yplot_P(55,:), '-g')
hold on;
plot(1:maxstep, yplot_Z(55,:), '-.r')
title('a) depth = 55 m')

figure(2)
subplot(5,1,1)
plot(1:maxstep, Nute_new(5,:), 'k')
hold on;
plot(1:maxstep, Phyt_new(5,:), '-g')
hold on;
plot(1:maxstep, Zoo_new(5,:), '-.r')
title('a) depth = 5 m')

subplot(5,1,2)
plot(1:maxstep, Nute_new(25,:), 'k')
hold on;
plot(1:maxstep, Phyt_new(25,:), '-g')
hold on;
plot(1:maxstep, Zoo_new(25,:), '-.r')
title('a) depth = 25 m')

subplot(5,1,3)
plot(1:maxstep, Nute_new(35,:), 'k')
hold on;
plot(1:maxstep, Phyt_new(35,:), '-g')
hold on;
plot(1:maxstep, Zoo_new(35,:), '-.r')
title('a) depth = 35 m')

subplot(5,1,4)
plot(1:maxstep, Nute_new(45,:), 'k')
hold on;
plot(1:maxstep, Phyt_new(45,:), '-g')
hold on;
plot(1:maxstep, Zoo_new(45,:), '-.r')
title('a) depth = 45 m')

subplot(5,1,5)
plot(1:maxstep, Nute_new(55,:), 'k')
hold on;
plot(1:maxstep, Phyt_new(55,:), '-g')
hold on;
plot(1:maxstep, Zoo_new(55,:), '-.r')
title('a) depth = 55 m')