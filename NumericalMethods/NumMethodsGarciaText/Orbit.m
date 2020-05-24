% Orbit - Program to compute the orbit of a comet
clear; 
%* Set initial position and velocity of the comet
r0 = input('Enter initial radial distance (AU): ');
v0 = input('Enter initial tangential velocity (AU/yr): ');
r = [r0 0]; v = [0 v0];
state = [r(1) r(2) v(1) v(2)];

%* Set physical parameters (mass, G*M)
GM = 4*pi^2;        %grav const.
mass = 1.;          %mass of comet
adaptErr = 1.e-3;   %Error parameter used by adaptive Runge-Kutta 
time = 0;

%* Loop over desired number of steps using specified numerical method
nStep = input('Enter number of steps: ');
tau = input('Enter time step (yr): ');
NumericalMethod = menu('Choose a numerical method:', ...
    'Euler', 'Euler-Cromer', 'Runge-Kutta', 'Adaptive R-K');
for iStep = 1:nStep
    %* Record postion and energy for plotting
    rplot(iStep) = norm(r);             %record position for polar plot
    thplot(iStep) = atan2(r(2),r(1));   
    tplot(iStep) = time;
    kinetic(iStep) = 0.5*mass*norm(v)^2; %record energies
    potential(iStep) = -GM*mass/norm(r);
    
    %* calculate new position and velocity using desired method
    if (NumericalMethod == 1)
        accel = -GM*r/norm(r)^3;
        r = r + tau*v;                  %Euler Step
        v = v + tau*accel;
        time = time + tau;
    elseif (NumericalMethod == 2)
        accel = GM*r.norm(r)^3;
        v = v + tau*accel;
        r = r + tau*v;                  %Euler-Cromer Step
        time = time + tau;
    elseif (NumericalMethod == 3)
        state = rk4(state,time,tau,'gravkr',GM);
        r = [state(1) state(2)];        %4th order R-K
        v = [state(3) state(4)];
        time = time + tau;
    else
        [state time tau] = rka(state, time, tau, adaptErr,'gravrk',GM);
        r = [state(1) state(2)];        %adaptive R-K
        v = [state(3) state(4)];
    end
end
%* Graph the trajectory of the comet
figure(1); clf;
polar(thplot,rplot,'+');
xlabel('Distance (AU)'); grid;
pause(1)

%* Graph Energy vs time
figure(2); clf;
totalE = kinetic + potential;
plot(tplot,kinetic,'-', tplot, potential, '--', tplot,totalE,'-')
legend('Kinetic', 'Potential', 'Total')
xlabel('Time (yr)'); ylabel('Energy (M AU^2/yr^2)');