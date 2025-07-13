
function [input] = inputFile()


NNODE = 20;
NELEM = 12;
APPROXIMATION_ORDER = 1 ; % can be either 1 or 2 
ID = [-1 -1 -1 -1 zeros(1, 12), -1 -1 -1 -1]; % NUMBER_OF_DOF_PER_NODE X NNODE = 1 X NNODE
PRES_DISP = [1 1 1 1 5 5 5 5 ]; % 1 X (TOTAL_DOF-NNDOF) in the order of global DOF numbering
X = [0 0 0 0 2 2 2 2 4 4 4 4 6 6 6 6 8 8 8 8] ;
Y = [0 2 4 6 0 2 4 6 0 2 4 6 0 2 4 6 0 2 4 6] ;

NODES = [6 2 1 5;
         7 3 2 6;
         8 4 3 7;
         10 6 5 9;
         11 7 6 10;
         12 8 7 11;
         14 10 9 13;
         15 11 10 14;
         16 12 11 15;
         18 14 13 17;
         19 15 14 18;
         20 16 15 19];
BODY_FORCE = {@(X, Y) 0;
              @(X, Y) 0;
              @(X, Y) 0; 
              @(X, Y) 0;
              @(X, Y) 0;
              @(X, Y) 0;
              @(X, Y) 0; 
              @(X, Y) 0;
              @(X, Y) 0;
              @(X, Y) 0;
              @(X, Y) 0; 
              @(X, Y) 0;}; % NELEM X 1
SURFACE_FORCE = {@(t) -1}; 
SURFACE_FORCE_INFO = [-1 -1] ;%  element_number, edge_number, element_number, edge_number
CONC_FORCE = zeros(NNODE, 1) ; % TOTAL_DOF X 1 
cond = 1*ones(NELEM, 1); % NELEM X 1
thickness = 0.1;
NUM_INTEG_POINTS = 4;


input = inputData(NNODE, ID, X, Y, PRES_DISP, NODES, cond, thickness, BODY_FORCE, SURFACE_FORCE, SURFACE_FORCE_INFO, CONC_FORCE, APPROXIMATION_ORDER, NUM_INTEG_POINTS);

end