classdef inputData
   

    properties
        NNODE
        ID
        X
        Y
        NODES
        PRES_DISP
        NNDOF
        TOTAL_DOF
        LM
        cond
        thickness
        BODY_FORCE
        SURFACE_FORCE
        SURFACE_FORCE_INFO
        CONC_FORCE
        APPROXIMATION_ORDER
        NUM_INTEG_POINTS
    end

    methods
        function obj = inputData(NNODE, ID, X, Y, PRES_DISP, NODES, cond, thickness, BODY_FORCE, SURFACE_FORCE, SURFACE_FORCE_INFO, CONC_FORCE, APPROXIMATION_ORDER, NUM_INTEG_POINTS)
            obj.NNODE = NNODE;
            ID = createID(ID);
            obj.TOTAL_DOF = nnz(ID) ; % total DOF including the ones with prescribed displacements
            obj.NNDOF = length(find(ID>0)) ;
            obj.ID = ID;
            obj.PRES_DISP = PRES_DISP;
            obj.X = X;
            obj.Y = Y;
            obj.NODES = NODES;
            LM = createLM(ID, NODES, APPROXIMATION_ORDER);
            obj.LM = LM ;
            obj.cond = cond;
            obj.thickness = thickness;
            obj.BODY_FORCE = BODY_FORCE;
            obj.SURFACE_FORCE = SURFACE_FORCE;
            obj.SURFACE_FORCE_INFO = SURFACE_FORCE_INFO ;
            obj.CONC_FORCE = CONC_FORCE ;
            obj.APPROXIMATION_ORDER = APPROXIMATION_ORDER;
            obj.NUM_INTEG_POINTS = NUM_INTEG_POINTS;

            function [ID] = createID(ID)
                row = size(ID, 1);
                col = size(ID, 2);
            
                count = 1;
                for j = 1:col
                    for i = 1:row
                        if(ID(i, j) == -1)
                            ID(i, j) = -1*count;
                            count = count + 1;
                        else
                            ID(i, j) = count;
                            count = count + 1;
                        end
                    end
                end
            end
            
            
            
            function [LM] = createLM(ID, NODES, APPROXIMATION_ORDER)
                row = size(NODES, 1) ;
                LM = zeros(row, 1*4*APPROXIMATION_ORDER);
            
             
                for i=1:row
                    for j=1:4*APPROXIMATION_ORDER
                        
                        LM(i, j) = ID(1, NODES(i, j));
                        
                    end
                end
            end

        end
    end
end