clear; clc; close all;

% Crank-rocker
r1 = 4;
r2 = 2;
r3 = 5;
r4 = 6;

% r1 = 2;
% r2 = 4;
% r3 = 5;
% r4 = 6;

num_points = 200;

fourR(r1, r2, r3, r4, num_points);
fourRAnimate(r1, r2, r3, r4, -1, "fourRCrankRocker.gif");
% fourRAnimate1(r1, r2, r3, r4, -1);
% fourRAnimate2(r1, r2, r3, r4, -1);