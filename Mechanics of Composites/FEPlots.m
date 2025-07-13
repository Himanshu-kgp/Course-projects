clear; clc; close all
%%
data1 = [6, 0.514567;
      10, 0.53;
      16, 0.55;
      20, 0.5612;
      22, 0.56214285714];

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')

fig=figure;
plot(data1(:, 1), data1(:, 2), ".-", LineWidth=1.5, MarkerSize=25);
xlabel("Number of elements along $Y$ or $Z$", FontSize=22)
ylabel("$C_{11}^\mathrm{FE}/E_\mathrm{f}$", FontSize=22)
title("Mesh Convergence", FontSize=22)
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
xlim([5, 23])
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
% ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/meshConvergence.eps")
%%
data2 = [1, 0.514567;
      4, 0.5345;
      9, 0.556;
      16, 0.5612;
      25, 0.56214285714];

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')

fig=figure;
plot(data2(:, 1), data2(:, 2), ".-", LineWidth=1.5, MarkerSize=25);
xlabel("Number of fibers", FontSize=22)
ylabel("$C_{11}^\mathrm{FE}/E_\mathrm{f}$", FontSize=22)
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
xlim([0, 26])
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
% ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/RVEConvergence.eps")