% Verrouillage de deux syst�mes MG (RC ou RK4) 
% ********************************************

% RC sur MG
% ---------

disp('Verrouillage RC sur MG');

%% 1 - Initialisation
if ~exist('doneRClockMG','var')
    doneRClockMG = 0;
end

%% 1.1 - Intervalle d'int�gration
T_tot = 2000; % Int�gration sur [0 T_tot]
T_lock = 500; % D�but du verrouillage
T_libre = 1500; % Arr�t du verrouillage
    
if ~exist('h','var')
    h = 0.5; % Pas d'int�gration
end

T_out = 0:h:T_tot; % Discr�tisation du temps
T = length(T_out); % Nombre de points

if ~exist('Message','var')
    Message = zeros(T,1);
end

%% 1.2 - R�cup�ration des donn�es du RC
if doneRClockMG == 0
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
LvlNoiseVerrou = 0;

%% 1.3 - Conditions initiales des syt�mes primaire et secondaires
primaire = [0.5 ; zeros(T-1,1)]; tauP = 17;
unlock = zeros(T,1);
lock = zeros(T,1);

%% 1.4 - Efficacit� du verrouillage
if ~exist('q','var')
    q = 0.25;
end
% p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

%% 2 - verrouillage
% hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
% set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for t = 1:T-1
    %% 2.1 - Syst�me primaire
    % Valeur retard�e
    if T_out(t) <= tauP + h % +h car y(0) --> y(1)
        Y_T = primaire(1);
    else
        Y_T = primaire(t+1-round(tauP/h)); 
    end       
    
    primaire(t+1) = MG_rk4(h,primaire(t),Y_T);

end
if ChangeScaleMG
    primairePure = tanh(primaire - 1);
    primaire = tanh(primaire + Message - 1);
end

for t = 1:T-1
    %% 2.2 - Syst�me secondaire sans verrouillage
    unlock(t) = W_out*SUnlock(t,:)';    
    SUnlock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SUnlock(t,1:N)',...
                      u(:,t+1),unlock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1)); 
    
    %% 2.3 - Syst�me secondaire avec verrouillage
    if t < T_lock/h, p = 1; else p = 1-q; end
    if t > T_libre/h, p = 1; end
    lock(t) = p*W_out*SLock(t,:)' +(1-p)*(primaire(t) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));
          
    SLock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SLock(t,1:N)',...
                      u(:,t+1),lock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1));
            
%     waitbar(t/T,hw);
end
unlock(T) = W_out*SUnlock(T,:)';
lock(T) = p*W_out*SLock(T,:)' +(1-p)*(primaire(T) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));

if ChangeScaleMG
    primairePure = atanh(primairePure) + 1;
    primaire = atanh(primaire) + 1;
    lock = atanh(lock) + 1;
    unlock = atanh(unlock) + 1;
end
% close(hw)

%% 3 - Calcul d'erreurs et affichage
figRCLockMG = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage du r�servoir sur un Mackey - Glass',...
        'Visible','Off');

calcErreursLock;

set(figRCLockMG,'visible','on');

doneRClockMG = 1;