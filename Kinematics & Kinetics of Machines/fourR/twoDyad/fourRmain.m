clear; clc;
r1 = 5;
r2 = 4;
r3 = 2;
r4 = 6;
num_points = 200;

type = fourRtype(r1, r2, r3, r4);

if(type == "CC" || type == "CR") % crank-crank or crank-rocker
    fourR(r1, r2, r3, r4, [0, 2*pi], num_points);
    fourRAnimate(r1, r2, r3, r4, -1);
elseif(type == "RC" || type == "RR")
    [limit1, limit2] = fourRfindLimits(r1, r2, r3, r4, num_points);
    fourR(r1, r2, r3, r4, limit1, num_points);
    fourRAnimate(r1, r2, r3, r4, -1);
end