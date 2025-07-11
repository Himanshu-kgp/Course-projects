clear; clc; 
close all;




Height = 20;
T0 = 65;
TInf = 25;
alpha=0.00002418; 
nu=0.00001941;
Pr = nu/alpha;
beta=0.003354 ;
grav = 9.81;

t_min = eps;
r = 0;
g = 0;
t_final = 10; % > 6


eps = 0.001;

p0 = -1.1;
p1 = -1.2;
q0 = -1.3;
q1 = -1.5;

[~, y00] = ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p0, 0, 0, q0]);
N = length(y00(:, 1));
phi1_00 = y00(N, 1) - r;
phi2_00 = y00(N, 4) - g;


[~, y01] = ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p0, 0, 0, q1]);
N = length(y01(:, 1));
phi1_01 = y01(N, 1) - r;
phi2_01 = y01(N, 4) - g;



[~, y10] = ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p1, 0, 0, q0]);
N = length(y10(:, 1));
phi1_10 = y10(N, 1) - r;
phi2_10 = y10(N, 4) - g;


[~, y11] = ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p1, 0, 0, q1]);
N = length(y11(:, 1));
phi1_11 = y11(N, 1) - r;
phi2_11 = y11(N, 4) - g;

err = 1+eps;
i = 1;


while(err > eps)

    dphi1p = (phi1_11 - phi1_01)/(p1 - p0);
    dphi1q = (phi1_11 - phi1_10)/(q1 - q0);
    
    dphi2p = (phi2_11 - phi2_01)/(p1 - p0);
    dphi2q = (phi2_11 - phi2_10)/(q1 - q0);



    d = linsolve([dphi1p, dphi1q; dphi2p, dphi2q], [-phi1_11; -phi2_11]);
    dp = d(1);
    dq = d(2);

    p = p1 + dp;
    q = q1 + dq; 

    p0 = p1;
    q0 = q1;
    p1 = p;
    q1 = q;

    [~, y01] =  ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p0, 0, 0, q1]);
    N = length(y01(:, 1));
    phi1_01 = y01(N, 1) - r;
    phi2_01 = y01(N, 4) - g;

    [~, y10] =  ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p1, 0, 0, q0]);
    N = length(y10(:, 1));
    phi1_10 = y10(N, 1) - r;
    phi2_10 = y10(N, 4) - g;

    phi1_00 = phi1_11;
    phi2_00 = phi2_11;

    [eta, y11] =  ode45(@(t, y) eqns(t, y, Pr), [t_min, t_final], [1, p1, 0, 0, q1]);
    N = length(y11(:, 1));
    phi1_11 = y11(N, 1) - r;
    phi2_11 = y11(N, 4) - g;


    disp([p, q]);
    disp(i);
    disp(err)
    i = i + 1;
    err = sqrt(phi1_11^2 + phi2_11^2);
end

R = y11(:, 1);
S = y11(:, 2);
F = y11(:, 3);
G = y11(:, 4);
H = y11(:, 5);

%% R
figure 
grid on
plot(eta, R, "-or", LineWidth=2);
xlabel("$\eta$", Interpreter="latex", FontSize=20);
ylabel("$\theta$", Interpreter="latex", FontSize=20);
title("$\theta$ vs $\eta$", Interpreter="latex", FontSize=24);
ylim([0, 1])
ax = gca;
ax.FontSize = 18; 

%% G
figure 
grid on
plot(eta, -G, "-ob", LineWidth=2);
xlabel("$\eta$", Interpreter="latex", FontSize=20);
ylabel("$G$", Interpreter="latex", FontSize=20);
title("$G$ vs $\eta$", Interpreter="latex", FontSize=24);
ylim([0, 0.5])
ax = gca;
ax.FontSize = 18; 



%%

Ra_H = grav*beta*(T0-TInf)*(Height^3)/(nu*alpha);
xmax = Height*t_final/(Ra_H^(0.25));

syms xvar yvar
Ra_yvar = grav*beta*(T0-TInf)*(yvar.^3)/(nu*alpha);
etaVar = (xvar/yvar)*(Ra_yvar^0.25);


polyG = polyfit(eta, G, 3);
Gxy = 0;
for i=1:length(polyG)
    Gxy = Gxy + polyG(i)*etaVar^(length(polyG) - i);
end


polyR = polyfit(eta, R, 4);
Rxy = 0;
for i=1:length(polyR)
    Rxy = Rxy + polyR(i)*etaVar^(length(polyR) - i);
end


polyF = polyfit(eta, F, 4);
Fxy = 0;
for i=1:length(polyF)
    Fxy = Fxy + polyF(i)*etaVar^(length(polyF) - i);
end

polyS = polyfit(eta, S, 3);
Sxy = 0;
for i=1:length(polyS)
    Sxy = Sxy + polyS(i)*etaVar^(length(polyS) - i);
end

polyH = polyfit(eta, H, 4);
Hxy = 0;
for i=1:length(polyH)
    Hxy = Hxy + polyH(i)*etaVar^(length(polyH) - i);
end



%% Heat Transfer Coefficient and Heat Flux



Nu_y = - S(1) * (Ra_yvar^(0.25));

figure
grid on

ax = gca;
ax.FontSize = 18; 

k_air = 27.72e-3;
h_y = k_air*Nu_y/yvar;


fplot(h_y, [0, Height], "-", linewidth=2);
xlabel("y (m)", Interpreter="latex", FontSize=20);
ylabel("Local heat transfer coefficient", Interpreter="latex", FontSize=20);
title("$\rm{h}_y$ vs $y$", Interpreter="latex", FontSize=20);

h = eval(int(h_y, 0, Height)/Height) ;

flux = h*(T0 - TInf);



%% Thermal boundary layer thickness


eta_bl = eta(R<=0.01);
eta_bl = eta_bl(1);
del_T = eta_bl*yvar/(Ra_yvar^(0.25));

xmaxbl = eval(subs(del_T, yvar, Height));

figure
grid on
fplot(yvar, del_T, [0, Height], LineWidth=2);
ylabel("$\delta_T$ (m)", Interpreter="latex", FontSize=20);
xlabel("y (m)",  Interpreter="latex", FontSize=20);
title("Thermal Boundary Layer Thickness",  Interpreter="latex", FontSize=20);
ax = gca;
ax.FontSize = 18; 



%% Streamlines


psi = alpha*(Ra_yvar^(0.25))*Fxy ;
figure
grid on
fcontour(psi, [0, xmaxbl, 0.1, Height], LineWidth=2, LevelStep=0.01,   fill='off');
% fc.LevelList = 0:0.1:1;
xlim([0, xmaxbl]);
xlabel("x (m)", Interpreter="latex", FontSize=20);
ylabel("y (m)", Interpreter="latex", FontSize=20);
title("Streamlines",  Interpreter="latex", FontSize=20);
% % colorbar



%% HeatLines
v = (alpha/yvar)*(Ra_yvar^(0.5))*(-Gxy);
T = TInf + (T0 - TInf)*Rxy ;
dHdx = - T*v;


HF = int(dHdx, xvar);

figure
grid on
fc = fcontour(HF, [0, xmaxbl, 0, Height], LineWidth=2, LevelStep=0.2,  fill='off');
xlabel("x (m)", Interpreter="latex", FontSize=20);
ylabel("y (m)", Interpreter="latex", FontSize=20);
title("Heatlines",  Interpreter="latex", FontSize=20);
% colorbar
