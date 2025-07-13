function [type] = fourRtype(r1, r2, r3, r4)

    r = [r1, r2, r3, r4]; % sorts in ascending order

    r = sort(r);

    s = r(1);
    p = r(2);
    q = r(3);
    l = r(4); 

    if(s+l<p+q) % grashof
        if(r1 == s) % double crank
            type = "CC";
        elseif (r2 == s) % crank rocker
            type = "CR";
        elseif (r3 == s) % double rocker
            type = "RR";
        elseif (r4 == s) % rocker crank
            type = "RC";
        end
    else
        type = "RRNG"; % non grashofian double rocker
    end
end