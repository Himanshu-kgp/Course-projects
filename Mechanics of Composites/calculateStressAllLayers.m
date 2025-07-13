function [stressAllLayers] = calculateStressAllLayers(Q, theta_arr, z, eps0, curv)

N = length(theta_arr);
stressAllLayers = sym(zeros(3, N));
eps = eps0 + z*curv;

for k=1:N
    Qk = transformQ(Q, theta_arr(k));
    stressAllLayers(:, k) = Qk*eps;
end

end