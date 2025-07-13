function [Q_eff] = calculateLaminateStiffness(Q0, theta_arr, z_arr)
N = length(theta_arr); % N = number of layers
if(length(z_arr)~=N+1)
    disp("wrong input")
    return
end

Q3D_arr = zeros(3, 3, N);

for k=1:N
    Q3D_arr(:, :, k) = transformQ(Q0, theta_arr(k)); % Q0 is the 3x3 stiffness matrix at 0 deg
end

[A, B, D] = ABD(Q3D_arr, z_arr);

Q_eff = [A B; B D]; % effective laminate stiffness -- 6x6 matrix

end


%%%%%%%%%% Function to find A, B, and D for any lay-up sequence %%%%%%
function [A, B, D] = ABD(Q3D_arr, z_arr)

A = zeros(3, 3);
B = zeros(3, 3);
D = zeros(3, 3);

N = length(z_arr)-1;

for k=1:N
    A = A + Q3D_arr(:, :, k)*(z_arr(k+1) - z_arr(k));
    B = B + 1/2*Q3D_arr(:, :, k)*(z_arr(k+1)^2 - z_arr(k)^2);
    D = D + 1/3*Q3D_arr(:, :, k)*(z_arr(k+1)^3 - z_arr(k)^3);
end

end

