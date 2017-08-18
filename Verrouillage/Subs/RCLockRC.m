% Verrouillage de deux systèmes MG (RC ou RK4) 
% ********************************************

% RC sur RC
% ---------

disp('Verrouillage RC sur RC');

%% 1 - Initialisation
%% 1.1 - Intervalle d'intégration
if ~exist('T_tot','var')
    T_tot = 3000; % Intégration sur [0 T_tot]
end
if ~exist('h','var')
    h = 0.5; % Pas d'intégration
end
T_out = 0:h:T_tot; % Discrétisation du temps
T = length(T_out); % Nombre de points

%% 1.2 - Récupération des données du RC
% Etat final
Sprimaire = zeros(T,N+K); Sprimaire(1,:) = s1;
SLock = zeros(T,N+K); SLock(1,:) = s2;
SUnlock = zeros(T,N+K); SUnlock(1,:) = s2;
    
% Fonctions d'activation
if ~exist('u1','var')
    u1 = 0.2*ones(1,T);
end
if ~exist('u2','var')
    u2 = 0.2*ones(1,T);
end

% Niveaux de Bruit
LvlNoiseRC = LvlNoise;
LvlNoiseVerrou = 0;

%% 1.3 - Conditions initiales des sytèmes primaire et secondaires
primaire = zeros(T,1);
unlock = zeros(T,1);
lock = zeros(T,1);


%% 1.4 - Efficacité du verrouillage
q = 0.25;
p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

%% 2 - verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %
    noise = unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1);
    %% 2.1 - Système primaire
    primaire(t) = W_out1*Sprimaire(t,:)';
    
    Sprimaire(t+1,:) = majRes(f_RC,delta1,a1,C1,W_in1,W1,W_fb1, ...
                            Sprimaire(t,1:N)',u1(:,t+1),primaire(t),noise); 
    
    %% 2.2 - Système secondaire sans verrouillage
    unlock(t) = W_out2*SUnlock(t,:)';    
    SUnlock(t+1,:) = majRes(f_RC,delta2,a2,C2,W_in2,W2,W_fb2, ...
                            SUnlock(t,1:N)',u2(:,t+1),unlock(t),noise);                        
    
    %% 2.3 - Système secondaire avec verrouillage
    lock(t) = p*W_out2*SLock(t,:)' + q*(primaire(t) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));
          
    SLock(t+1,:) = MajRes(f_RC,delta2,a2,C2,W_in2,W2,W_fb2, ...
                            SLock(t,1:N)',u2(:,t+1),lock(t),noise);                                     
            
%     waitbar(t/T,hw);
end
primaire(T) = W_out1*Sprimaire(T,:)';
unlock(T) = W_out2*SUnlock(T,:)'; 
lock(T) = p*W_out2*SLock(T,:)' + q*(primaire(T) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));
          
if ChangeScaleMG
    primaire = atanh(primaire) + 1;
    unlock = atanh(unlock) + 1;
    lock = atanh(lock) + 1;
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figMGLockRC = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un réservoir Mackey - Glass sur un autre',...
        'Visible','Off');
    
calcErreursLock;

set(figMGLockRC,'visible','on');

clearvars ER_libre MG;