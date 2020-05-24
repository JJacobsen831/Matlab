%NPZ model
%Second Order Runga Kutta with Heun's method
clear;
%set Initial Conditions
N_tot = 10;
Nute0 = 3;
Phyt0 = 5;
Zoo0 = N_tot-Nute0-Phyt0;
%Set parameters
% ***==================================================================***
% time step
tau = 0.1;        %seconds
maxdays = 1;    %days
a2 = 1;         % Heun's method a2 = 1/2; Mid Pt a2 = 1; Ralston a2=2/3;
% ***==================================================================***
a1 = 1-a2;
p1 = 1/(2*a2);
q11 = 1/(2*a2);
% NPZ parameters
Vm = 2.0;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;   % e-folding scale of PAR with depth
Rm = 0.5;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1;       % phytoplankton mortality
g = 0.2;       % zooplankton mortality
%Depth
z_bot=-65;           % depth
zvec = linspace(0,z_bot,5);
nz = length(zvec);
%Time & save interval
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
maxstep=maxtime_sec/tau;
time = 0; %initiate time
% save interval
dtsave_days = 0.01;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = dtsave_sec/tau;
nsaves = round(maxstep/dtsave_step);
t_save = nan*ones(nz,nsaves);
% pre-allocation
N_save = t_save;
P_save = t_save; Z_save = t_save;
Nute = nan*ones(1,nz);
Phyt = Nute; Zoo = Nute;
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

for istep =1:n_step
    time = p1*tau*istep;
    for iz=1:nz
        % Compute d/dt's at i and i+tau
        [k1_dN, k1_dP, k1_dZ] = dNPZdt(Nute(iz), Phyt(iz), Zoo(iz), ...
                            zvec(iz),Vm, Ks, Kext,Rm, Lambda, gamma, m, g);
        [k2_dN, k2_dP, k2_dZ] = dNPZdt(Nute(iz)+k1_dN*tau, ...
                            Phyt(iz)+k1_dP*tau, ...
                            Zoo(iz)+k1_dZ*tau, zvec(iz), ...
                            Vm, Ks, Kext,Rm,Lambda, gamma, m, g);
        % Plug in d/dt's to find next i+1
        Nute(iz) = Nute(iz)+(a1*k1_dN+a2*k2_dN)*tau;
        Phyt(iz) = Phyt(iz)+(a1*k1_dP+a2*k2_dP)*tau;
        Zoo(iz) = Zoo(iz)+(a1*k1_dZ+a2*k2_dZ)*tau;
    
    t_save(istep) = time;
    N_save(istep) = Nute;
    P_save(istep) = Phyt;
    Z_save(istep) = Zoo;
    
    %advance time
    
end
plot(t_save, N_save, 'k');
hold on
plot(t_save, P_save, 'g');
plot(t_save, Z_save, 'r');