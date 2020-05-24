% NPZ with 1D diffusion Euler Method
clear;

% set initial conditions
N_tot = 10;
Nute0 = 5;
Phyt0 = 2;
Zoo0 = N_tot - Nute0 - Phyt0;

% ***==================================================================***
%Set parameters
% time step
tau = 1;         %seconds
maxdays = 100;   %days
nz = 66;         %number of depth bins   
a1 =1; a2=2; a3=2; a4=1;    % Runge method
% ***==================================================================***


% Depth
z_bot = -65;
zvec = linspace(z_bot,0,nz); % index bottom to top!!

% time 
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
maxstep=maxtime_sec/tau;

% save interval
dtsave_days = 0.1;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = dtsave_sec/tau;
nsaves = round(maxstep/dtsave_step);
t_save = nan*ones(nz,nsaves);
N_save = t_save; P_save = t_save; Z_save = t_save;

%NPZ parameters
Vm = 2.0/Sec_day;      % max nutrient uptake rate (per sec)
Ks = 0.1;              % Michaelis-menton half saturation value
Kext = 0.06;           % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;      % Max grazing rate (per sec)
Lambda = 0.2;          % level of saturated grazing
gamma = 0.3;           % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;       % phytoplankton mortality (per sec)
g = 0.2/Sec_day;       % zooplankton mortality (per sec)
Kv = 1e-5;             % Diffusivity constant (per sec)

%Set and save IC for all depths
for iz = 1:nz
  Nute(iz,:)=Nute0;
  Phyt(iz,:)=Phyt0;
  Zoo(iz,:)=Zoo0;
  z = zvec(iz);
  N = Nute(iz);
  P = Phyt(iz);
  Z = Zoo(iz);
  t_save(iz,1) = 0;
  N_save(iz,1) = Nute(iz);
  P_save(iz,1) = Phyt(iz);
  Z_save(iz,1) = Zoo(iz);
end

%Time Stepping
for istep=1:maxstep
  time = istep*tau;
    [dNdt,dPdt,dZdt] = dNPZdt_diffusion(Nute, Phyt, Zoo, zvec, ...
                              Vm, Ks, Kext,...
                              Rm, Lambda, gamma, m, g, Kv);
    Nute = Nute+dNdt*tau;
    Phyt = Phyt+dPdt*tau;
    Zoo = Zoo+dZdt*tau;

    if mod(istep,dtsave_step) ==0 
      isave=time/dtsave_sec+1;  
      t_save(:,isave) = time;
      N_save(:,isave) = Nute;
      P_save(:,isave) = Phyt;
      Z_save(:,isave) = Zoo;
    end
end

%Plotting
iz=2;
figure(iz)
plot(t_save(iz,:),N_save(iz,:),'k')
hold on
plot(t_save,P_save(iz,:),'g')
plot(t_save,Z_save(iz,:),'r')