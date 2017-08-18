% Fonction cible pour Lorenz X
% ****************************

disp('Fonction cible');

% DO condition sur paramètre sigma r et b

%% 1 - Paramètres
%% 1.1 - Condition initiale
if ~exist('CI','var')
    CI = [0.1 0 0];
    drapCI = 0;
else
    if sum(CI ~= [0.1 0 0]) > 0
        drapCI = 1;
    else
        drapCI = 0;
    end
end

%% 1.2 - Pas d'échantillonnage
if ~exist('h','var')
    h = 0.02; 
end

%% 1.3 - Intervalle d'intégration
if ~exist('T_tot','var')
    T_tot = round(10000*h); % Intégration sur [0 T_tot]
end

%% 1.4 - Echantillonnage
T_out = 0:h:T_tot;
T = length(T_out);

%% 2 - Intégration des équations
if T_tot > 10000 || drapCI
    options_ode45 = odeset('AbsTol',eps);
    Lorenz = ode45(@equationLorenz,[0 T_tot], CI, options_ode45);
else
    load('cibleLorenz.mat'); % Précalcul de Lorenz où T_tot = 10000
end

Cible = deval(Lorenz,T_out)';

%% 3 - Changement d'échelle (Réduire par défaut)
if ~exist('ChangeScaleLorenz','var')
    ChangeScaleLorenz = 3;
end

if ChangeScaleLorenz == 1
    Cible = Cible(:,1);
elseif ChangeScaleLorenz == 2
    Cible = Cible(:,1)/max(abs(Cible(:,1))); % Composante x normalisée
elseif ChangeScaleLorenz == 3
    Cible = Cible(:,1)/100; % Composante x réduide    
end

clear options_ode45 Lorenz;