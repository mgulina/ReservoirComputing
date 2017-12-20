% Verrouillage de deux syst�mes de Lorenz (RC ou RK4) 
% ***************************************************

% Lorenz sur RC
% -------------

disp('Verrouillage Lorenz sur RC');

%% 1 - Initialisation
%% 1.1 - Intervalle d'int�gration
T_tot = 50; % Int�gration sur [0 T_tot]
T_lock = 20; % D�but du verrouillage
T_libre = 40; % Arr�t du verrouillage

if ~exist('h','var')
    h = 0.02; % Pas d'int�gration
end

T_out = 0:h:T_tot; % Discr�tisation du temps
T = length(T_out); % Nombre de points

if ~exist('Message','var')
    Message = zeros(T,1);
end

%% 1.2 - R�cup�ration des donn�es du RC
if ~exist('doneLolockRC','var')
% Etat final
s = S(end,:);
S = zeros(T,N+K); S(1,:) = s;

doneLolockRC = 0;

else
    S = zeros(T,N+K); S(1,:) = s;
end

% Fonction d'activtion
% u = u;

% Niveaux de Bruit
LvlNoiseRC = LvlNoise;

%% 1.3 - Param�tres des Lorenz
global sigma r b;
sigma = 10; r = 28; b = 8/3;

%% 1.4 - Conditions initiales des syt�mes primaire et secondaires
primaire = [10; zeros(T-1,1)];
unlock = [-10 0 0 ; zeros(T-1,3)];

%% 1.5 - Param�tres du verrouillage
if ~exist('q','var')
    q = 0.25;
end
% p = 1-q;

LvlNoiseVerrou = 0; % Niveau de Bruit

lock = [unlock(1,:) ; zeros(T-2,3)];

%% 2 - verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
    %% 2.1 - Syst�me primaire 
    for t = 1:T-1
    primaire(t) = W_out*S(t,:)';
        
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,S(t,1:N)',...
                      u(:,t+1),primaire(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,1,1)); 
    end
    primaire(T) = W_out*S(T,:)';
    
for t = 1:T-1
    %% 2.2 - Syst�me secondaire sans verrouillage
    unlock(t+1,:) = Lorenz_rk4(h,unlock(t,:)); 
    
    %% 2.3 - Syst�me secondaire avec verrouillage
    if t < T_lock/h, p = 1; else p = 1-q; end
    if t > T_libre/h, p = 1; end
        lock(t+1,:) = p*Lorenz_rk4(h,lock(t,:)) ...
                    + (1-p)*primaire(t+1,:) ...
                    + LvlNoiseVerrou*unifrnd(-1,1);
           
%     waitbar(t/T,hw);
end
lock = lock(:,1); % Supression des composantes y et z qui n'ont servis que pour int�grer
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figRCLockLo = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage du r�servoir sur un Lorenz',...
        'Visible','Off');

calcErreursLock;

set(figRCLockLo,'visible','on');

doneLolockRC = 1;