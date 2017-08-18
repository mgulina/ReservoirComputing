%% NE FONCTIONNE PAS

clear; close all; clc;
h = 1;
T_tot = 500;
rk4 = 0;
outTitle = 0;
ChangeScaleMG = 0;

figPlotMG = figure('units','normalized',...
        'outerposition',[0.025  0.025  0.95 0.95],...
        'Name','Equation de Mackey - Glass');
   
tauMax = 10;  
h_tau = 1; 

xlim([0 tauMax]); hold on;

tau = h_tau;
cibleMG;
m2 = max(Cible);  
for tau = 2*h_tau:h_tau:tauMax 
    m1 = m2;
    cibleMG; m2 = max(Cible);    
    plot([tau tau+h_tau], [m1 m2],'b', 'LineWidth',3);
    disp([num2str(tau/tauMax*100), '%']);
end
xlabel('\tau','FontSize',20); ylabel('max x(t)','FontSize',20);
set(gca,'FontSize',17);
title('Diagramme de bifurcation de Mackey - Glass avec \beta = 0.2 , \gamma = 0.1 , n = 10');