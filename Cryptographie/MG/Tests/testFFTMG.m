% Transformée de Fourier d'un système Mackey - Glass
% **************************************************

clearvars; close all; clc;
h = 0.01; T_tot = 1000;
CibleMG;

[f,p] = TF(T_out,Cible);

figTestFFTMG = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Transformée de Fourier du signal Mackey-Glass',...
        'Visible','Off');
subplot(211);
    plot(T_out,Cible);
    xlabel('t [s]');
    title('Signal MG')
    
subplot(212);
    plot(f,p);
    xlabel('f [Hz]');
    xlim([0 0.3]);
    title('Transformée de Fourier du signal MG')
    
set(figTestFFTMG,'visible','on'); pause(10^-1);