%Pendulum with Euler and Verlet
clear all; %clear memory and print header
%* Select numerical method
NumericalMethod = menu('Choose a numerical method:', 'Euler','Verlet');

%* Set initial position and velocity of pendulum
theta0 = input('Enter initial angle (degrees): ');
theta = theta0*pi/180;  %convert to radians
omega = 0;              %set initial velocity

%* Set the physical constants and other variables
g_over_L = 1;
time=0;
irev = 0; %used to count number of reversals

% enter timestep
tau = input('Enter time step: ');

%* Take one backward step to start Verlet
accel = -g_over_L*sin(theta);
theta_old = theta - omega*tau + 0.5*tau^2*accel;

%* Loop over desired number of steps with given time step and method
nstep=input('Enter number of time steps: ');

for istep=1:nstep
    %* Record angle and time for plotting
    t_plot(istep) = time;
    th_plot(istep) = theta*180/pi;
    time = time+tau;
    %* Compute new position and velocity using Euler or Verlet
    accel = -g_over_L*sin(theta);
    if (NumericalMethod == 1)
        theta_old = theta; % Save previous angle
        theta = theta+tau*omega; %Euler method
        omega = omega +tau*accel;
    else
        theta_new = 2*theta - theta_old + tau^2*accel;
        theta_old = theta; % Verlet method
        theta = theta_new;
    end
    %*Test if pendulum passed through theta = 0, if yes estimate period
    if (theta*theta_old <0) %test for sign change
        fprintf('Turning point at time t = %f \n', time);
        if(irev ==0)
            time_old=time; %if this is the first change, record the time
        else
            period(irev) = 2*(time-time_old);
            time_old = time;
        end
        irev = irev + 1; %increment the number of reversals
    end
end
%* Estimate the period of oscillations, including error bar
AverPeriod = mean(period);
ErrorBar = std(period)/sqrt(irev);
fprintf('Average period = %g +/- %g\n', AverPeriod,ErrorBar);
%* Graph oscillations as theta vs time
clf; figure(gcf);
plot(t_plot, th_plot,'+');
xlabel('Time'); ylabel('\theta (degrees)');