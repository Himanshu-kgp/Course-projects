clear;
clc;
close all
y = linspace(-2, 2, 100);
x = linspace(-2, 2, 100);

[X, Y] = meshgrid(x, y);
U = 1;
a = 1;

R = sqrt(X.^2 + Y.^2) ;
Theta = atan(Y./X) ;
psi = U*(R-(a^2)./R).*sin(Theta);
phi = U*(R + (a^2)./R).*cos(Theta);



figure1 = figure; 

hold all;
contour(X, Y, psi, 151, '-b', linewidth=1);
% plot(x, sqrt(a^2 - x.^2), '-k');
contour(X, Y, phi, 51, '--r', linewidth=2);
% contour(X, Y, psi, [0 0]);
pbaspect([1 1 1]);
%%

theta = linspace(0, 2*pi, 100);    
x_center = 0; y_center = 0;        
x = x_center + a*cos(theta);      
y = y_center + a*sin(theta);      
fill(x, y, 'y', 'EdgeColor', 'none');  
axis equal 
axis off;
title("Flow Past a Cylinder", Interpreter="latex", FontSize=16)
print(gcf, 'flow_past_a_cylinder.png', '-dpng', '-r200');

