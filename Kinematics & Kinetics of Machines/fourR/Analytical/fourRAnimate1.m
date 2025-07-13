function [] = fourRAnimate1(r1, r2, r3, r4, rotation_style)




theta2_arr = readmatrix("theta2.txt");
theta3_1_arr = readmatrix("theta3_1.txt");

rotation_direction = 1; % 1 ==> a.c.w and -1 ==> c.w.
% rotation_style = -1; % 1 ==> to and fro motion & -1 ==> continuous rotation in one direction


num = length(theta2_arr) ;

A = [0, 0];
B = zeros(num, 2);
C = zeros(num, 2);
D = [r1, 0];
for i=1:num
    B(i, :) = [r2*cos(theta2_arr(i)), r2*sin(theta2_arr(i))];
    C(i, :) = [r2*cos(theta2_arr(i))+r3*cos(theta3_1_arr(i)), r2*sin(theta2_arr(i)) + r3*sin(theta3_1_arr(i))] ;
end

xmin = min([A(1); B(:, 1); C(:, 1); D(1)]) ;
ymin = min([A(2); B(:, 2); C(:, 2); D(2)]) ;
xmax = max([A(1); B(:, 1); C(:, 1); D(1)]) ;
ymax = max([A(2); B(:, 2); C(:, 2); D(2)]) ;


i = 1;
figure
hold on;
xlim([-0.5+xmin, xmax+0.5]);
ylim([-0.5+ymin, ymax+0.5]);
link1 = plot([A(1), D(1)], [A(2), D(2)], '-ro', linewidth=2);
link2 = plot([A(1), B(1, 1)], [A(2), B(1, 2)], '-bo', linewidth=2);
link3 = plot([B(1, 1), C(1, 1)], [B(1, 2), C(i, 2)], '-mo', linewidth=2);
link4 = plot([C(1, 1), D(1)], [C(1, 2), D(2)] , '-go', linewidth=2);


grid on
pbaspect([1 1 1])
daspect([1 1 1])




rotation = 0;

while(rotation<2)
      
    disp(i);
   
    if(i>num)
        rotation = rotation+0.5;
        if(rotation_style == 1)
            rotation_direction = -1;
            i=i-1;
        else
            i = mod(i, num);
        end
        continue;

    end

    if(i<=0)
        rotation = rotation+0.5;
        rotation_direction = 1;
        i=i+1;
        continue;
    end




    set(link2, 'XData', [A(1), B(i, 1)], 'YData', [A(2), B(i, 2)]);
    set(link3, 'XData', [B(i, 1), C(i, 1)], 'YData', [B(i, 2), C(i, 2)]);
    set(link4, 'XData', [C(i, 1), D(1)], 'YData', [C(i, 2), D(2)])
    drawnow ;
 
    i = i + 1*rotation_direction;

end

hold on;
plot(B(:, 1), B(:, 2), '.b');
plot(C(:, 1), C(:, 2), '.g');
plot((B(:, 1)+C(:, 1))/2, (B(:, 2) + C(:, 2))/2, '.m');
end