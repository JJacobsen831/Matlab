%Projectile motion
%Forward difference and Euler method to compute trajectory of a baseball
clear; help balle; %clear memory and print header
%*set initial position and velocity of baseball
y1 = input('Enter initial height (meters): ');
r1 = [0, y1];
speed = input('Enter initial speed (m/s): ');
theta = input('Enter initial angle (degrees): ');
v1 = [speed*cos(theta*pi/180), speed*sin(theta*pi/180)]; %initial velocity
r = r1; v = v1; % set initial position and velocity

%*Set physical parameters (mass, Cd, etc)
Cd = 0.35; %drag coefficient (dimensionless)
area = 4.3e-3; %cross sectional area of projectile
grav = 9.81; 
mass = 0.145;
airFlag = input('Air resistance? (Yes:1, No: 0): ');
if (airFlag == 0)
    rho = 0;
else 
    rho = 1.2;
end
air_const = -0.5*Cd*rho*area/mass; % air resistance constant

%*Loop until ball hits ground or max steps completed
tau = input('Enter Timestep, tau (sec): ');
maxstep = 1000; 
for istep=1:maxstep
    %*record postion (computed and theoretical) for plotting
    xplot(istep) = r(1); %Record trajectory for plot
    yplot(istep) = r(2);
    t = (istep-1)*tau; %Current time
    xNoAir(istep) = r1(1)+v1(1)*t;
    yNoAir(istep) = r1(2)+v1(2)*t-0.5*grav*t^2;
    %*Calculate the acceleration of the ball
    accel = air_const*norm(v)*v; %air resistance
    accel(2) = accel(2)-grav; %gravity
    %*Calculate the new position and  velocity using Euler method
    r = r+tau*v; %Euler step
    v = v+tau*accel;
    %*If ball reaches ground (y<0), break out of loop
    if (r(2) < 0)
        xplot(istep+1) = r(1);
        yplot(istep+1) = r(2);
        break;
    end
end
%* Print maximum range and time of flight
fprintf('Maximum range is %g meters\n', r(1));
fprintf('Time of flight is %g seconds\n', istep*tau);
%* Graph the trajectory of the baseball
clf; figure(gcf); %clear figure window and bring forward
% Mark location of the ground by striaght line
xground = [0 max(xNoAir)]; yground = [0 0];
% plot the computed trajectory and parabolic, no-air curve
plot(xplot, yplot, '+', xNoAir, yNoAir,'-',xground,yground,'-')'
legend('Euler method', 'Theory (No air)');
xlabel('Range(m)'); ylabel('Height (m)');
title('Projectile Motion');
