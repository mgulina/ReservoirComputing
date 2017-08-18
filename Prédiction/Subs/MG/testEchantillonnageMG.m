% Test échantillonnage sur le système de Mackey - Glass
% *****************************************************

clc; clear; close all;

T_tot = 10; % Intégration sur [0 T_tot]
load('CibleMG.mat'); % Précalcul de MG où T_tot = 35000

% Echantillonnage de pas h
Cible0p5 = deval(MG,0:0.5:T_tot)';
Cible1 = deval(MG,0:1:T_tot)';
Cible2 = deval(MG,0:2:T_tot)';
clearvars MG;

% Affichage
figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7]);
    
plot(0:0.5:T_tot,Cible0p5,'ro'); hold on;
plot(0:1:T_tot,Cible1,'g*');
plot(0:2:T_tot,Cible2,'bx');
legend('h = 0.5','h = 1','h = 2','Location','NorthEast');