function [] = fourR(r1, r2, r3, r4, theta2_range, num_points)


% works for double crank and crank-rocker and rocker-crank mechanisms 4R c

l = max([r1, r2, r3, r4]);
s = min([r1, r2, r3, r4]);


syms theta3 theta4




theta2_arr = linspace(theta2_range(1), theta2_range(2), num_points) ;

theta2_possible_arr = -1*ones(length(theta2_arr), 1);
theta3_arr = -1*ones(length(theta2_arr), 1);
theta4_arr = -1*ones(length(theta2_arr), 1);



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
    theta2_possible_arr(i) = theta2_arr(i);
end
disp(i);
disp(sol);

end


writematrix(theta2_possible_arr, "theta2.txt");
writematrix(theta3_arr, "theta3.txt");
writematrix(theta4_arr, "theta4.txt");


end

