
function [input] = inputFile()


NNODE = 21;
NELEM = 4;
APPROXIMATION_ORDER = 2 ; % can be either 1 or 2 
ID = [-1 -1 -1 -1 -1 zeros(1, 16) ; 
      -1 -1 -1 -1 -1 zeros(1, 16)]; % NUMBER_OF_DOF_PER_NODE X NNODE = 2 X NNODE
PRES_DISP = [0 0 0 0 0 0 0 0 0 0]; % 1 X (TOTAL_DOF-NNDOF) in the order of global DOF numbering
X = [0 0 0 0 0 1 1 1 2 2 2 2 2 3 3 3 4 4 4 4 4] ;
Y = [0 1 2 3 4 0 2 4 0 1 2 3 4 0 2 4 0 1 2 3 4] ;
NODES = [11 7 3 2 1 6 9 10;
         13 8 5 4 3 7 11 12;
         19 15 11 10 9 14 17 18;
         21 16 13 12 11 15 19 20] ; % NELEM X NODES_PER_ELEM
BODY_FORCE = {@(X, Y) 1 , @(X, Y) 1;
              @(X, Y) 1 , @(X, Y) 1;
              @(X, Y) 1 , @(X, Y) 1;
              @(X, Y) 1 , @(X, Y) 1;}; % NELEM X 2
SURFACE_FORCE = {@(t) 0, @(t) 0}; 
SURFACE_FORCE_INFO = [-1 -1] ;%  element_number, edge_number, element_number, edge_number
CONC_FORCE = zeros(2*NNODE, 1) ; % TOTAL_DOF X 1 
E = 1*ones(NELEM, 1); % NELEM X 1
nu = 0.33*ones(NELEM, 1) ; % NELEM X 1
thickness = 0.1;
NUM_INTEG_POINTS = 4;


input = inputData(NNODE, ID, X, Y, PRES_DISP, NODES, E, nu, thickness, BODY_FORCE, SURFACE_FORCE, SURFACE_FORCE_INFO, CONC_FORCE, APPROXIMATION_ORDER, NUM_INTEG_POINTS);

end