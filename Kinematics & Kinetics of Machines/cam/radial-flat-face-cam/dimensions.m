%  Function to get the base radius for the required cam profile
function [r_b, t] = dimensions(y, theta)

dy = diff(y, theta);
ddy = diff(dy, theta);


g = - y - ddy;

r_b = -1;
t  = -1;

for theta=linspace(0, 2*pi, 100)
    
    % ys = subs(y, theta);
    dys = subs(dy, theta);
    % ddys = subs(ddy, theta);

    gs = subs(g, theta);


    if(abs(dys)>t)
        t = abs(dys);
    end

    if(gs>r_b)
        r_b = gs;
    end
end





end
