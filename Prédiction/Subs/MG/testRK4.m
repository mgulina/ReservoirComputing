% Comparaison entre RK4 et DDE23 pour un Mackey-Glass
% ***************************************************

clc; clear; close all;

%% 1 - Paramètres communs
tau = 17; % Délai
T_tot = 1000; % Intégration sur [0 T_tot]
CI = 0.5;

%% 2 - Intégration DDE23
% h = 1; options_dde23 = ddeset('InitialStep',h,'MaxStep',h,'Refine',1);
options_dde23 = ddeset('RelTol',eps);

MG = dde23(@EquationMG,tau,CI,[0, T_tot],options_dde23);
T_out_dde23 = MG.x;
MGdde23 = deval(MG,T_out_dde23);

%% 2 - Intégration RK4
h_rk4 = inf;
for t = 1:(length(T_out_dde23)-1)
    h_rk4 = min(h_rk4,T_out_dde23(t+1) - T_out_dde23(t));
end

T_out_rk4 = 0:h_rk4:T_tot;
T = length(T_out_rk4);

MGrk4 = zeros(T,1); MGrk4(1) = CI;
for t = 1:T-1
    % Valeur retardée
    if T_out_rk4(t) <= tau + h_rk4 % + h_rk4 car y(0) --> y(1)
        Y_T = MGrk4(1);
    else
        Y_T = MGrk4(t+1-round(tau/h_rk4)); 
    end
        
    MGrk4(t+1) = MG_rk4(h_rk4,MGrk4(t),Y_T);
end

figErreurRC = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Comparaison des intégrations RK4 et DDE23',...
        'Visible','Off');
    
plot(T_out_dde23,MGdde23,'b-x'); hold on;
plot(T_out_rk4,MGrk4,'r-o');

set(figErreurRC,'Visible','On');