function [sol] = heatTransfer2D()

    clear;
    clc;
    addpath 'C:\Users\Himanshu\Documents\MATLAB\Bathe_FEM\heatTransfer2D\preprocessor'
    addpath 'C:\Users\Himanshu\Documents\MATLAB\Bathe_FEM\heatTransfer2D\processor'
    addpath 'C:\Users\Himanshu\Documents\MATLAB\Bathe_FEM\heatTransfer2D\postprocessor'
    

    digits(30) ;
    input = inputFile();
    [K, Rbody, Rs] = assemble(input);
    Rc = input.CONC_FORCE ;

    R = Rbody + Rs + Rc;

    [Kaa, Kab, Kba, Kbb, Ra, Rb, Ta, Tb, T] = partitionAndSolve(K, R, input) ;


    

    sol = solutionData(K, Rbody, Rs, Rc, R, Kaa, Kab, Kba, Kbb, Ra, Rb,  Ta, Tb, T) ;
    
   % TSurface(input, sol) ;

end