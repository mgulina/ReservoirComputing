% Fonction cible pour le système de Mackey - Glass
% ************************************************

disp('Fonction cible');

%% 1 - Paramètres
tau = 17; % Délai
h_rk4 = 0.1;
T_tot = 4000; % Intégration sur [0 T_tot]
T_out = 0:h_rk4:T_tot;
T = length(T_out);

%% 2 - Intégration RK4
Cible = zeros(T,1); Cible(1) = 0.5;
for t = 1:T-1
    % Valeur retardée
    if T_out(t) < tau
        Y_T = Cible(1);
    else
        Y_T = Cible(t+1-round(tau/h_rk4)); 
    end
        
    Cible(t+1) = MG_rk4(h_rk4,Cible(t),Y_T);
end

%% 3 - Echantillonnage
h = 1;
T_out = 0:h:T_tot;
T = length(T_out);

temp = zeros(T,1);
for t = 1:T
    temp(t) = Cible(1 + round((t-1)/(h*h_rk4)));
end
Cible = temp; clear temp;

%% 4 - Changement d'échelle
% Cible = tanh(Cible - 1); ChangeScaleMG = 1;
ChangeScaleMG = 0;