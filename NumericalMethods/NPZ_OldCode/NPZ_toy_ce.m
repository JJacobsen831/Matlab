% NPZ model coupled to physical model with diffustion
% based on Edwards et al., 2000
clear; 

ifig1=10;

% Variables
%*Set IC (could do prompt as in text)
N_tot = 10;
%Nute = .57;    % Nutrient concentration
%Phyt = 0.042;    % Phytoplankton concentration
%Zoo = .39;     % Zooplankton concentration
Nute = 5;    % Nutrient concentration
Phyt = 3;    % Phytoplankton concentration
Zoo = N_tot-Nute-Phyt;     % Zooplankton concentration
tau = 0.01;     % Time-step

secperday=86400;
maxtime_days = 5;   % days
maxtime_sec = maxtime_days*secperday;   % seconds
maxstep = maxtime_sec/tau;

dtsave_days=0.01; % days
dtsave_sec=dtsave_days*secperday;
dtsave_step=dtsave_sec/tau;
nsaves=round(maxstep/dtsave_step);

%dz = 1;      % meters
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

% find stable points
%P_star = -1*log(1-(g/((1-gamma)*Rm)))/Lambda;
%Z_star = P_star*((Vm

z_bot = -65;  % meters
zvec=linspace(0,z_bot,5);
%zvec=0;
nzvec=length(zvec);
%**start loop
%  Without diffusion


xplot = nan*ones(nzvec,nsaves);
yplot_N = xplot;
yplot_P = xplot;
yplot_Z = xplot;
dNdt = xplot; Phyt_new = xplot; dZdt = xplot;
isave=1;
for istep=1:maxstep
    time=istep*tau;
    for iz=1:nzvec
        if mod(istep,dtsave_step)==0
          isave=isave+1;
          t_save(isave)=time;
          N_save(iz,isave)=Nute;
          P_save(iz,isave)=Phyt;
          Z_save(iz,isave)=Zoo;
          dNdt_save(iz,isave)=dNdt;
          dPdt_save(iz,isave)=dPdt;
          dZdt_save(iz,isave)=dZdt;
        end
        z=zvec(iz);
        %*record conditions for plotting
        %xplot(iz,istep) = istep; %independent axis is time step
        %yplot_N(iz,istep) = Nute;
        %yplot_P(iz,istep) = Phyt;
        %yplot_Z(iz,istep) = Zoo;
        % Set Current time
        %t = (istep-1)*tau; 
        %*Calculate each term for the 3 equations
        NuteUptake = ((Vm*Nute*Phyt)/(Ks + Nute))*exp(Kext*z);
        SloppyFeed = gamma*Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        PhytMort = m*Phyt;
        ZooMort = g*Zoo;
        GrazeRate = Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        ZooUptake = (1-gamma)*Rm*Zoo*(1-exp(-1*Lambda*Phyt));
        %*Calculate the new set of conditions
        %   Assemble terms for each equation
        dNdt = -1*NuteUptake+SloppyFeed+PhytMort+ZooMort;
        dPdt = NuteUptake-GrazeRate-PhytMort;
        dZdt = ZooUptake - ZooMort;
        %   Euler Step
        %   Multiply above "assembly" by tau & add previous condition
        Nute = Nute+dNdt*tau;
        Phyt = Phyt+dPdt*tau;
        Zoo = Zoo+dZdt*tau;
    end
end

figure(ifig1); clf
for k=1:nzvec
  subplot(nzvec,1,k)
  plot(t_save/secperday, N_save(k,:), 'k','linewidth',2)
  hold on;
  plot(t_save/secperday, P_save(k,:), '-g','linewidth',2)
  hold on;
  plot(t_save/secperday, Z_save(k,:), '-.r','linewidth',2)
  title(sprintf('N(k), P(g), Z(r): depth = %0.02f m',zvec(k)))
  ylabel('N,P,Z');
  xlabel('time (days)');
  grid on
end
return

figure(ifig1+1); clf
for k=1:nzvec
  subplot(nzvec,1,k)
  plot(1:maxstep, dNdt(k,:), 'k','linewidth',2)
  hold on;
  plot(1:maxstep, dPdt(k,:), '-g','linewidth',2)
  hold on;
  plot(1:maxstep, dZdt(k,:), '-.r','linewidth',2)
  title(sprintf('d/dt terms: depth = %0.02f m',zvec(k)))
  grid on
end

