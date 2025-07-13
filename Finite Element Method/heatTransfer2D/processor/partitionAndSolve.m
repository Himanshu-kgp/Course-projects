function [Kaa, Kab, Kba, Kbb, Ra, Rb, Ta, Tb, T] = partitionAndSolve(K, R, input)
    ID = input.ID;
    UNKNOWN_DOF_ID = ID(ID>0);
    KNOWN_DOF_ID = -ID(ID<0);

    TOTAL_DOF = input.TOTAL_DOF;
    UNKNOWN_NDOF = input.NNDOF; %a
    KNOWN_NDOF = TOTAL_DOF - UNKNOWN_NDOF ; %b


    Tb = (input.PRES_DISP)' ;


    Kaa = zeros(UNKNOWN_NDOF, UNKNOWN_NDOF);
    Kab = zeros(UNKNOWN_NDOF, KNOWN_NDOF );
    Kba = zeros(KNOWN_NDOF, UNKNOWN_NDOF);
    Kbb = zeros(KNOWN_NDOF, KNOWN_NDOF);

    Ra = zeros(UNKNOWN_NDOF, 1);
    Rb = zeros(KNOWN_NDOF, 1) ;

    for i = 1:length(UNKNOWN_DOF_ID)
        Ra(i) = R(UNKNOWN_DOF_ID(i)) ;
        for j = 1:length(UNKNOWN_DOF_ID)
            Kaa(i, j) = K(UNKNOWN_DOF_ID(i), UNKNOWN_DOF_ID(j));
        end
    end


    for i = 1:length(UNKNOWN_DOF_ID)
        for j = 1:length(KNOWN_DOF_ID)
            Kab(i, j) = K(UNKNOWN_DOF_ID(i), KNOWN_DOF_ID(j));
        end
    end



    for i = 1:length(KNOWN_DOF_ID)
        Rb(i) = R(KNOWN_DOF_ID(i)) ;
        for j = 1:length(UNKNOWN_DOF_ID)
            Kba(i, j) = K(KNOWN_DOF_ID(i), UNKNOWN_DOF_ID(j));
        end
    end



    for i = 1:length(KNOWN_DOF_ID)
        for j = 1:length(KNOWN_DOF_ID)
            Kbb(i, j) = K(KNOWN_DOF_ID(i), KNOWN_DOF_ID(j));
        end
    end


    Ta = linsolve(Kaa, Ra - Kab*Tb) ;
    
    
    T = zeros(input.TOTAL_DOF, 1) ;


    for i = 1:length(UNKNOWN_DOF_ID)
        T(UNKNOWN_DOF_ID(i)) = Ta(i) ;
    end

    for i = 1:length(KNOWN_DOF_ID)
        T(KNOWN_DOF_ID(i)) = Tb(i) ;
    end


    
end