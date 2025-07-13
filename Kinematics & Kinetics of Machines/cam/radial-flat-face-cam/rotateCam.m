function [] = rotateCam(r_b, t, y, dy)

[x0_arr, y0_arr] = camProfile(r_b, y, dy);

filename='cam.gif';

figure;
set(gcf, 'Color', 'w');      % Set figure background to white
set(gca, 'Color', 'w');      % Set axes background to white
cam_fill = fill(x0_arr, y0_arr, [0.678, 0.847, 0.902], 'EdgeColor', 'none'); % light blue
hold on;
cam = plot(x0_arr, y0_arr, 'k', LineWidth=1.5); % black edge
follower_v = plot([r_b + subs(y, 0), r_b + subs(y, 0)], [-t, t], 'r', LineWidth=1.5);
follower_h = plot([r_b + subs(y, 0), r_b + subs(y, 0)+10], [0 0], 'r', LineWidth=1.5);
contact_point = plot([x0_arr(1), x0_arr(1)], [y0_arr(1), y0_arr(1)], '.', ...
    'MarkerSize', 20, 'LineWidth', 1.5, 'Color', [0, 0, 1]);
reference_point = plot([x0_arr(1), x0_arr(1)], [y0_arr(1), y0_arr(1)], '.',  'Color', [0, 0, 1], markerSize=20, LineWidth=1.5);
title("Cam Mechanism" , Interpreter="latex", FontSize=18);

angle = linspace(0, 2*pi, 200);
% plot(r_b*cos(angle), r_b*sin(angle), 'b', LineWidth=1.5);
plot([0 0], [0 0], '+', 'Color', [0, 0, 1], MarkerSize=15, LineWidth=1.5);
% axis equal
axis off
xlim([-6 10])
ylim([-6 6])

i = 1;

for theta=linspace(0, 2*pi, length(x0_arr))

    Q = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    C = Q*[x0_arr'; y0_arr'];
    x_arr = C(1,:);
    y_arr = C(2,:);
    
    set(cam_fill, 'XData', x_arr, 'YData', y_arr);
    set(cam, 'XData', x_arr, 'YData', y_arr);
    set(follower_v, 'XData', [r_b + subs(y, theta), r_b + subs(y, theta)]);
    set(follower_h, 'XData', [r_b + subs(y, theta), r_b + subs(y, theta)+10]);
    set(contact_point, 'XData', [x_arr(i), x_arr(i)], 'YData', [y_arr(i), y_arr(i)]);
    set(reference_point, 'XData', [x_arr(1), x_arr(1)], 'YData', [y_arr(1), y_arr(1)]);
    i = i+1;
    drawnow;

        % Capture the plot as a frame
frame = getframe(gcf);
im = frame2im(frame);
[imind, cm] = rgb2ind(im, 256);

% Write to the GIF File
if theta == 0
    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.02);
else
    imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.02);
end
    

end


end