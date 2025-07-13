function[v_f, E_f, nu_f, E_m, nu_m, theta_arr, z_arr, Nx, Ny, Nxy, Mx, My, Mxy, Xt, Xc, Yt, Yc, S]= readInputFile(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    
    function val = readLine()
        line = fgetl(fid);
        val = str2num(line); %#ok<ST2NM>
        if isempty(val)
            error('Invalid data line: "%s"', line);
        end
    end
    
    try
        % Process each section
        fgetl(fid); % Skip header
        data = readLine();
        [E_f, nu_f, v_f] = deal(data(1), data(2), data(3));
        
        fgetl(fid);
        data = readLine();
        [E_m, nu_m] = deal(data(1), data(2));
        
        fgetl(fid);
        theta_arr = readLine(); % Dynamically sized array
        
        fgetl(fid);
        z_arr = readLine(); % Dynamically sized array

        fgetl(fid);
        data = readLine();
        [Nx, Ny, Nxy] = deal(data(1), data(2), data(3));
        
        fgetl(fid);
        data = readLine();
        [Mx, My, Mxy] = deal(data(1), data(2), data(3));
        
        fgetl(fid);
        data = readLine();
        [Xt, Xc, Yt, Yc, S] = deal(data(1), data(2), data(3), data(4), data(5));
        
    catch ME
        fclose(fid);
        rethrow(ME);
    end
    fclose(fid);
    

end
