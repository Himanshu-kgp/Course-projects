classdef twoDyad
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        r
        theta
        sw % switch --- 1 for revolute joint and 0 for prismatic joint
    end

    methods
        function obj = twoDyad(r, theta, sw)
           obj.r = r;
           obj.theta = theta;
           obj.sw = sw;
        end

        function [z] = disp(obj)
            x = obj.r*cos(obj.theta);
            y = obj.r*sin(obj.theta);
            z = [x, y];
            % z = x+1i*y;
        end
    end
end