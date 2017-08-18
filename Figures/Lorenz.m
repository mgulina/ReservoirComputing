clear; close all; clc;
cibleLorenz;

figPlotMG = figure('units','normalized',...
        'outerposition',[0.025  0.025  0.95 0.95],...
        'Name','Equation de Mackey - Glass');
    
    
plot(T_out, Cible,'b', 'LineWidth',3);
xlabel('t [s]','FontSize',20); ylabel('x(t)','FontSize',20);
set(gca,'FontSize',17);
% title('Composante x du système de Lorenz avec \sigma = 10 , r = 28 et b = 8/3');