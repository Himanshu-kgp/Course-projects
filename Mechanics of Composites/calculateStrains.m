function [eps_0, curv] = calculateStrains(Q_lam, Nx, Ny, Nxy, Mx, My, Mxy)

    forcing_vector = [Nx Ny Nxy Mx My Mxy]';
    [response_vector] = Q_lam\forcing_vector;
    
    eps_0 = response_vector(1:3);
    curv = response_vector(4:6);

end