function ydash =  eqns(t, y, Pr)


R = y(1);
S = y(2);
F = y(3);
G = y(4);
H = y(5);


Rdash = S;
Sdash = (3/4)*F*S;
Fdash = G;
Gdash = H;
Hdash = R - (1/Pr)*((G^2)/2 - (3/4)*F*H);

ydash = [Rdash, Sdash, Fdash, Gdash, Hdash]';


end