clear;
N_tot = 10;
Nute = 5;
Phyt = 2;
Zoo = N_tot - Nute - Phyt;
%z=-35;
z_bot = -65;
zvec = linspace(0,z_bot,5);
nz = length(zvec);
tau=0.01;
maxdays = 1;
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
isave=1;
for istep=1:maxstep
    time = istep*tau;
    
    for iz = 1:nz
        
        if mod(istep,dtsave_step) ==0 
         isave=time/dtsave_sec;                 %isave is advaced with iz for record timestep
            t_save(iz,isave) = time;
            N_save(iz,isave) = Nute;
            P_save(iz,isave) = Phyt;
            Z_save(iz,isave) = Zoo;
            dNdt_save(iz,isave) = dNdt;
        end
        z = zvec(iz);
        [dNdt,dPdt,dZdt] = NPZterms(Nute,Phyt,Zoo,z);
        Nute = Nute+dNdt*tau;
        Phyt = Phyt+dPdt*tau;
        Zoo = Zoo+dZdt*tau;
    end
end

plot(t_save(1,:),N_save(1,:),'k')
hold on
plot(t_save,P_save(1,:),'g')
plot(t_save,Z_save(1,:),'r')