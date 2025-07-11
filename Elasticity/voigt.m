function [C_voigt] = voigt(C)
C_voigt = sym(zeros(6, 6));
voigt_ind = [11, 22, 33, 23, 13, 12];

for i = 1:3
    for j=1:3
        for k=1:3
            for l=1:3
                P = 10*i+j;
                Q = 10*k+l;

                p = voigt_ind == P;
                q = voigt_ind == Q;

                C_voigt(p, q) = C(i, j, k, l);
            end
        end
    end
end
end