


function [K, Rb, Rs] = elem(xelem, yelem, elemNumber, input)
    
   
    syms r s 
    
    cond = input.cond(elemNumber); 
    t = input.thickness ;
    Fb = input.BODY_FORCE;
    Fb = Fb(elemNumber, :)' ;
    SURFACE_FORCE = input.SURFACE_FORCE;
    SURFACE_FORCE_INFO = input.SURFACE_FORCE_INFO ;
    APPROXIMATION_ORDER = input.APPROXIMATION_ORDER ;
    C =  cond;

   
    
    h1 = (1+r)*(1+s)/4;
    h2 = (1-r)*(1+s)/4;
    h3 = (1-r)*(1-s)/4;
    h4 = (1+r)*(1-s)/4;

    h = [h1 h2 h3 h4];
    hr = diff(h, r);
    hs = diff(h, s);


    H = simplify([h1 h2 h3 h4]) ;

    Hr = simplify([hr(1) hr(2) hr(3) hr(4)]);
    Hs = simplify([hs(1) hs(2) hs(3) hs(4)]);
        
    x = sym(0) ;
    y = sym(0) ;
    for i = 1:4*APPROXIMATION_ORDER
        x = x + xelem(i)*h(i);
        y = y + yelem(i)*h(i);
    end

    x = simplify(x);
    y = simplify(y);

    dxdr = diff(x, r);
    dydr = diff(y, r);
    dxds = diff(x, s);
    dyds = diff(y, s);


    J = [dxdr dydr; dxds dyds] ;

    detJ = det(J) ;
    %invJ = inv(J) ; 

    %B = invJ*[Hr; Hs] ;
    B = J\[Hr; Hs] ;

    % [integPoints, weights] = lgwt(input.NUM_INTEG_POINTS, -1, 1) ;

    
    FK  = simplify(transpose(B)*C*B*detJ*t) ;
    FRb = simplify(transpose(H)*Fb*detJ*t) ;


  
    K = vpa(eval(int(int(FK, r, -1, 1, 'IgnoreAnalyticConstraints',true), s, -1, 1, 'IgnoreAnalyticConstraints',true))) ;
    Rb = vpa(eval(int(int(FRb, r, -1, 1, 'IgnoreAnalyticConstraints',true), s, -1, 1, 'IgnoreAnalyticConstraints',true))) ;

    
    % K = zeros(2*4*APPROXIMATION_ORDER, 2*4*APPROXIMATION_ORDER) ;
    % Rb = zeros(2*4*APPROXIMATION_ORDER, 1); 

    % for i = 1:size(K, 1)
    %     FRbi = matlabFunction(FRb(i), 'Vars', [r, s]) ;
    %     for iinteg =  1:length(integPoints)
    %         for jinteg = 1:length(integPoints)
    %             Rb(i) = Rb(i) + FRbi(integPoints(iinteg), integPoints(jinteg))*weights(iinteg)*weights(jinteg) ;
    %         end
    %     end
    % 
    % 
    %     for j = 1:size(K, 2)
    %         FKij = matlabFunction(FK(i, j), 'Vars', [r, s]) ;
    %         for iinteg =  1:length(integPoints)
    %             for jinteg = 1:length(integPoints)
    %                 K(i, j) = K(i, j) + FKij(integPoints(iinteg), integPoints(jinteg))*weights(iinteg)*weights(jinteg) ;
    %             end
    %         end
    %     end
    % end


    Rs = zeros(1*4*APPROXIMATION_ORDER, 1) ;

    for i = 1:size(SURFACE_FORCE_INFO, 1)
        
        for j = 1:2:size(SURFACE_FORCE_INFO, 2)
            if(SURFACE_FORCE_INFO(j) == elemNumber)
                edgeNumber = SURFACE_FORCE_INFO(j+1);
                Fs = SURFACE_FORCE(i, 1) ;
    

                switch edgeNumber
                    case 1
                        l = r ; % l is the local coordinate
                        Hs = subs(H, s, 1);
                    case 2
                        l = s;
                        Hs = subs(H, r, -1);
                    case 3
                        l = r;
                        Hs = subs(H, s, -1);
                    otherwise
                        l = s;
                        Hs = subs(H, r, 1);
                end

                FRs = transpose(Hs)*Fs*detJ*t ;

                Rs = Rs + vpa(eval(int(FRs, l, -1, 1)));

            end
        end
    end
end
