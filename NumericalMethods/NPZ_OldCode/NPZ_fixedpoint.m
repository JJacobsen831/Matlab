clear;
z_bot=-65;           % depth
zvec = linspace(-5,z_bot,5);
Kext = 0.06;   % e-folding scale of PAR with depth

Vm = 2.0*exp(Kext*zvec);      % max nutrient uptake rate with z dependence
Ks = 0.1;      % Michaelis-menton half saturation value
Rm = 0.5;      % Max grazing rate
Lambda = 0.2;  % level of saturated grazing
gamma = 0.3;   % percent of sloppy grazing (1-Gamma) is assimialtion eff.
m = 0.1;       % phytoplankton mortality
g = 0.2;       % zooplankton mortality
N_tot = 10;    % total nitrogen

P_star = -1*log(1-g/((1-gamma)*Rm))/Lambda;

c1 = g/(1-gamma);
c2 = c1*(N_tot-P_star)/P_star+m;
c3 = c1/P_star;

for n=1:length(zvec)
    c4 = (c3*Ks+Vm(n)-c2)/c3;
    c5 = -c2*Ks/c3;

    p = [1 c4 c5];
    
    r = roots(p);
    
    N_star(n) = r(r>0);


    Z_star (n)= N_tot - N_star(n) - P_star;
end
