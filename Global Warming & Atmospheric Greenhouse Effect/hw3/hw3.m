clear; clc; close all;
data = readtable('CO2_layer9.dat');
p = 610*1e-5; % in bar
L = 40*1e3*1e2; % in cm
T_mars = 210; % in K
C1 = 3.74*1e-16; % in SI units
C2 = 14388*1e-6; % in SI units
sigma = 5.67*1e-8; % in SI units
T_sun = 5777; % in K
%%
wavenumber = data.Var1;  % in cm^-1
kappa_p_lam = data.Var2; % pressure-based spectral absorption coefficient in (bar*cm)^-1

k_lam = p*kappa_p_lam;   % 
tau_lam = exp(-k_lam*L); % 

lam = (1./wavenumber*1e4); % in microns

close all
figure('WindowState','maximized');
plot(lam, tau_lam, LineWidth=1)
xlabel("Wavelength, $\lambda$, ($\mu$m)", FontSize=18)
ylabel("Spectral Transmissivity, $\tau_{\lambda}$", FontSize=18);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;

%% Part 2
lam = sort(lam*1e-6); % in m
Eb_sun_lam = C1./((exp(C2./(lam*T_sun)) - 1).*lam.^5);
Eb_mars_lam = C1./((exp(C2./(lam*T_mars)) - 1).*lam.^5);

tau_in = 1/(sigma*T_sun^4)*trapz(lam, tau_lam.*Eb_sun_lam);
tau_out = 1/(sigma*T_mars^4)*trapz(lam, tau_lam.*Eb_mars_lam);