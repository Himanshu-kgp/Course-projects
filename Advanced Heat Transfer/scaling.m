clear; clc; close all;

Height = 20;
T0 = 65;
TInf = 25;
alpha=0.00002418; 
nu=0.00001941;
Pr = nu/alpha;
beta= 1/(TInf + 273.15);
grav = 9.81;


Gr = grav*beta*(T0-TInf)*Height^3/(nu^2);
Ra = Gr*Pr;





% 
delT = Height*Ra^(-1/4);


% 
Nu = Ra^(1/4);


%
vc = (alpha/Height)*Ra^0.5;






Re = vc*Height/nu;
Ri = Gr/Re^2;

