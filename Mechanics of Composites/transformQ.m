%%%%%%% Function to transform Q %%%%%%%%%%%%
function Qtransformed = transformQ(Q, theta)
    thetaRad = theta*pi/180;
    m = cos(thetaRad);
    n = sin(thetaRad);

    Qtransformed = zeros(3, 3);

    Q11 = Q(1, 1);
    Q12 = Q(1, 2);
    Q22 = Q(2, 2);
    Q66 = Q(3, 3);
    
    Qtransformed(1, 1) = m^4*Q11 + 2*m^2*n^2*(Q12+2*Q66) + n^4*Q22;
    Qtransformed(1, 2) = m^2*n^2*(Q11 + Q22 - 4*Q66) + Q12*(m^4 + n^4);
    Qtransformed(2, 2) = n^4*Q11 + 2*m^2*n^2*(Q12+2*Q66) + m^4*Q22;
    Qtransformed(1, 3) = m^3*n*(Q11-Q12) + m*n^3*(Q12-Q22) - 2*m*n*(m^2 - n^2)*Q66;
    Qtransformed(2, 3) = m*n^3*(Q11-Q12) + m^3*n*(Q12-Q22) + 2*m*n*(m^2 - n^2)*Q66;
    Qtransformed(3, 3) = m^2*n^2*(Q11+Q22-2*Q12) + (m^2 - n^2)^2*Q66;
    Qtransformed(2, 1) = Qtransformed(1, 2);
    Qtransformed(3, 1) = Qtransformed(1, 3);
    Qtransformed(3, 2) = Qtransformed(2, 3);
end