% Right Forward Difference Derivative and Absolute Error
clear all;
t0 = 1; % set initial value
%  f(t) = x^2
f_prime = nan*ones(20,1); dt = f_prime; AbsError = f_prime;
for n=1:20
    dt(n) = 10^(-n);
    f_prime(n) = ((t0+dt(n))^2 - (t0)^2)/dt(n);
    AbsError(n) = abs(2*t0 - f_prime(n));
end
scatter(dt, AbsError)
set(gca,'xscale','log')
set(gca,'yscale','log')
%  f(t) = x^5
f_prime = nan*ones(20,1); dt = f_prime; AbsError = f_prime;
for n=1:20
    dt(n) = 10^(-n);
    f_prime(n) = ((t0+dt(n))^5 - (t0)^5)/dt(n);
    AbsError(n) = abs(5*t0^4 - f_prime(n));
end
scatter(dt, AbsError)
set(gca,'xscale','log')
set(gca,'yscale','log')
%  f(t) = sin(t)
t0 = pi/2;
f_prime = nan*ones(20,1); dt = f_prime; AbsError = f_prime;
for n=1:20
    dt(n) = 10^(-n);
    f_prime(n) = (sin(t0+dt(n)) - sin(t0))/dt(n);
    AbsError(n) = abs(cos(t0) - f_prime(n));
end
scatter(dt, AbsError)
set(gca,'xscale','log')
set(gca,'yscale','log')
