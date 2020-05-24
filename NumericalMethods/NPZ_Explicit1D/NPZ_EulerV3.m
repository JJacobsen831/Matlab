% NPZ Model using Euler Method with multiple independent depths
clear;

%Set initial conditions
N_tot = 10;
Nute0 = 5;
Phyt0 = 2;
Zoo0 = N_tot - Nute0 - Phyt0;

%Depth
nz = 5;
z_bot = -65;
zvec = linspace(z_bot,0,nz);

% Time step parameters
tau=86400/10;
maxdays = 200;
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
maxstep= maxtime_sec/tau;

% save interval
dtsave_days = 0.1;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = max([round(dtsave_sec/tau) 1]);
nsaves = round(maxstep/dtsave_step);
t_save = nan*ones(nz,nsaves);
N_save = t_save; P_save = t_save; Z_save = t_save;

% model parameters
Vm = 2.0/Sec_day;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;    % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;       % phytoplankton mortality
g = 0.2/Sec_day;       % zooplankton mortality

% generate and save initial conditions 
isave=1;
for iz = 1:nz
  Nute(iz,:)=Nute0;
  Phyt(iz,:)=Phyt0;
  Zoo(iz,:)=Zoo0;

%   z = zvec(iz);
%   N = Nute(iz);
%   P = Phyt(iz);
%   Z = Zoo(iz);
  t_save(iz,1) = 0;
  N_save(iz,1) = Nute(iz);
  P_save(iz,1) = Phyt(iz);
  Z_save(iz,1) = Zoo(iz);
%   [dNdt,dPdt,dZdt] = dNPZdt(N, P, Z, z,Vm, Ks, Kext,...
%                              Rm, Lambda, gamma, m, g);
%   dPdt_save(iz,1) = dNdt;
%   dZdt_save(iz,1) = dPdt;
%   dNdt_save(iz,1) = dZdt;
end

% Time stepping
for istep=1:maxstep
  time = istep*tau;

    [dNdt,dPdt,dZdt] = dNPZdt_ExplicitMM(Nute, Phyt, Zoo, ...
                              zvec, ...
                              Vm, Ks, Kext,...
                              Rm, Lambda, gamma, m, g);
    Nute = Nute+dNdt*tau;
    Phyt = Phyt+dPdt*tau;
    Zoo = Zoo+dZdt*tau;

    if mod(istep,dtsave_step) ==0 
      isave=floor(time/dtsave_sec+1);  
      t_save(:,isave) = time;
      N_save(:,isave) = Nute;
      P_save(:,isave) = Phyt;
      Z_save(:,isave) = Zoo;
%       dPdt_save(iz,isave) = dPdt;
%       dZdt_save(iz,isave) = dZdt;
%       dNdt_save(iz,isave) = dNdt;
    end
end

% Plotting
figure(1)
iz=1;
plot(t_save(iz,:)/Sec_day,N_save(iz,:),'k')
hold on
plot(t_save(iz,:)/Sec_day,P_save(iz,:),'g')
plot(t_save(iz,:)/Sec_day,Z_save(iz,:),'r')
