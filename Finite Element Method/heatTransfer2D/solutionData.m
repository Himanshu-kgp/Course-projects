classdef solutionData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        K
        Rbody
        Rs
        Rc
        R
        Kaa
        Kab
        Kba
        Kbb
        Ra
        Rb
        Ta
        Tb
        T
    end

    methods
        function obj = solutionData(K, Rbody, Rs, Rc, R, Kaa, Kab, Kba, Kbb, Ra, Rb, Ta, Tb, T)
            obj.K = K;
            obj.Rbody = Rbody;
            obj.Rs = Rs;
            obj.Rc = Rc;
            obj.R = R;
            obj.Kaa = Kaa;
            obj.Kab = Kab;
            obj.Kba = Kba;
            obj.Kbb = Kbb ;
            obj.Ra = Ra;
            obj.Rb = Rb;
            obj.Ta = Ta;
            obj.Tb = Tb;
            obj.T = T;
        end
    end
end