function [] = fourR(r1, r2, r3, r4, num_points)


theta2_arr = linspace(0, 2*pi, num_points) ;

theta3_1_arr = -1*zeros(length(theta2_arr), 1);
theta3_2_arr = -1*zeros(length(theta2_arr), 1);
theta4_1_arr = -1*zeros(length(theta2_arr), 1);
theta4_2_arr = -1*zeros(length(theta2_arr), 1);

theta2_1_possible_arr = -1*ones(length(theta2_arr), 1);
theta2_2_possible_arr = -1*ones(length(theta2_arr), 1);


for i=1:length(theta2_arr)


    A = 2*r1*r4 - 2*r2*r4*cos(theta2_arr(i));
    B = -2*r2*r4*sin(theta2_arr(i));
    C = r1^2 + r2^2 + r4^2 - r3^2 - 2*r1*r2*cos(theta2_arr(i));
    
    
    t_1 = (-B + sqrt(B^2 - C^2 + A^2))/(C-A) ;
    t_2 = (-B - sqrt(B^2 - C^2 + A^2))/(C-A) ;
    
    
    if(isreal(t_1))
        theta4_1 = atan(t_1)*2;

        Y_1 = (r4*sin(theta4_1) - r2*sin(theta2_arr(i)))/r3;
        X_1 = (r1 + r4*cos(theta4_1) - r2*cos(theta2_arr(i)))/r3 ;

        theta3_1 = atan2(Y_1, X_1);

        theta3_1_arr(i) = theta3_1;
        theta4_1_arr(i) = theta4_1;
        theta2_1_possible_arr(i) = theta2_arr(i);
    end

    if(isreal(t_2))
    
    theta4_2 = atan(t_2)*2;
    
    Y_2 = (r4*sin(theta4_2) - r2*sin(theta2_arr(i)))/r3 ;
    X_2 = (r1 + r4*cos(theta4_2) - r2*cos(theta2_arr(i)))/r3 ;
    
   
    theta3_2 = atan2(Y_2, X_2);
    
    theta3_2_arr(i) = theta3_2;
    theta4_2_arr(i) = theta4_2;

    theta2_2_possible_arr(i) = theta2_arr(i);

    end

end



writematrix(theta2_arr', "theta2.txt");
writematrix(theta2_1_possible_arr, "theta2_1_possible.txt");
writematrix(theta2_2_possible_arr, "theta2_2_possible.txt");
writematrix(theta3_1_arr, "theta3_1.txt");
writematrix(theta3_2_arr, "theta3_2.txt");
writematrix(theta4_1_arr, "theta4_1.txt");
writematrix(theta4_2_arr, "theta4_2.txt");

end







