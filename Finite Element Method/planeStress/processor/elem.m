


function [K, Rb, Rs] = elem(xelem, yelem, elemNumber, input)
    
   
    syms r s 
    
    E = input.E(elemNumber); 
    nu = input.nu(elemNumber);
    t = input.thickness ;
    Fb = input.BODY_FORCE;
    Fb = Fb(elemNumber, :)' ;
    SURFACE_FORCE = input.SURFACE_FORCE;
    SURFACE_FORCE_INFO = input.SURFACE_FORCE_INFO ;
    APPROXIMATION_ORDER = input.APPROXIMATION_ORDER ;
    C = E/(1-nu^2)*[1 nu 0; nu 1 0; 0 0 (1-nu)/2] ;

    

    h = zeros( 4*APPROXIMATION_ORDER, 1 ) ;
    
    if(APPROXIMATION_ORDER == 1)
        h1 = (1+r)*(1+s)/4;
        h2 = (1-r)*(1+s)/4;
        h3 = (1-r)*(1-s)/4;
        h4 = (1+r)*(1-s)/4;

        h = [h1 h2 h3 h4];
        hr = diff(h, r);
        hs = diff(h, s);


        H = simplify([h1 0 h2 0 h3 0 h4 0; 
             0 h1 0 h2 0 h3 0 h4]);
        Hu = simplify([hr(1) 0 hr(2) 0 hr(3) 0 hr(4) 0; 
              hs(1) 0 hs(2) 0 hs(3) 0 hs(4) 0]);
        Hv = simplify([0 hr(1) 0 hr(2) 0 hr(3) 0 hr(4);
              0 hs(1) 0 hs(2) 0 hs(3) 0 hs(4)]);
    elseif(APPROXIMATION_ORDER == 2)

        h1 = (r+s-1)*(r+1)*(s+1)/4;
        h2 = -(r^2-1)*(s+1)/2;
        h3 = (r-s+1)*(s+1)*(r-1)/4;
        h4 = (s^2-1)*(r-1)/2;
        h5 = -(r+s+1)*(s-1)*(r-1)/4;
        h6 = (r^2-1)*(s-1)/2;
        h7 = -(r+1)*(s-1)*(r-s-1)/4;
        h8 = -(s^2-1)*(r+1)/2;

        h = [h1 h2 h3 h4 h5 h6 h7 h8];
        hr = diff(h, r);
        hs = diff(h, s);

        H = sym(zeros(2, 16)) ;
        Hu = sym(zeros(2, 16)) ;
        Hv = sym(zeros(2, 16)) ;

        for j = 1:8
            H(1, 2*j-1) = h(j) ; 
            H(2, 2*j) = h(j) ;
            Hu(1, 2*j-1) = hr(j);
            Hu(2, 2*j-1) = hs(j);
            Hv(1, 2*j) = hr(j);
            Hv(2, 2*j) = hs(j);
        end


        H = simplify(H) ;
        Hu = simplify(Hu);
        Hv = simplify(Hv);
        % H = simplify([h1 0 h2 0  h3 0 h4 0 h5 0 h6 0 h7 0 h8 0;
        %      0 h1 0 h2 0  h3 0 h4 0 h5 0 h6 0 h7 0 h8]);
        % Hu = simplify([hr(1) 0 hr(2) 0 hr(3) 0 hr(4) 0 hr(5) 0 hr(6) 0 hr(7) 0 hr(8) 0; 
        %       hs(1) 0 hs(2) 0 hs(3) 0 hs(4) 0 hs(5) 0 hs(6) 0 hs(7) 0 hs(8) 0]);
        % Hv = simplify([0 hr(1) 0 hr(2) 0 hr(3) 0 hr(4) 0 hr(5) 0 hr(6) 0 hr(7) 0 hr(8);
        %       0 hs(1) 0 hs(2) 0 hs(3) 0 hs(4) 0 hs(5) 0 hs(6) 0 hs(7) 0 hs(8)]);

    end
    

    
    
    
   



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
    invJ = inv(J) ;
    
    B = sym(zeros(3, 2*4*APPROXIMATION_ORDER)) ;

    B(1, :) = invJ(1, :)*Hu;
    B(2, :) = invJ(2, :)*Hv;
    B(3, :) = invJ(2, :)*Hu + invJ(1, :)*Hv ;
    B = simplify(B) ;

    [integPoints, weights] = lgwt(input.NUM_INTEG_POINTS, -1, 1) ;

    
    FK  = simplify(transpose(B)*C*B*detJ*t) ;
    FRb = simplify(transpose(H)*Fb*detJ*t) ;


  
    % K = vpa(eval(int(int(FK, r, -1, 1, 'IgnoreAnalyticConstraints',true), s, -1, 1, 'IgnoreAnalyticConstraints',true))) ;
    % Rb = vpa(eval(int(int(FRb, r, -1, 1, 'IgnoreAnalyticConstraints',true), s, -1, 1, 'IgnoreAnalyticConstraints',true))) ;

    
    K = zeros(2*4*APPROXIMATION_ORDER, 2*4*APPROXIMATION_ORDER) ;
    Rb = zeros(2*4*APPROXIMATION_ORDER, 1); 

    for i = 1:size(K, 1)
        FRbi = matlabFunction(FRb(i), 'Vars', [r, s]) ;
        for iinteg =  1:length(integPoints)
            for jinteg = 1:length(integPoints)
                Rb(i) = Rb(i) + FRbi(integPoints(iinteg), integPoints(jinteg))*weights(iinteg)*weights(jinteg) ;
            end
        end


        for j = 1:size(K, 2)
            FKij = matlabFunction(FK(i, j), 'Vars', [r, s]) ;
            for iinteg =  1:length(integPoints)
                for jinteg = 1:length(integPoints)
                    K(i, j) = K(i, j) + FKij(integPoints(iinteg), integPoints(jinteg))*weights(iinteg)*weights(jinteg) ;
                end
            end
        end
    end


    Rs = zeros(2*4*APPROXIMATION_ORDER, 1) ;

    for i = 1:size(SURFACE_FORCE_INFO, 1)
        
        for j = 1:2:size(SURFACE_FORCE_INFO, 2)
            if(SURFACE_FORCE_INFO(j) == elemNumber)
                edgeNumber = SURFACE_FORCE_INFO(j+1);
                Fs = SURFACE_FORCE(i, 1:2)' ;
    

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
