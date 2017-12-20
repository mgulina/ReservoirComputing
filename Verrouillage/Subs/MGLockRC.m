% Verrouillage de deux systèmes MG (RC ou RK4) 
% ********************************************

% MG sur RC
% ---------

disp('Verrouillage MG sur RC');

%% 1 - Initialisation
%% 1.1 - Intervalle d'intégration
T_tot = 2000; % Intégration sur [0 T_tot]
T_lock = 500; % Début du verrouillage
T_libre = 1500; % Arrêt du verrouillage
if ~exist('h','var')
    h = 0.5; % Pas d'intégration
end
T_out = 0:h:T_tot; % Discrétisation du temps
T = length(T_out); % Nombre de points

if ~exist('doneMGlockRC','var')

%% 1.2 - Récupération des données du RC
% Etat final
s = S(end,:);
S = zeros(T,N+K); S(1,:) = s;

else
    S = zeros(T,N+K); S(1,:) = s;
end

% Fonction d'activation
% u = u;

% Niveaux de Bruit
LvlNoiseRC = LvlNoise;
LvlNoiseVerrou = 0;

%% 1.3 - Conditions initiales des sytèmes primaire et secondaires
primaire = zeros(T,1);
unlock = [0.5 ; zeros(T-1,1)];

%% 1.4 - Efficacité du verrouillage
if ~exist('q','var')
    q = 0.25;
end
% p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

lock = [unlock(1) ; zeros(T-2,1)];

%% 2 - verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Système primaire
    primaire(t) = W_out*S(t,:)';
        
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,S(t,1:N)',...
                      u(:,t+1),primaire(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,1,1)); 
end
primaire(T) = W_out*S(T,:)';

if ChangeScaleMG
    primaire = atanh(primaire) + 1;
end

for t = 1:T-1
    %% 2.2 - Système secondaire sans verrouillage
    % Valeur retardée
    if T_out(t) <= tau + h % +h car y(0) --> y(1)
        Y_T = unlock(1);
    else
        Y_T = unlock(t+1-round(tau/h)); 
    end
        
    unlock(t+1) = MG_rk4(h,unlock(t),Y_T);
    
    %% 2.3 - Système secondaire avec verrouillage
    % Valeur retardée
    if T_out(t) <= tau + h % +h car y(0) --> y(1)
        Y_T = lock(1);
    else
        Y_T = lock(t+1-round(tau/h)); 
    end
     
    if t < T_lock/h, p = 1; else p = 1-q; end
    if t > T_libre/h, p = 1; end 
    lock(t+1) = p*MG_rk4(h,lock(t),Y_T) ...
                +(1-p)*( primaire(t+1) ...
                + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1) );                
            
%     waitbar(t/T,hw);
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figMGLockRC = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un Mackey - Glass sur un réservoir',...
        'Visible','Off');
    
calcErreursLock;

set(figMGLockRC,'visible','on');

doneMGlockRC = 1;