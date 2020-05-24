function deriv = gravrk(s,t,GM)
% Returns right-hand side of Kepler ODE; used Runge-Kutta routines
% Inputs
%   s   State vector [r(1) r(2) r(3) r(4)]
%   t   Time (not used)
%   GM  Parameter G*M (grav. const. * solar mass)
% Outputs
%   deriv Derivatives [dr(1)/dt dr(2)/dt dv(1)/dt dv(2)/dt]

%* Compute acceleration
r = [s(1) s(2)];    %Unravel the vector s into position and velocity
v = [s(3) s(4)];    
accel = -GM*r/norm(r)^3; %Grav. Accel.

%* Return derivatives [dr(1)/dt dr(2)/dt dv(1)/dt dv(2)/dt]
deriv = [v(1) v(2) accel(1) accel(2)];
return;