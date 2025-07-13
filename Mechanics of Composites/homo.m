function [Q_homo] = homo(vf, Ef1, n12, Em, num)


Ef2 = Ef1;  % (in Pa)
Gf = Ef1/(2*(1+n12));

% Eshelby Tensor for a Cylindrical Inclusion (Plane Stress)
S = eshelby_cyl(num);

% Compute Stiffness Matrices
C0 = matrixStiffness(Em, num);  % Matrix Stiffness
C1 = fibreStiffness(Ef1, Ef2, n12, n12, Gf); % Fiber Stiffness

% Mori-Tanaka Homogenization
H = inv(eye(6) + S * inv(C0) * (C1-C0)); % Avoid explicit inverse
B = H;
v0 = 1-vf;
A = B*inv(v0*eye(6) + (1-v0)*B);
% Compute Effective Stiffness Tensor
Q_homo = C0 + vf * (C1 - C0) * A;

Q_homo = [Q_homo(1, 1), Q_homo(1, 2), Q_homo(1, 6);
          Q_homo(2, 1), Q_homo(2, 2), Q_homo(2, 6);
          Q_homo(6, 1), Q_homo(6, 2), Q_homo(6, 6)/2];

end




function S_aa_cyl = eshelby_cyl(nu_m)
S_aa_cyl = zeros(6);
S_aa_cyl(6,6) =1/4;
S_aa_cyl(5,5) =1/4;
S_aa_cyl(2,2)= (5-4*nu_m)/(8*(1-nu_m));
S_aa_cyl(3,3)= (5-4*nu_m)/(8*(1-nu_m));
S_aa_cyl(2,3)= (-1 +4*nu_m)/(8*(1-nu_m));
S_aa_cyl(3,2)= (-1 +4*nu_m)/(8*(1-nu_m));
S_aa_cyl(2,1)= nu_m/ (2*(1-nu_m));
S_aa_cyl(3,1)= nu_m/ (2*(1-nu_m));
S_aa_cyl(4,4) = (3-4*nu_m)/(8*(1-nu_m));
end



function [Sinv] = matrixStiffness(Em, mum)

S=zeros(6);

S(1,1)=1/Em;
S(1,2)=-mum/Em;
S(1,3)=-mum/Em;
S(2,1)=-mum/Em;
S(2,2)=1/Em;
S(2,3)=-mum/Em;
S(3,1)=-mum/Em;
S(3,2)=-mum/Em;
S(3,3)=1/Em;
S(4,4)=2*(1+mum)/(Em);
S(5,5)=2*(1+mum)/(Em);
S(6,6)=2*(1+mum)/(Em);

Sinv = inv(S);
end

function [Sinv] = fibreStiffness(E1, E2, nu12, nu23, G12)

S=zeros(6);

S(1,1)=1/E1;
S(1,2)=-nu12/E1;
S(1,3)=-nu12/E1;
S(2,1)=-nu12/E1;
S(2,2)=1/E2;
S(2,3)=-nu23/E2;
S(3,1)=-nu12/E1;
S(3,2)=-nu23/E2;
S(3,3)=1/E2;
S(4,4)=2*(1+nu23)/E2;
S(5,5)=1/G12;
S(6,6)=1/G12;

Sinv = inv(S);
end

