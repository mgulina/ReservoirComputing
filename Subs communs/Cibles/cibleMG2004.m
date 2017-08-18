% Fonction cible pour le système de Mackey - Glass
% ************************************************

disp('Fonction cible');

%% 1 - Paramètres
tau = 17; % Délai
h = 1;% Pas d'échantillonnage
T_tot = 3500; % Intégration sur [0 T_tot]

%% 2 - Intégration
options_dde23 = ddeset('AbsTol',eps,'InitialStep',h,'MaxStep',h,'Refine',1);
MG = dde23(@equationMG,tau,0.5,[0, T_tot],options_dde23);

clearvars options_dde23;

%% 3 - Changement d'échelle
T_out = 0:h:T_tot;
T = length(T_out);
Cible = tanh(deval(MG,T_out)' - 1); ChangeScaleMG = 1;

clearvars MG;