function[range_1, range_2] = fourRfindLimits(r1, r2, r3, r4, num_points)
 

syms theta3 theta4




theta2_arr = linspace(0, 2*pi, num_points) ;
theta3_arr = -1*ones(length(theta2_arr), 1);
theta4_arr = -1*ones(length(theta2_arr), 1);


range_1 = [-1, -1];
range_2 = [-1, -1];

iter = 1;

for i=1:length(theta2_arr)


l1 = twoDyad(r1, 0, 1);
l2 = twoDyad(r2, theta2_arr(i), 1);
l3 = twoDyad(r3, theta3, 1);
l4 = twoDyad(r4, theta4, 1);

disp1 = l1.disp();
disp2 = l2.disp();
disp3 = l3.disp();
disp4 = l4.disp();


eqn1 = disp1(1) + disp2(1) +  disp3(1) + disp4(1) == 0 ;
eqn2 = disp1(2) + disp2(2) +  disp3(2) + disp4(2) == 0;

eqn = [eqn1, eqn2];

if(i~=1)
    sol = vpasolve(eqn, [theta3, theta4], [theta3_arr(i-1), theta4_arr(i-1)]);
else
    sol = vpasolve(eqn, [theta3, theta4]);
end


if(~isempty(sol.theta3) && ~isempty(sol.theta4) && isreal(sol.theta3) && isreal(sol.theta4))    
    theta3_arr(i) = mod(double(sol.theta3), 2*pi);
    theta4_arr(i) = mod(double(sol.theta4), 2*pi);
    if(iter == 1)
        range_1(1) = theta2_arr(i);
        iter = iter+1;
    end

    if(iter == 3)
        range_2(1) = theta2_arr(i);
        iter = iter+1;
    end
else
    if(iter == 2)
        range_1(2) = theta2_arr(i-1);
        iter = iter+1;
    end

    if(iter == 4)
        range_2(2) = theta2_arr(i-1);
        iter = iter+1;
    end
end
disp(i);
disp(sol);

end

if(i==length(theta2_arr) && range_1(2) == -1)
    range_1(2) = 2*pi;
end

if(i==length(theta2_arr) && range_2(2) == -1 && range_2(1)~=-1)
    range_2(2) = 2*pi;
end



end