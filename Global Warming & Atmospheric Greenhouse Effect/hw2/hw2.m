clear; clc; close all;

%% Part 1
S = 250*1e6*1e3; % Distance between the Sun and the Mars in m
R_s = 7*1e8; %  Radius of the Sun in m
T_sun = 5777; % in K
sigma = 5.67*1e-8; % in SI
omega = pi*R_s^2/S^2;

q_sol_mars = sigma*T_sun^4*omega/pi; % in W/m^1

%% Part 2
C1 = 3.74*1e-16; % in SI units
C2 = 14388*1e-6; % in SI units
data = readtable("rock_formatted.dat");
lam = data.Var1*1e-6; % wavelength in m
rho_lam = data.Var2; % spectral reflectivity of granite

alpha_lam = 1-rho_lam; % spectral absorptivity of granite
eps_lam = alpha_lam; % spectral emissivity of granite

Eb_sun_lam = C1./((exp(C2./(lam*T_sun)) - 1).*lam.^5);
% plot(log(lam), log(Eb_sun_lam), LineWidth=1.5);

alpha = 1/(sigma*T_sun^4)*trapz(lam, alpha_lam.*Eb_sun_lam);

tol = 0.01;
res = 1;
T_mars = 250; % initial guess in K
T_mars_new = T_mars;
while(res>tol)
    T_mars = T_mars_new;
    Eb_mars_lam = C1./((exp(C2./(lam*T_mars)) - 1).*lam.^5);
    eps = 1/(sigma*T_mars^4)*trapz(lam, eps_lam.*Eb_mars_lam);

    T_mars_new = (alpha*q_sol_mars/(4*sigma*eps))^(1/4);
   
    res = abs(T_mars - T_mars_new);
end
