clear; clc; close all;

%% Input
T = 5777;
lambda0 = 0.01;
lambda1 = 0.4;
lambda2 = 0.7;
lambdaInf = 100;

%% Calculations from the table
lambda0T = lambda0*T;
lambda1T = lambda1*T;
lambda2T = lambda2*T;
lambdaInfT = lambdaInf*T;

f0_table = 0;
f1_table = interp1([2300, 2400], [0.12002, 0.14025], lambda1T);
f2_table = interp1([4000, 4100], [0.48085, 0.49872], lambda2T);
fInf_table = 1;




f_subVisible_table = (f1_table - f0_table);
f_visible_table = (f2_table - f1_table);
f_infrared_table = (fInf_table - f2_table);

%% Calculations from the series expansion
m_last = 5;

f_subVisible = f_contained(lambda0, lambda1, T, m_last);
f_visible       = f_contained(lambda1, lambda2, T, m_last);
f_infrared    = f_contained(lambda2, lambdaInf, T, m_last);


%% 
error_subVisible = (f_subVisible -f_subVisible_table)/f_subVisible_table;
error_visible = (f_visible - f_visible_table)/f_visible_table;
error_infrared = (f_infrared -f_infrared_table)/f_infrared_table;

%%
out  = table;
out.wavelength_range = ["sub-visible", "visible", "infrared"].'; 
out.f_seriesExpansion = 100*[f_subVisible, f_visible, f_infrared].'; % in percentage
out.f_table = 100*[f_subVisible_table, f_visible_table, f_infrared_table].'; % in percentage
out.error = 100*[error_subVisible, error_visible, error_infrared]'; % in percentage
writetable(out, 'hw1.csv')
%% Function to calculate energy contained in a range of wavelength
function [out] = f_contained(lambda1, lambda2, T, m_last) % give lambda in micrometer as input
    out = (fraction_of_BBR(lambda2, T, m_last) - fraction_of_BBR(lambda1, T, m_last)); % output is in W/m^2
end

%% Function to calculate the fraction of black body radiation using the series expansion
function [out] = fraction_of_BBR(lambda, T, m_last)

    C2 = 14388; % in micrometer K
    sum = 0;
    phi = C2/(lambda*T);
    
     for m=1:m_last
         mphi = m*phi ;
         sum = sum + exp(-mphi)/(m^4)*(6 + 6*mphi + 3*mphi^2 + mphi^3);
     end
    
     out = 15/pi^4*sum;

end