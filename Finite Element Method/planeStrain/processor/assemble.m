function [K, Rb, Rs] = assemble(input)
        
    NODES = input.NODES;
    X = input.X ;
    Y = input.Y ;
    NELEM = size(NODES, 1) ;
    LM = input.LM;
    TOTAL_DOF = input.TOTAL_DOF ;
    APPROXIMATION_ORDER = input.APPROXIMATION_ORDER ;

    K = zeros(TOTAL_DOF, TOTAL_DOF); 
    Rb = zeros(TOTAL_DOF, 1);
    Rs = zeros(TOTAL_DOF, 1);
    for k = 1:NELEM
        xelem = zeros(1, 4*APPROXIMATION_ORDER);
        yelem = zeros(1, 4*APPROXIMATION_ORDER);
        for i=1:length(xelem)
            xelem(i) = X(NODES(k, i));
            yelem(i) = Y(NODES(k, i));
        end
        [K_elem, Rb_elem, Rs_elem]= elem(xelem, yelem, k, input);


        for i=1:4*2*APPROXIMATION_ORDER
            igl = LM(k, i);

            if(igl<0)
                igl = -igl;
            end

            Rb(igl) = Rb(igl) + vpa(Rb_elem(i)) ;
            Rs(igl) = Rs(igl) + vpa(Rs_elem(i)) ;
            for j=1:4*2*APPROXIMATION_ORDER
                jgl = LM(k, j);
                if(jgl<0)
                    jgl = -jgl;
                end
                K(igl, jgl) = K(igl, jgl) + vpa(K_elem(i, j)) ;
            end
        end
    end
    
end