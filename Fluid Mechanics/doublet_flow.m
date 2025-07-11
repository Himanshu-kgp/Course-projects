clear ;
clc ;
close all;
y = linspace(-1.5, 1.5, 150);
x = linspace(-1.5, 1.5, 150);

[X, Y] = meshgrid(x, y);
m = 1;
epsilon = 4;
mu = m*epsilon/pi ;
phi =  X./(X.^2 + Y.^2) ;
psi =  -Y./(X.^2 + Y.^2) ;


figure1 = figure; 

hold all;
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);
contour(X, Y, psi, 49, '-b', linewidth=2);
contour(X, Y, phi, 49, '--r', linewidth=2);
pbaspect([1 1 1]);

axis off
axis image
print(gcf, 'doublet.png', '-dpng', '-r200');

