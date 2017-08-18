% Fonction cible pour Lorenz X
% ****************************

disp('Fonction cible');

% DO condition sur param�tre sigma r et b

%% 1 - Param�tres
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

%% 1.2 - Pas d'�chantillonnage
if ~exist('h','var')
    h = 0.02; 
end

%% 1.3 - Intervalle d'int�gration
if ~exist('T_tot','var')
    T_tot = round(10000*h); % Int�gration sur [0 T_tot]
end

%% 1.4 - Echantillonnage
T_out = 0:h:T_tot;
T = length(T_out);

%% 2 - Int�gration des �quations
if T_tot > 10000 || drapCI
    options_ode45 = odeset('AbsTol',eps);
    Lorenz = ode45(@equationLorenz,[0 T_tot], CI, options_ode45);
else
    load('cibleLorenz.mat'); % Pr�calcul de Lorenz o� T_tot = 10000
end

Cible = deval(Lorenz,T_out)';

%% 3 - Changement d'�chelle (R�duire par d�faut)
if ~exist('ChangeScaleLorenz','var')
    ChangeScaleLorenz = 3;
end

if ChangeScaleLorenz == 1
    Cible = Cible(:,1);
elseif ChangeScaleLorenz == 2
    Cible = Cible(:,1)/max(abs(Cible(:,1))); % Composante x normalis�e
elseif ChangeScaleLorenz == 3
    Cible = Cible(:,1)/100; % Composante x r�duide    
end

clear options_ode45 Lorenz;