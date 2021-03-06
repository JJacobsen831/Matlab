%NPZ model
%Second Order Runga Kutta with Heun's method
clear; clf;
%set Initial Conditions
N_tot = 10;
Nute0 = 5;
Phyt0 = 2;
Zoo0 = N_tot-Nute0-Phyt0;
%Set parameters
% ***==================================================================***
% number of depth levels
nz = 5;
% time step
tau = 86400/5;        %seconds
maxdays = 200;    %days
a2 = 1;         % Heun's method a2 = 1/2; Mid Pt a2 = 1; Ralston a2=2/3;
% ***==================================================================***

%Runge-Kutta Parameters
a1 = 1-a2;
p1 = 1/(2*a2);
q11 = 1/(2*a2);

%Time & save interval
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
n_step=maxtime_sec/tau;
time = 0; 

% NPZ parameters
Vm = 2.0/Sec_day;      % max nutrient uptake rate
Ks = 0.1;      % Michaelis-menton half saturation value
Kext = 0.06;   % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;       % phytoplankton mortality
g = 0.2/Sec_day;       % zooplankton mortality

%Depth
z_bot=-65;          
zvec = linspace(z_bot,0,nz);



% save interval
dtsave_days = 0.1;
dtsave_sec = max([dtsave_days*Sec_day 1]);
dtsave_step = round(dtsave_sec/tau);
nsaves = round(n_step/dtsave_step);
t_save = nan*ones(nz,nsaves);

% pre-allocation
N_save = t_save;
P_save = t_save; Z_save = t_save;
Nute = nan*ones(nz,1);
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
        % Compute d/dt's at i and i+tau
        [k1_dN, k1_dP, k1_dZ] = dNPZdt_ExplicitMM(Nute, Phyt, Zoo, ...
                            zvec,Vm, Ks, Kext,Rm, Lambda, gamma, m, g);
        [k2_dN, k2_dP, k2_dZ] = dNPZdt_ExplicitMM(Nute+k1_dN*tau, ...
                            Phyt+k1_dP*tau, ...
                            Zoo+k1_dZ*tau, zvec, ...
                            Vm, Ks, Kext,Rm,Lambda, gamma, m, g);
        
                        % Plug in d/dt's to find next i+1
        Nute = Nute+(a1*k1_dN+a2*k2_dN)*tau;
        Phyt = Phyt+(a1*k1_dP+a2*k2_dP)*tau;
        Zoo = Zoo+(a1*k1_dZ+a2*k2_dZ)*tau;
        if mod(istep,dtsave_step) == 0
            isave = floor(istep/dtsave_step+1);
            t_save(:,isave) = time;
            N_save(:,isave) = Nute;
            P_save(:,isave) = Phyt;
            Z_save(:,isave) = Zoo;
        end
end

d = 1;
plot(t_save(d,:), N_save(d,:), 'k');
hold on
plot(t_save(d,:), P_save(d,:), 'g');
plot(t_save(d,:), Z_save(d,:), 'r');