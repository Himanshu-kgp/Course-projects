function [] = main(inputFilename, outputFilename)
%% get inputs
[v_f, E_f, nu_f, E_m, nu_m, ...
theta_arr, z_arr, Nx, Ny, Nxy, ...
Mx, My, Mxy, Xt, Xc, Yt, Yc, S]= readInputFile(inputFilename);

%% Run comsol file for FE
Q_FE = FE(v_f, E_f, nu_f, E_m, nu_m);

%% Run ROM script
Q_ROM = rom(v_f, E_f, nu_f, E_m, nu_m);

%% Run Homogenization script
Q_homo = homo(v_f, E_f, nu_f, E_m, nu_m);

%% laminate effective properties from FE
Q_FE_lam = calculateLaminateStiffness(Q_FE, theta_arr, z_arr);

%% laminate effective properties from ROM
Q_ROM_lam = calculateLaminateStiffness(Q_ROM, theta_arr, z_arr);

%% laminate effective properties from homogenization
Q_homo_lam = calculateLaminateStiffness(Q_homo, theta_arr, z_arr);

%% stress from FE
syms z
[eps0_FE, curv_FE]= calculateStrains(Q_FE_lam, Nx, Ny, Nxy, Mx, My, Mxy);
stressAllLayers_FE = calculateStressAllLayers(Q_FE, theta_arr, z, eps0_FE, curv_FE);
[Nx_calc_FE, Ny_calc_FE, Nxy_calc_FE, Mx_calc_FE, My_calc_FE, Mxy_calc_FE] = calculateStressResultants(stressAllLayers_FE, z_arr, z);

%% stress from ROM
[eps0_ROM, curv_ROM]= calculateStrains(Q_ROM_lam, Nx, Ny, Nxy, Mx, My, Mxy);
stressAllLayers_ROM = calculateStressAllLayers(Q_ROM, theta_arr, z, eps0_ROM, curv_ROM);
[Nx_calc_ROM, Ny_calc_ROM, Nxy_calc_ROM, Mx_calc_ROM, My_calc_ROM, Mxy_calc_ROM] = calculateStressResultants(stressAllLayers_ROM, z_arr, z);

%% stress from homogenization
[eps0_homo, curv_homo]= calculateStrains(Q_homo_lam, Nx, Ny, Nxy, Mx, My, Mxy);
stressAllLayers_homo = calculateStressAllLayers(Q_homo, theta_arr, z, eps0_homo, curv_homo);
[Nx_calc_homo, Ny_calc_homo, Nxy_calc_homo, Mx_calc_homo, My_calc_homo, Mxy_calc_homo] = calculateStressResultants(stressAllLayers_homo, z_arr, z);

%% R from FE
averageStressAllLayers_FE = calculateAverageStressAllLayers(stressAllLayers_FE, z_arr, z);
RAllLayers_FE = calculateRAllLayers(averageStressAllLayers_FE, theta_arr, Xc, Xt, Yt, Yc, S);
R_FE = min(RAllLayers_FE);

%% R from Rom
averageStressAllLayers_ROM = calculateAverageStressAllLayers(stressAllLayers_ROM, z_arr, z);
RAllLayers_ROM = calculateRAllLayers(averageStressAllLayers_ROM, theta_arr, Xc, Xt, Yt, Yc, S);
R_ROM = min(RAllLayers_ROM);

%% R from homogenization
averageStressAllLayers_homo = calculateAverageStressAllLayers(stressAllLayers_homo, z_arr, z);
RAllLayers_homo = calculateRAllLayers(averageStressAllLayers_homo, theta_arr, Xc, Xt, Yt, Yc, S);
R_homo = min(RAllLayers_homo);

save(outputFilename);
end