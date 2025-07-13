clear; 
clc;
close all;
syms theta

L = 2;

y1 = 0;
y2 = (2*L/pi)*((theta-pi/2) -0.25*sin(4*(theta-pi/2))) ;
y3 = L;
y4 = (L/2)*(1 + cos(1.5*(theta-4*pi/3)));

y = piecewise(0<=theta & theta<=pi/2, 0, ...
              pi/2<=theta & theta<=pi, y2, ...
              pi<=theta & theta<=4*pi/3, y3, ...
              4*pi/3<=theta & theta<=2*pi, y4);


dy = piecewise(0<=theta & theta<=pi/2, diff(y1, theta), ...
              pi/2<=theta & theta<=pi, diff(y2, theta), ...
              pi<=theta & theta<=4*pi/3, diff(y3, theta), ...
              4*pi/3<=theta & theta<=2*pi, diff(y4, theta));

[r_b, t] = dimensions(y, theta);
r_b = eval(r_b);
t = eval(t);

if(r_b<=0)
    r_b = L;
end
% r_b = 3.2;


rotateCam(r_b, t, y, dy)