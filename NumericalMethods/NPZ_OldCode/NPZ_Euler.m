% NPZ model using function NPZ terms
clear;
ifig1=1;
% Set IC
N_tot = 10;
Nute = 3.21;
Phyt = 4.2365;
Zoo = N_tot - Nute - Phyt;
% Set runtime parameters
tau = 0.1;
maxtime_days = 5;
% Depth
zvec = 0;
%z_bot = -65;
%zvec = linspace(0,z_bot,5);
nzvec = length(zvec);
% Implement runtime parameters
sec_day = 86400;
maxtime_sec = maxtime_days*sec_day;
maxstep = maxtime_sec/tau;
% Save interval
dtsave_days = 0.01;
dtsave_sec = dtsave_days*sec_day;
dtsave_step = dtsave_sec/tau;
nsaves = round(maxstep/dtsave_step);

t_save = nan*ones(1,nsaves);
N_save = t_save; P_save = t_save; Z_save = t_save;
isave=1;
for istep=1:maxstep
    time=istep*tau;
    %for iz=1:nzvec
    iz =1;
        if mod(istep,dtsave_step) == 0
           isave = isave+1;
           t_save(isave) = time;
           N_save(iz,isave) = Nute;
           P_save(iz,isave) = Phyt;
           Z_save(iz,isave) = Zoo;
%            dNdt_save(iz,isave) = dNdt;
%            dPdt_save(iz,isave) = dPdt;
%            dZdt_save(iz,isave) = dZdt;
        end
        %
        [dNdt, dPdt, dZdt] = NPZterms(Nute,Phyt,Zoo); %,zvec);
        Nute = Nute+dNdt*tau;
        Phyt = Phyt+dPdt*tau;
        Zoo = Zoo+dZdt*tau;
    %end
end

figure(ifig1)
plot(t_save,N_save)
hold on
plot(t_save,P_save)
plot(t_save,Z_save)