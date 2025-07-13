clear; clc; close all;

Num_files = 20;
for i=1:Num_files
    filename = strcat("./outputFiles/output_", num2str(i), ".mat");
    output(i) = load(filename);
end


%% plot 3

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q11_FE = Q_FE(1, 1:3:end);
Q_homo = [output(1:5).Q_homo];
Q11_homo = Q_homo(1, 1:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q11_ROM = Q_ROM(1, 1:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, Q11_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, Q11_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, Q11_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("$C_{11}$ (Pa)", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q11_vs_vf.eps")


%%

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q11_FE = Q_FE(1, 1:3:end);
Q_homo = [output(1:5).Q_homo];
Q11_homo = Q_homo(1, 1:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q11_ROM = Q_ROM(1, 1:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on
plot(vf, (Q11_FE-Q11_homo)./Q11_FE*100, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, (Q11_FE-Q11_ROM)./Q11_FE*100, '*-', LineWidth=1.5, MarkerSize=10);
legend("\% error in Homogenization", "\% error Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Percentage error in $C_{11}$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q11_vs_vf_error.eps")

%% plot 4

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q22_FE = Q_FE(2, 2:3:end);
Q_homo = [output(1:5).Q_homo];
Q22_homo = Q_homo(2, 2:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q22_ROM = Q_ROM(2, 2:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, Q22_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, Q22_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, Q22_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("$C_{22}$ (Pa)", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q22_vs_vf.eps")

%%

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q22_FE = Q_FE(2, 2:3:end);
Q_homo = [output(1:5).Q_homo];
Q22_homo = Q_homo(2, 2:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q22_ROM = Q_ROM(2, 2:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, (Q22_FE-Q22_homo)./Q22_FE*100, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, (Q22_FE-Q22_ROM)./Q22_FE*100, '*-', LineWidth=1.5, MarkerSize=10);
legend("\% error in Homogenization", "\% error Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Percentage error in $C_{22}$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q22_vs_vf_error.eps")

%% plot 5

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q33_FE = Q_FE(3, 3:3:end);
Q_homo = [output(1:5).Q_homo];
Q33_homo = Q_homo(3, 3:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q33_ROM = Q_ROM(3, 3:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, Q33_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, Q33_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, Q33_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("$C_{66}$ (Pa)", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q66_vs_vf.eps")

%%

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q33_FE = Q_FE(3, 3:3:end);
Q_homo = [output(1:5).Q_homo];
Q33_homo = Q_homo(3, 3:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q33_ROM = Q_ROM(3, 3:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, (Q33_FE-Q33_homo)./Q33_FE*100, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, (Q33_FE-Q33_ROM)./Q33_FE*100, '*-', LineWidth=1.5, MarkerSize=10);
legend("\% error in Homogenization", "\% error Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Percentage error in $C_{66}$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q66_vs_vf_error.eps")
%% plot 6

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q12_FE = Q_FE(1, 2:3:end);
Q_homo = [output(1:5).Q_homo];
Q12_homo = Q_homo(1, 2:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q12_ROM = Q_ROM(1, 2:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, Q12_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, Q12_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, Q12_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("$C_{16}$ (Pa)", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q16_vs_vf.eps")

%%
set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
Q_FE = [output(1:5).Q_FE];
Q12_FE = Q_FE(1, 2:3:end);
Q_homo = [output(1:5).Q_homo];
Q12_homo = Q_homo(1, 2:3:end);
Q_ROM = [output(1:5).Q_ROM];
Q12_ROM = Q_ROM(1, 2:3:end);
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, (Q12_FE-Q12_homo)./Q12_FE*100, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, (Q12_FE-Q12_ROM)./Q12_FE*100, '*-', LineWidth=1.5, MarkerSize=10);
legend("\% error in Homogenization", "\% error Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Percentage error in $C_{16}$", fontsize=22);
xlim([0.095, 0.51])
ylim([-1, 80])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/Q16_vs_vf_error.eps")
%% plot 1

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
R_FE = [output(1:5).R_FE];
R_homo = [output(1:5).R_homo];
R_ROM = [output(1:5).R_ROM];
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, R_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, R_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, R_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Margin of safety, $R$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/R_vs_vf_symmetricLaminate_loading1.eps")

%% plot 2

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
R_FE = [output(6:10).R_FE];
R_homo = [output(6:10).R_homo];
R_ROM = [output(6:10).R_ROM];
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, R_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, R_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, R_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Margin of safety, $R$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/R_vs_vf_nonsymmetricLaminate_loading2.eps");

%% plot 7

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
R_FE = [output(11:15).R_FE];
R_homo = [output(11:15).R_homo];
R_ROM = [output(11:15).R_ROM];
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, R_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, R_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, R_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Margin of safety, $R$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/R_vs_vf_symmetricLaminate_loading2.eps")

%% plot 8

set(0,'defaulttextInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex');
matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
close all
R_FE = [output(16:20).R_FE];
R_homo = [output(16:20).R_homo];
R_ROM = [output(16:20).R_ROM];
vf = 0.1:0.1:0.5;

fig=figure; hold on;
plot(vf, R_FE, '.-', LineWidth=1.5, MarkerSize=20);
plot(vf, R_homo, '+-', LineWidth=1.5, MarkerSize=15);
plot(vf, R_ROM, '*-', LineWidth=1.5, MarkerSize=10);
legend("FEA", "Homogenization", "Rule of mixtures","Location","northwest" , fontsize=16);
xlabel("Fibre volume fraction, $v_f$", fontsize=22);
ylabel("Margin of safety, $R$", fontsize=22);
xlim([0.095, 0.51])
box on
fig.Units               = 'inches';
fig.Position(3)         = 12;
fig.Position(4)         = 8;
ax=gca;
ax.Layer="top";
ax.XMinorTick="off";
ax.YMinorTick="On";
ax.XAxis.FontSize = 22;
ax.YAxis.FontSize = 22;
ax.TickLabelInterpreter = "latex";
ax.XTick = 0.1:0.1:0.5;
ax.TickLength = [0.02, 0.01];
exportgraphics(gcf, "./plots/R_vs_vf_nonsymmetricLaminate_loading2.eps");
