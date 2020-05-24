% NPZ Model Implicit no diffusion
clear;

% Set Initial Conditions
N_tot= 10;
Nute0 = 5;
Phyt0 = 2;
Zoo0 = N_tot-Nute0-Phyt0;

% ***=====================================================================
% Set parameters
dt = 1; 
maxdays = 100;
% ***=====================================================================

%Depth
nz = 5; % number of depth bins
z_bot = -65;
zvec = linspace(z_bot,0,nz)';

%Time 
Sec_day = 86400;
maxtime_sec = maxdays*Sec_day;
maxstep=maxtime_sec/dt;
dtday = dt/Sec_day; %days

% save interval
dtsave_days = 0.1;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = max([round(dtsave_sec/dt) 1]);
nsaves = round(maxstep/dtsave_step);
t_save = nan*ones(nz,nsaves);
N_save = t_save; P_save = t_save; Z_save = t_save; 

% NPZ Parameters
Vm = 2.0/Sec_day;       % max nutrient uptake rate
Ks = 0.1;               % Michaelis-menton half saturation value
Kext = 0.06;            % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;       % Max grazing rate
Lambda = 0.2;           % level of saturated grazing
gamma = 0.3;            % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;        % phytoplankton mortality
g = 0.2/Sec_day;        % zooplankton mortality

% set and save Initial Conditions 
Nute = NaN(nz,1); Phyt = Nute; Zoo = Nute;
for iz=1:nz
    Nute(iz,:) = Nute0;
    Phyt(iz,:) = Phyt0;
    Zoo(iz,:) = Zoo0;
    t_save(iz,1) = 0;
    N_save(iz,1) = Nute(iz);
    P_save(iz,1) = Phyt(iz);
    Z_save(iz,1) = Zoo(iz);
end

% Begin time stepping
for istep=1:maxstep
    time = istep*dt;
    [Nnew, Pnew, Znew] = NPZ_Implicit(...
        Nute, Phyt, Zoo, ...
        zvec, dt,...
        Vm, Ks, Kext, Rm, Lambda, gamma, m, g);
    Nute = Nnew;
    Phyt = Pnew;
    Zoo = Znew;
    
%     if min([Nute Phyt Zoo]) > N_tot 
%         keyboard
%     end

    if any(isnan([Nute Phyt Zoo]))
        keyboard
    end
    
    if mod(istep,dtsave_step) == 0
        isave=floor(istep/dtsave_step+1);
        t_save(:,isave) = time; 
        N_save(:,isave) = Nute;
        P_save(:,isave) = Phyt;
        Z_save(:,isave) = Zoo;
    end
end

% Plotting
figure(5)        
d = 3;
%subplot(5,1,1); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');

% txt=sprintf('N(k), P(g), Z(r), at zlevel=%0.2f m',zvec(d));
% txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
%       Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
% txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, N_{tot}=%0.2f',...
%     gamma, m*Sec_day, g*Sec_day, N_tot);
% title(sprintf('%s\n%s, %s',txt,txt2,txt3));
% grid on
% 
% d = nz-25;
% subplot(5,1,2); 
% plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
% hold on
% plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
% plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
% txt=sprintf('N(k), P(g), Z(r) at zlevel=%0.2f m',zvec(d));
% title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
% grid on
% 
% d = nz-35;
% subplot(5,1,3); 
% plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
% hold on
% plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
% plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
% txt=sprintf('N(k), P(g), Z(r) at zlevel=%0.2f m',zvec(d));
% title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
% grid on
% 
% d = nz-45;
% subplot(5,1,4); 
% plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
% hold on
% plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
% plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
% txt=sprintf('N(k), P(g), Z(r) at zlevel=%0.2f m',zvec(d));
% title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
% grid on
% 
% d = nz-55;
% subplot(5,1,5); 
% plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
% hold on
% plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
% plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
% txt=sprintf('N(k), P(g), Z(r) at zlevel=%0.2f m',zvec(d));
% title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
% grid on