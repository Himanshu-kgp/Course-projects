clear;
clc;
close all
y = linspace(-1, 1, 100);
x = linspace(-2, 1, 100);

[X, Y] = meshgrid(x, y);
U = 1;
m = 5;

R = sqrt(X.^2 + Y.^2) ;
Theta = atan2(Y, X) ;
psi = U*R.*sin(Theta) + (m/(2*pi))*Theta ;
phi = U*R.*cos(Theta) + (m/(2*pi))*log(R) ;



figure1 = figure; 

hold all;
contour(X, Y, psi, 99, '-b', linewidth=1);
% plot(-2.5/pi, 0, '-m.', MarkerSize=30)
contour(X, Y, phi, 99, '--r', linewidth=2);
pbaspect([1 1 1]);

axis off
axis image

%%
hold on;
theta = linspace(0.8, 3.5, 101);
b = m/(2*pi*U);
r = b*(pi-theta)./sin(theta);
x = r.*cos(theta);
y = r.*sin(theta);
ylim([-1, 1])
x_full = [x, fliplr(x)];
y_full = [y, -fliplr(y)];
fill(x_full, y_full, [1 1 0], 'EdgeColor', 'none', 'FaceAlpha', 1);  
title("Flow Past a Rankine Half Body", Interpreter="latex", FontSize=16)
print(gcf, 'flow_past_a_half_body.png', '-dpng', '-r200');



