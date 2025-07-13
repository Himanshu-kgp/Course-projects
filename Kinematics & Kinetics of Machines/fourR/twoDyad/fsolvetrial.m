
fsolve(@fun);




function [F] = fun(x)
    F1 = x(1)*x(2);
    F2 = x(1) + x(2);
    F = [F1, F2] ;
end