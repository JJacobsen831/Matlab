clear;
Sec_day = 86400;
dt = 1; %second **Trouble making it larger than 1**
dtday = dt/Sec_day; %days
nz = 66; % number of depth bins
z_bot = -65;
zvec = linspace(z_bot,0,nz)';
%IC 
N_tot= 10;
Nute0 = 4;
Phyt0 = 3;
Detr0 = 1;
Zoo0 = N_tot-Nute0-Phyt0-Detr0;
Nute = NaN(nz,1); Phyt = Nute; Detr = Nute; Zoo = Nute;
for iz=1:nz
    Nute(iz,:) = Nute0;
    Phyt(iz,:) = Phyt0;
    Detr(iz,:) = Detr0;
    Zoo(iz,:) = Zoo0;
end
% Parameters
Vm = 2.0/Sec_day;       % max nutrient uptake rate
Ks = 0.1;               % Michaelis-menton half saturation value
Kext = 0.06;            % e-folding scale of PAR with depth
Rm = 0.5/Sec_day;       % Max grazing rate
Lambda = 0.2;           % level of saturated grazing
gamma = 0.3;            % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1/Sec_day;        % phytoplankton mortality
g = 0.2/Sec_day;        % zooplankton mortality
Md = 0.05/Sec_day;      % Zooplankton death bits rate
RR = 0.1/Sec_day;       % Detritus remin rate
Exc = 0.15/Sec_day;     % zooplankton excretion rate
Kv = 1e-5;              % Diffusivity constant 
% save interval
maxdays = 200;
maxtime_sec = maxdays*Sec_day;
maxstep=maxtime_sec/dt;
dtsave_days = 0.1;
dtsave_sec = dtsave_days*Sec_day;
dtsave_step = dtsave_sec/dt;
nsaves = round(maxstep/dtsave_step);
t_save = nan*ones(nz,nsaves);
N_save = t_save; P_save = t_save; Z_save = t_save; D_save = t_save;
% Save initial conditions as time step one
for iz = 1:nz
  t_save(iz,1) = 0;
  N_save(iz,1) = Nute(iz);
  P_save(iz,1) = Phyt(iz);
  Z_save(iz,1) = Zoo(iz);
  D_save(iz,1) = Detr(iz);
end
for istep=1:maxstep
    time = istep*dt;
    [Nnew, Pnew, Znew, Dnew] = NPZD_ImpDiff(...
        Nute, Phyt, Zoo, Detr, ...
        zvec, dt, Kv,...
        Vm, Ks, Kext, Rm, Lambda, gamma, m, g, Md, RR, Exc);
    Nute = Nnew;
    Phyt = Pnew;
    Zoo = Znew;
    Detr = Dnew;
    % need to add sinking here or in subroutine
    
    if mod(istep,dtsave_step) == 0
        isave=time/dtsave_step+1;
        t_save(:,round(isave)) = time; % isave became floating point(?)
        N_save(:,round(isave)) = Nute; % when dt > 1
        P_save(:,round(isave)) = Phyt;
        Z_save(:,round(isave)) = Zoo;
        D_save(:,round(isave)) = Detr;
    end
end
        
d = nz-5;
subplot(5,1,1); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
plot(t_save(d,:)/Sec_day, D_save(d,:)/N_tot, 'b');
txt=sprintf('N(k), P(g), Z(r), D(b) at zlevel=%0.2f m',zvec(d));
txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
      Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
    gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt,txt2,txt3));
grid on

d = nz-25;
subplot(5,1,2); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
plot(t_save(d,:)/Sec_day, D_save(d,:)/N_tot, 'b');
txt=sprintf('N(k), P(g), Z(r), D(b) at zlevel=%0.2f m',zvec(d));
% txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
%       Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
% txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
%     gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
grid on

d = nz-35;
subplot(5,1,3); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
plot(t_save(d,:)/Sec_day, D_save(d,:)/N_tot, 'b');
txt=sprintf('N(k), P(g), Z(r), D(b) at zlevel=%0.2f m',zvec(d));
% txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
%       Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
% txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
%     gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
grid on

d = nz-45;
subplot(5,1,4); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
plot(t_save(d,:)/Sec_day, D_save(d,:)/N_tot, 'b');
txt=sprintf('N(k), P(g), Z(r), D(b) at zlevel=%0.2f m',zvec(d));
% txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
%       Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
% txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
%     gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
grid on

d = nz-55;
subplot(5,1,5); 
plot(t_save(d,:)/Sec_day, N_save(d,:)/N_tot, 'k');
hold on
plot(t_save(d,:)/Sec_day, P_save(d,:)/N_tot, 'g');
plot(t_save(d,:)/Sec_day, Z_save(d,:)/N_tot, 'r');
plot(t_save(d,:)/Sec_day, D_save(d,:)/N_tot, 'b');
txt=sprintf('N(k), P(g), Z(r), D(b) at zlevel=%0.2f m',zvec(d));
% txt2=sprintf('V_m=%0.2f, K_s=%0.2f, K_{ext}=%0.2f, R_m=%0.2f, \\Lambda=%0.2f',...
%       Vm*Sec_day, Ks, Kext,Rm*Sec_day, Lambda);
% txt3=sprintf('\\gamma=%0.2f, m=%0.2f, g=%0.2f, K_v=%0.2f, N_tot=%0.2f',...
%     gamma, m*Sec_day, g*Sec_day, Kv, N_tot);
title(sprintf('%s\n%s, %s',txt));% ,txt2,txt3));
grid on



