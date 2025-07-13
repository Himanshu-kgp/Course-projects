function [Q_rom] = rom(vf, Ef1, nu12, Em, nu)


Ef2 = Ef1; Ef = Ef1; 
Gf = Ef/(2*(1+nu12));
Gm = Em/(2*(1+nu));

[E1, E2, G, v12] = eff_prop_comp(vf, Ef1, Ef2, Gf, nu12, Em, Em, Gm, nu);
Q_rom = stiff_mat(E1, E2, G, v12);

end



% Function to compute stiffness matrix
function [C] = stiff_mat(E1, E2, G, v12)
    % Compliance matrix
    S = [1./E1, -v12./E1, 0; 
         -v12./E1, 1./E2, 0; 
          0, 0, 1./G];

    % Computing stiffness matrix
    C = inv(S); 
end
 


% Function to compute effective properties
function [Ec1, Ec2, Gc, V12] = eff_prop_comp(vf, Ef1, Ef2, Gf, nu12, Em1, Em2, Gm, nu)
    
    % Longitudinal modulus (Rule of Mixtures)
    Ec1 = vf .* Ef1 + (1 - vf) .* Em1;

    % Transverse modulus (Inverse Rule of Mixtures)
    Ec2 = 1 ./ (vf ./ Ef2 + (1 - vf) ./ Em2);

    % Shear modulus (Inverse Rule of Mixtures)
    Gc = 1 ./ (vf ./ Gf + (1 - vf) ./ Gm);

    % Poisson’s ratio (Rule of Mixtures)
    V12 = vf .* nu12 + (1 - vf) .* nu;
end
