function [RAllLayers] = calculateRAllLayers(averageStressAllLayers, theta_arr, Xc, Xt, Yt, Yc, S)

N=length(theta_arr);
RAllLayers = zeros(N, 1);

F1 = 1/Xt - 1/Xc;
F2 = 1/Yt - 1/Yc;
F11 = 1/(Xt*Xc);
F22 = 1/(Yt*Yc);
F66 = 1/S^2;


syms R
for i=1:N
    sigmax = averageStressAllLayers(1, i) ;
    sigmay = averageStressAllLayers(2, i) ;
    sigmaxy= averageStressAllLayers(3, i) ;

    transformedStress = transformStress([sigmax, sigmaxy; sigmaxy sigmay], -theta_arr(i));

    sigma1 = R*transformedStress(1, 1);
    sigma2 = R*transformedStress(2, 2);
    sigma6 = R*transformedStress(1, 2);

    eqn = F1*sigma1 + F2*sigma2 + F11*sigma1^2 + F22*sigma2^2 + F66*sigma6^2 == 1;

    soln = eval(solve(eqn, R));
    if(~isempty(soln))
        RAllLayers(i) = min(soln(soln>0));
    else
        RAllLayers(i) = inf;
    end
end

end



function [transformedStress] = transformStress(stress, theta)

Q = [cos(theta) sin(theta); -sin(theta) cos(theta)];
transformedStress = Q'*stress*Q;

end