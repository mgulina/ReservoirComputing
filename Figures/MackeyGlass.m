clear; close all; clc;

h = 0.1;
tau = 17;
T_tot = 2000; 

%% RK4
rk4 = 1;
ChangeScaleMG = 0;
cibleMG;

figPlotMG = figure('units','normalized',...
        'outerposition',[0.05  0.1  0.9 0.9],...
        'Name','Equation de Mackey - Glass');
    
    
plot(T_out, Cible,'b', 'LineWidth',3); hold on;
xlabel('t [s]','FontSize',20); ylabel('y(t)','FontSize',20);
set(gca,'FontSize',17);
title('Equation de Mackey - Glass avec \beta = 0.2 , \gamma = 0.1 , n = 10 et \tau = 17');

%% DDE23 d'un coup
    
rk4 = 0;
cibleMG;

plot(T_out, Cible,'r', 'LineWidth',3);

%% Approximation de la solution formelle
% h = 0.1;
T_out = 0:h:T_tot;
T = length(T_out);

A_filtre = 10;
source =  @sourceMG; % @sin; % Utiliser sinus pour choisir le pas d'intégration, attention à Shanon aussi
alice_tau = 0.5*ones(round((tau+1)/h),1);

alice = zeros(T,1); alice(1) = alice_tau(round((tau+1)/h));

% t - \tau <= 0
for t = 1:round((tau)/h)+1
    f = source(alice_tau(t));
    alice(t+1) = alice(t)*exp(-h/A_filtre) + f*(1 - exp(-h/A_filtre));
end

% t - \tau > 0
for t = round((tau)/h)+2:T-1
    f = (source(alice(t-round(tau/h))) + source(alice(t-round((tau)/h)+1)))/2;
    alice(t+1) = alice(t)*exp(-h/A_filtre) + f*(1 - exp(-h/A_filtre));
end

plot(T_out, alice,'g', 'LineWidth',3);

%% Euler progressif
x = zeros(T_tot,1);
beta = 0.2; gamma = 0.1; n = 10; tau = 17; e = 1/gamma;
CI = 0.5;
x(1:round(tau/h)+1) = CI;
% h = 0.1;
for t = 1:T-1
    if t <= round(tau/h)
        x_t = CI;
    else
        x_t = x(round(t-(tau/h)));
    end
    x(t+1) = (h/e)*((beta/gamma)*(x_t/(1+x_t^n)) - x(t)) + x(t);
end
plot(T_out, x,'m', 'LineWidth',3);
%% DDE23 avec algo like RK4 %% NE FONCTIONNE PAS
% disp('Fonction cible');
% Cible = zeros(1,T); %#ok<*UNRCH>
% options_dde23 = ddeset('RelTol',2.2204510^-014);
% t = 1;
% 
% Y_T = CI;
% MG = dde23(@equationMG,tau,Y_T,[T_out(t), T_out(t+tau)],options_dde23);
% Cible(1:tau) = deval(MG,T_out(1:tau))';
% 
% Cible(tau+1)
% 
% for t = tau:T-1
%     Y_T = Cible(t+1-round(tau/h));
%     MG = dde23(@equationMG,tau,Y_T,[T_out(t), T_out(t+1)],options_dde23);
%     Cible(t+1) = deval(MG,T_out(t+1))';
% end
% Cible(tau+1)
% plot(T_out, Cible,'g', 'LineWidth',3);