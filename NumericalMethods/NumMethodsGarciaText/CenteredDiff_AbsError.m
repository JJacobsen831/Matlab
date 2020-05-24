clear all;
t0 = 1; % set initial value
%  f(t) = x^2
f_prime = nan*ones(20,1); dt = f_prime; AbsError = f_prime;
for n=1:20
    dt(n) = 10^(-n);
    f_prime(n) = ((t0+dt(n))^2 - (t0-dt(n))^2)/(2*dt(n));
    AbsError(n) = abs(2*t0 - f_prime(n));
end
scatter(dt, AbsError)
set(gca,'xscale','log')
set(gca,'yscale','log')
% Second derivative
clear all;
t0 = 1; % set initial value
%  f(t) = x^2
f_prime_prime = nan*ones(20,1); dt = f_prime_prime; 
AbsError = f_prime_prime;
for n=1:20
    dt(n) = 10^(-n);
    f_prime_prime(n) = ((t0+dt(n))^2 + (t0-dt(n))^2 - 2*(t0)^2)/(dt(n)^2);
    AbsError(n) = abs(2 - f_prime(n));
end
scatter(dt, AbsError)
set(gca,'xscale','log')
set(gca,'yscale','log')
