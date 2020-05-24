%NPZ model
%Fourth Order Runga Kutta with Runge method
clear; 

%set Initial Conditions
N_tot = 10;
Nute0 = 3;
Phyt0 = 4;
Zoo0 = N_tot-Nute0-Phyt0;

% ***==================================================================***
%Set parameters
% time step
tau = 1;         %seconds
maxdays = 100;   %days
nz = 66;         %number of depth bins   
a1 =1; a2=2; a3=2; a4=1;    % Runge method
% ***==================================================================***

% Coef for RK method
atot = sum([a1 a2 a3 a4]);

%Depth
z_bot=-65;           
zvec = linspace(z_bot,0,nz);

%Time & save interval
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
n_step=maxtime_sec/tau;
time = 0; %initiate time

% save interval
dtsave_days = 0.01;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = dtsave_sec/tau;
nsaves = round(n_step/dtsave_step);
t_save = nan*ones(nz,nsaves);

% pre-allocation
N_save = t_save;
P_save = t_save; Z_save = t_save;
Nute = nan*ones(nz,1);
Phyt = Nute; Zoo = Nute;

% NPZ parameters
Vm = 2.0/Sec_day;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;   % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;       % phytoplankton mortality
g = 0.2/Sec_day;       % zooplankton mortality
Kv = 1e-5;     % Diffusivity coef

% set initial conditions and save
for iz=1:nz
    Nute(iz) = Nute0;
    Phyt(iz) = Phyt0;
    Zoo(iz) = Zoo0;
    t_save(iz,1)=0;
    N_save(iz,1) = Nute(iz);
    P_save(iz,1) = Phyt(iz);
    Z_save(iz,1) = Zoo(iz);
end

% begin time stepping
for istep =1:n_step
    time = time+tau;
     if mod(istep,Sec_day)==0
        fprintf('time=%0.2f days\n',time/Sec_day);
     end
    % Compute d/dt's at i and i+tau
    [k1_dN, k1_dP, k1_dZ] = dNPZdt_diffusion(Nute, Phyt, Zoo, ...
                            zvec,Vm, Ks, Kext,Rm, ...
                            Lambda, gamma, m, g, Kv);
    [k2_dN, k2_dP, k2_dZ] = dNPZdt_diffusion(Nute+0.5*k1_dN*tau, ...
                            Phyt+0.5*k1_dP*tau, ...
                            Zoo+0.5*k1_dZ*tau, zvec, ...
                            Vm, Ks, Kext,Rm,Lambda, gamma, m, g, Kv);
    [k3_dN, k3_dP, k3_dZ] = dNPZdt_diffusion(Nute+0.5*k2_dN*tau, ...
                            Phyt+0.5*k2_dP*tau, ...
                            Zoo+0.5*k2_dZ*tau, zvec, ...
                            Vm, Ks, Kext,Rm,Lambda, gamma, m, g, Kv);
    [k4_dN, k4_dP, k4_dZ] = dNPZdt_diffusion(Nute+k3_dN*tau, ...
                            Phyt+k3_dP*tau, ...
                            Zoo+k3_dZ*tau, zvec, ...
                            Vm, Ks, Kext,Rm,Lambda, gamma, m, g, Kv);
    
    % Plug in d/dt's to find next i+1
    Nute = Nute+1/atot*(a1*k1_dN+a2*k2_dN+a3*k3_dN+a4*k4_dN)*tau;
    Phyt = Phyt+1/atot*(a1*k1_dP+a2*k2_dP+a3*k3_dP+a4*k4_dN)*tau;
    Zoo  = Zoo+1/atot*(a1*k1_dZ+a2*k2_dZ+a3*k3_dZ+a4*k4_dZ)*tau;
    if mod(istep,dtsave_step) == 0
       isave = istep/dtsave_step+1;
       t_save(:,isave) = time;
       N_save(:,isave) = Nute;
       P_save(:,isave) = Phyt;
       Z_save(:,isave) = Zoo;
    end
end

%Plotting
d = 38;
figure(d+1); clf
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
txt=sprintf('N(k), P(g), Z(r) at zlevel=%0.2f m',zvec(d));
txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
      Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
    gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt,txt2,txt3));
grid on