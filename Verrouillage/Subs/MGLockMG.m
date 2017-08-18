% Verrouillage de deux systèmes MG (RC ou RK4) 
% ********************************************

% MG sur MG
% ---------

disp('Verrouillage MG sur MG');

%% 1 - Initialisation
%% 1.1 - Délai
tau = 17;

%% 1.2 - Intervalle d'intégration
T_tot = 1000; % Intégration sur [0 T_tot]
h = 1; % Pas d'intégration
T_out = 0:h:T_tot; % Discrétisation du temps
T = length(T_out); % Nombre de points

%% 1.3 - Conditions initiales des sytèmes primaire et secondaires
primaire = [0.5 ; zeros(T-1,1)];
unlock = [0.1 ; zeros(T-1,1)];

%% 1.4 - Efficacité du verrouillage
q = 0.5; % Parfait à eps près pour q >= 0.25
p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

%% 1.5 - Bruit pendant le verrouillage
LvlNoiseVerrou = 0;10^-10; % Niveau de Bruit

lock = [p*unlock(1) + (1-p)*(primaire(1) + ...
    LvlNoiseVerrou*unifrnd(-1,1)) ; zeros(T-2,1)];

%% 2 - Verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Système primaire
    % Valeur retardée
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = primaire(1);
    else
        Y_T = primaire(t+1-round(tau/h)); 
    end       
    
    primaire(t+1) = MG_rk4(h,primaire(t),Y_T);
    
    %% 2.2 - Système secondaire sans verrouillage
    % Valeur retardée
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = unlock(1);
    else
        Y_T = unlock(t+1-round(tau/h)); 
    end
        
    unlock(t+1) = MG_rk4(h,unlock(t),Y_T); 
    
    %% 2.3 - Système secondaire avec verrouillage
    % Valeur retardée
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = lock(1);
    else
        Y_T = lock(t+1-round(tau/h)); 
    end
    
%     if t < 200
        lock(t+1) = p*MG_rk4(h,lock(t),Y_T) +(1-p)*(primaire(t+1) ...
                + LvlNoiseVerrou*unifrnd(-1,1));
%     else
%         lock(t+1) = MG_rk4(h,lock(t),Y_T);
%     end
            
%     waitbar(t/T,hw);
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figMGLockMG = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un Mackey - Glass sur un autre',...
        'Visible','Off');
    
calcErreursLock;

set(figMGLockMG,'visible','on');