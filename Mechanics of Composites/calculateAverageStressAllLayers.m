function [averageStressAllLayers] = calculateAverageStressAllLayers(stressAllLayers, z_arr, z)

N = length(z_arr) - 1;
averageStressAllLayers = zeros(3, N);

for i=1:N
    averageStressAllLayers(1, i) = 1/(z_arr(i+1)-z_arr(i))*int(stressAllLayers(1, i), z, z_arr(i:i+1));
    averageStressAllLayers(2, i) = 1/(z_arr(i+1)-z_arr(i))*int(stressAllLayers(2, i), z, z_arr(i:i+1));
    averageStressAllLayers(3, i) = 1/(z_arr(i+1)-z_arr(i))*int(stressAllLayers(3, i), z, z_arr(i:i+1));
end

end