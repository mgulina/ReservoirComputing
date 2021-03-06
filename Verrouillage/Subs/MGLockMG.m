% Verrouillage de deux syst�mes MG (RC ou RK4) 
% ********************************************

% MG sur MG
% ---------

disp('Verrouillage MG sur MG');

%% 1 - Initialisation
%% 1.1 - D�lai
tau = 17;

%% 1.2 - Intervalle d'int�gration
T_tot = 2000; % Int�gration sur [0 T_tot]
T_lock = 1000; % D�but du verrouillage
T_libre = 1600; % Arr�t du verrouillage

h = 0.5; % Pas d'int�gration
T_out = 0:h:T_tot; % Discr�tisation du temps
T = length(T_out); % Nombre de points

%% 1.3 - Conditions initiales des syt�mes primaire et secondaires
primaire = [0.5 ; zeros(T-1,1)];
unlock = [0.1 ; zeros(T-1,1)];

%% 1.4 - Param�tres du verrouillage
if ~exist('q','var')
    q = 0.25;% Parfait � eps pr�s pour q >= 0.25
end 
% p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

%% 1.5 - Bruit pendant le verrouillage
LvlNoiseVerrou = 0;10^-10; % Niveau de Bruit

lock = [unlock(1) ; zeros(T-1,1)];

%% 2 - Verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Syst�me primaire
    % Valeur retard�e
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = primaire(1);
    else
        Y_T = primaire(t+1-round(tau/h)); 
    end       
    
    primaire(t+1) = MG_rk4(h,primaire(t),Y_T);
    
    %% 2.2 - Syst�me secondaire sans verrouillage
    % Valeur retard�e
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = unlock(1);
    else
        Y_T = unlock(t+1-round(tau/h)); 
    end
        
    unlock(t+1) = MG_rk4(h,unlock(t),Y_T); 
    
    %% 2.3 - Syst�me secondaire avec verrouillage
    % Valeur retard�e
    if T_out(t) <= tau + h % + h car y(0) --> y(1)
        Y_T = lock(1);
    else
        Y_T = lock(t+1-round(tau/h)); 
    end
    
    if t < T_lock/h, p = 1; else p = 1-q; end
    if t > T_libre/h, p = 1; end 
    lock(t+1) = p*MG_rk4(h,lock(t),Y_T) +(1-p)*(primaire(t+1) ...
                + LvlNoiseVerrou*unifrnd(-1,1));
            
%     waitbar(t/T,hw);
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figMGLockMG = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un Mackey - Glass sur un autre',...
        'Visible','Off');
    
calcErreursLock;

doneMGlockMG = 1;

% set(figMGLockMG,'visible','on');