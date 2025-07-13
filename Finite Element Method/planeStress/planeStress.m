function [sol] = planeStress()

    clear;
    clc;
    addpath 'C:\Users\Himanshu\Documents\MATLAB\Bathe_FEM\planeStress\preprocessor'
    addpath 'C:\Users\Himanshu\Documents\MATLAB\Bathe_FEM\planeStress\processor'
    

    digits(30) ;
    input = inputFile();
    [K, Rbody, Rs] = assemble(input);
    Rc = input.CONC_FORCE ;

    R = Rbody + Rs + Rc;

    [Kaa, Kab, Kba, Kbb, Ra, Rb, Ua, Ub, U, Ux, Uy] = partitionAndSolve(K, R, input) ;


    

    sol = solutionData(K, Rbody, Rs, Rc, R, Kaa, Kab, Kba, Kbb, Ra, Rb,  Ua, Ub, U, Ux, Uy) ;


end