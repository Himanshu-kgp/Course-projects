function [Nx_calc, Ny_calc, Nxy_calc, Mx_calc, My_calc, Mxy_calc] = checkStressResultants(stressAllLayers, z_arr, z)
    
NumLayers = length(z_arr) - 1;

Nx_calc = 0;
Ny_calc = 0;
Nxy_calc = 0;
Mx_calc = 0;
My_calc = 0;
Mxy_calc = 0;
for i=1:NumLayers
    Nx_calc =  Nx_calc + int(stressAllLayers(1, i), z, [z_arr(i), z_arr(i+1)]);
    Ny_calc =  Ny_calc + int(stressAllLayers(2, i), z, [z_arr(i), z_arr(i+1)]);
    Nxy_calc = Nxy_calc + int(stressAllLayers(3, i), z, [z_arr(i), z_arr(i+1)]);
    Mx_calc =  Mx_calc + int(z*stressAllLayers(1, i), z, [z_arr(i), z_arr(i+1)]);
    My_calc =  My_calc + int(z*stressAllLayers(2, i), z, [z_arr(i), z_arr(i+1)]);
    Mxy_calc = Mxy_calc + int(z*stressAllLayers(3, i), z, [z_arr(i), z_arr(i+1)]);
end

Nx_calc = eval(Nx_calc);
Ny_calc = eval(Ny_calc);
Nxy_calc = eval(Nxy_calc);
Mx_calc = eval(Mx_calc);
My_calc = eval(My_calc);
Mxy_calc = eval(Mxy_calc);

end