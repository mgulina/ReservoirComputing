% Verrouillage de deux systèmes de Lorenz (RC ou RK4) 
% ***************************************************

% RC sur Lorenz
% -------------

disp('Verrouillage RC sur Lorenz');

%% 1 - Initialisation
%% 1.1 - Intervalle d'intégration
if ~exist('T_tot','var')
    T_tot = 50; % Intégration sur [0 T_tot]
end

if ~exist('h','var')
    h = 0.02; % Pas d'intégration
end

T_out = 0:h:T_tot; % Discrétisation du temps
T = length(T_out); % Nombre de points

if ~exist('Message','var')
    Message = zeros(T,1);
end

%% 1.2 - Récupération des données du RC
if ~exist('doneRClockLo','var')
% Etat final
s = S(end,:);
SLock = zeros(T,N+K); SLock(1,:) = s;
SUnlock = SLock;

else
    SLock = zeros(T,N+K); SLock(1,:) = s;
    SUnlock = SLock;
end

% Fonction d'activtion
% u = u;

% Niveaux de Bruit
LvlNoiseRC = LvlNoise;

%% 1.3 - Paramètres des Lorenz
global sigma r b;
sigma = 10; r = 28; b = 8/3;

%% 1.4 - Conditions initiales des sytèmes primaire et secondaires
primaire = [10 0 0 ; zeros(T-1,3)];
unlock = [-10 ; zeros(T-1,1)];

%% 1.5 - Paramètres du verrouillage
q = 0.95;
p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

if ~exist('tStop','var')
    tStop = round(T/2); % Arrêt du verrouillage
end

% lock3d = 1; % 0 : Verrouillage sur X ; 1 : Verrouillage sur X, Y et Z

LvlNoiseVerrou = 0; 10^-4; % Niveau de Bruit

lock = [p*unlock(1) + q*primaire(1,1) ; zeros(T-2,1)];

%% 2 - verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Système primaire   
    primaire(t+1,:) = Lorenz_rk4(h,primaire(t,:));
end
    primaire = primaire(:,1);

for t = 1:T-1
    %% 2.2 - Système secondaire sans verrouillage
    unlock(t) = W_out*SUnlock(t,:)';    
    SUnlock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SUnlock(t,1:N)',...
                      u(:,t+1),unlock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1)); 
    
    %% 2.3 - Système secondaire avec verrouillage
    if t > tStop, p = 1; end
    lock(t) = p*W_out*SLock(t,:)' +(1-p)*(primaire(t) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));
          
    SLock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SLock(t,1:N)',...
                      u(:,t+1),lock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1));
            
%     waitbar(t/T,hw);
end
unlock(T) = W_out*SUnlock(T,:)';
lock(T) = p*W_out*SLock(T,:)' +(1-p)*(primaire(T) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));

% close(hw)

%% 3 - Calcul d'erreurs et affichage
figRCLockLo = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage du réservoir sur un Mackey - Glass',...
        'Visible','Off');

calcErreursLock;

set(figRCLockLo,'visible','on');

doneRClockLo = 1;

clearvars S SLock SUnlock MG;