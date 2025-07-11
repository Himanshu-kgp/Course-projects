clear;
clc;
y = linspace(-2, 2, 100);
x = linspace(-2, 2, 100);

[X, Y] = meshgrid(x, y);
U = 1;
a = 1;
gamma = 4*pi*a*U  ;

R = sqrt(X.^2 + Y.^2) ;
Theta = atan2(Y, X) ;

psi = U*(R-(a^2)./R).*sin(Theta) + gamma*log(R/a)/(2*pi);
phi = U*(R + (a^2)./R).*cos(Theta) - gamma*Theta/(2*pi);



figure1 = figure; 

hold all;
contour(X, Y, psi, 99, '-b', linewidth=1);
hold on; hold all; 
contour(X,Y, psi, [0 0 ], '-b',  linewidth=1);
contour(X, Y, phi, 100, '--r', linewidth=2);
pbaspect([1 1 1]);
theta = linspace(0, 2*pi, 100);    
x_center = 0; y_center = 0;        
x = x_center + a*cos(theta);      
y = y_center + a*sin(theta);      
fill(x, y, 'y', 'EdgeColor', 'none');  
axis equal 
axis image
axis off;
title("Flow Past a Cylinder with Circulation", Interpreter="latex", FontSize=16)
print(gcf, 'flow_past_a_cylinder_with_circulation.png', '-dpng', '-r200');

