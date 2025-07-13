function [x_arr, y_arr] = camProfile(r_b, y, dy)

% figure

n = 500;

i = 1;
x_arr = zeros(n, 1);
y_arr = zeros(n, 1);

for angle = linspace(0, 2*pi, n)
    R = r_b + subs(y, angle);
    t = subs(dy, angle);
    
    x_arr(i) = eval(R*cos(angle) - t*sin(angle)); % for clockwise cam rotation
    y_arr(i) = eval(R*sin(angle) + t*cos(angle));
    i = i+1;
end
end