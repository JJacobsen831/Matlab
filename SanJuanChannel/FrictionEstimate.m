%friction estimate

H = 100;    %scale depth
U =0.6;     %scale vel
om = 1.4e-4;    %M2 tide frequency
om0 = om/0.4;   %near resonant frequency

R = logspace(0.01, pi);

Eqn13 = (1-om/om0-0.5.*i.*R./om0).^0.5;

phi = atan(imag(Eqn13)./real(Eqn13));

plot(R,phi)