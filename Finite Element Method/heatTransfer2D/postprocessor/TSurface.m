function [] = TSurface(input, sol)

 
    NODES = input.NODES;
    X = input.X ;
    Y = input.Y ;
    NELEM = size(NODES, 1) ;
    LM = input.LM;
    TOTAL_DOF = input.TOTAL_DOF ;
    APPROXIMATION_ORDER = input.APPROXIMATION_ORDER ;

    syms r s 

    h1 = (1+r)*(1+s)/4;
    h2 = (1-r)*(1+s)/4;
    h3 = (1-r)*(1-s)/4;
    h4 = (1+r)*(1-s)/4;

    h = [h1 h2 h3 h4];


    T_discrete = sol.T ;

    for k = 1:NELEM
        
        xelem = zeros(1, 4*APPROXIMATION_ORDER);
        yelem = zeros(1, 4*APPROXIMATION_ORDER);

        for i=1:length(xelem)
            xelem(i) = X(NODES(k, i));
            yelem(i) = Y(NODES(k, i));
        end


        T = h1*T_discrete(input.NODES(k, 1)) + ...
            h2*T_discrete(input.NODES(k, 2)) + ...
            h3*T_discrete(input.NODES(k, 3)) + ...
            h4*T_discrete(input.NODES(k, 4));

        T = simplify(T);

        r_arr = linspace(-1, 1, 51);
        s_arr = linspace(-1, 1, 51);
        
        x = zeros(size(r_arr));
        y = zeros(size(s_arr));

        for i = 1:4*APPROXIMATION_ORDER
            hi = h(i);
            x = x + xelem(i)*subs(hi, {r, s}, {r_arr, s_arr});
            y = y + yelem(i)*subs(hi, {r, s}, {r_arr, s_arr});
        end

        [Xplot, Yplot] = meshgrid(x, y);
        Xplot = double(Xplot);
        Yplot = double(Yplot);

        T_elem_discrete = zeros(size(Xplot));

        for i = 1:size(Xplot, 1)
            for j = size(Xplot, 2)
                T_elem_discrete(i, j) = subs(T, {r, s}, {r_arr(j), s_arr(i)});
            end
        end
   
        hold on;
        contour(Xplot, Yplot, T_elem_discrete, 'Fill', 'on', "ShowText",true,"LabelFormat","%0.2f");
    end

end