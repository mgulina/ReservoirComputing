% Verrouillage de deux syst�mes de Lorenz (RC ou RK4) 
% ***************************************************

% Lorenz sur Lorenz
% -----------------

disp('Verrouillage Lorenz sur Lorenz');

%% 1 - Initialisation
%% 1.1 - Param�tres des Lorenz
global sigma r b;
sigma = 10; r = 28; b = 8/3;

%% 1.2 - Intervalle d'int�gration
T_tot = 20; % Int�gration sur [0 T_tot]
h = 0.02; % Pas d'int�gration
T_out = 0:h:T_tot; % Discr�tisation du temps
T = length(T_out); % Nombre de points

%% 1.3 - Conditions initiales des syt�mes primaire et secondaires
primaire = [10 0 0 ; zeros(T-1,3)];
unlock = [-10 0 0 ; zeros(T-1,3)];

%% 1.4 - Param�tres du verrouillage
q = 0.25; % Parfait � eps pr�s pour q >= 0.25
p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

tStop = T_tot; % Temps apr�s lequel le verrouillage est coup�

lock3d = 1; % 0 : Verrouillage sur X ; 1 : Verrouillage sur X, Y et Z

LvlNoiseVerrou = 0; 10^-4; % Niveau de Bruit

lock = [p*unlock(1,:) + q*primaire(1,:) ; zeros(T-2,3)];

%% 2 - Verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Syst�me primaire     
    primaire(t+1,:) = Lorenz_rk4(h,primaire(t,:));
    
    %% 2.2 - Syst�me secondaire sans verrouillage
    unlock(t+1,:) = Lorenz_rk4(h,unlock(t,:)); 
    
    %% 2.3 - Syst�me secondaire avec verrouillage
    
    if t < tStop/h

        if lock3d
            lock(t+1,:) = p*Lorenz_rk4(h,lock(t,:)) + q*primaire(t+1,:) + LvlNoiseVerrou*unifrnd(-1,1,1,3);
        else
            lock(t+1,:) = p*Lorenz_rk4(h,lock(t,:)) + q*[primaire(t+1,1) lock(t,2:3)] + LvlNoiseVerrou*unifrnd(-1,1,1,3);
        end
    else
        lock(t+1,:) = Lorenz_rk4(h,lock(t,:));
    end
            
%     waitbar(t/T,hw);
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figMGLockMG = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un Lorenz sur un autre',...
        'Visible','Off');

primaire = primaire(:,1);    
unlock = unlock(:,1);
lock = lock(:,1);

calcErreursLock;

set(figMGLockMG,'visible','on');