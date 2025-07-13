function [] = fourRAnimate(r1, r2, r3, r4, rotation_style, filename)



theta2_arr = readmatrix("theta2.txt");
theta3_1_arr = readmatrix("theta3_1.txt");
theta3_2_arr = readmatrix("theta3_2.txt");

rotation_direction = 1; % 1 ==> a.c.w and -1 ==> c.w.
% rotation_style = -1; % 1 ==> to and fro motion & -1 ==> continuous rotation in one direction


num = length(theta2_arr) ;

A = [0, 0];
B = zeros(num, 2);
C1 = zeros(num, 2);
C2 = zeros(num, 2);
D = [r1, 0];
for i=1:num
    B(i, :) = [r2*cos(theta2_arr(i)), r2*sin(theta2_arr(i))];
    C1(i, :) = [r2*cos(theta2_arr(i))+r3*cos(theta3_1_arr(i)), r2*sin(theta2_arr(i)) + r3*sin(theta3_1_arr(i))] ;
    C2(i, :) = [r2*cos(theta2_arr(i))+r3*cos(theta3_2_arr(i)), r2*sin(theta2_arr(i)) + r3*sin(theta3_2_arr(i))] ;
end

xmin = min([A(1); B(:, 1); C1(:, 1); C2(:, 1); D(1)]) ;
ymin = min([A(2); B(:, 2); C1(:, 2); C2(:, 2); D(2)]) ;
xmax = max([A(1); B(:, 1); C1(:, 1); C2(:, 1); D(1)]) ;
ymax = max([A(2); B(:, 2); C1(:, 2); C2(:, 2); D(2)]) ;


i = 1;
figure('Units', 'normalized', 'Position', [0.3, 0.3, 0.4, 0.4]);
axis tight
axis equal
axis off
% set(gca, 'Position', [0.05 0.05 0.9 0.9]);  % Leave margin for title
set(gcf, 'Color', 'w');                    % White background
set(gca, 'LooseInset', [0 0 0 0]);         % Remove outer space
grid off
hold on;
xlim([-0.5+xmin, xmax+0.5]);
ylim([-2.5, ymax+0.5]);
link1 = plot([A(1), D(1)], [A(2), D(2)], '-bo', linewidth=2);
link2 = plot([A(1), B(1, 1)], [A(2), B(1, 2)], '-bo', linewidth=2);

% link3_1 = plot([B(1, 1), C1(1, 1)], [B(1, 2), C1(i, 2)], '-bo', linewidth=2);
% link4_1 = plot([C1(1, 1), D(1)], [C1(1, 2), D(2)] , '-bo', linewidth=2);

link3_2 = plot([B(1, 1), C2(1, 1)], [B(1, 2), C2(i, 2)], '-bo', linewidth=2);
link4_2 = plot([C2(1, 1), D(1)], [C2(1, 2), D(2)] , '-bo', linewidth=2);
title("4R Crank-Rocker Mechanism", interpreter="latex", FontSize=18)


grid on
pbaspect([1 1 1])
daspect([1 1 1])




rotation = 0;

while(rotation<0.5)
      
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

    % set(link3_1, 'XData', [B(i, 1), C1(i, 1)], 'YData', [B(i, 2), C1(i, 2)]);
    % set(link4_1, 'XData', [C1(i, 1), D(1)], 'YData', [C1(i, 2), D(2)]);

    set(link3_2, 'XData', [B(i, 1), C2(i, 1)], 'YData', [B(i, 2), C2(i, 2)]);
    set(link4_2, 'XData', [C2(i, 1), D(1)], 'YData', [C2(i, 2), D(2)]);
    drawnow ;
 
    % Capture the plot as a frame
frame = getframe(gcf);
im = frame2im(frame);
[imind, cm] = rgb2ind(im, 256);

% Write to the GIF File
if rotation == 0 && i == 1
    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.02);
else
    imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.02);
end
    
i = i + 1*rotation_direction;

end

% hold on;
% plot(B(:, 1), B(:, 2), '.b');
% 
% plot(C1(:, 1), C1(:, 2), '.g');
% plot((B(:, 1)+C1(:, 1))/2, (B(:, 2) + C1(:, 2))/2, '.m');
% 
% plot(C2(:, 1), C2(:, 2), '.g');
% plot((B(:, 1)+C2(:, 1))/2, (B(:, 2) + C2(:, 2))/2, '.m');
end