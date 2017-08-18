% Cryptographie chaotique
% ***********************

% Eve (sans exemple)
% ------------------

disp('Eve');

%% 1 - Entraînement du réservoir
% CI = 0.5; clearvars T T_out T_tot rk4;
% ChangeScaleMG = 0;
% cibleMG;
bruitTrain = unifrnd(-A_eps,A_eps,size(Cible)); Cible = Cible + bruitTrain; clear bruitTrain;

genResMG;

u = 0.2*ones(1,T);

% interpT_out = T_out;
transient = round(nbrBitLock/5);   trainEnd = T-1;     test84 = T;     fullTrain = 1;
trainSimpleMG;
calcErreursTrain;

%% 2 - Verrouillage du système de Bob sur celui de Alice 
%% 1.2 - Récupération des données du RC
% Etat final
s = S(end,:);
SLock = zeros(T,N+K); SLock(1,:) = s;

% Fonction d'activtion
% u = u;

% Niveaux de Bruit
LvlNoiseRC = LvlNoise;
LvlNoiseVerrou = 0;

%% 1.3 - Conditions initiales des sytèmes primaire et secondaires
lock = zeros(T,1);

%% 1.4 - Efficacité du verrouillage
q = 0.95;
p = 1-q; % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

disp('Verrouillage');
%% 2 - Verrouillage
for t = 1:T-1
  
    if t < nbrBitLock*bitRepete    
         lock(t) = p*W_out*SLock(t,:)' +(1-p)*(Crypt(t) ...
              + unifrnd(-LvlNoiseVerrou,LvlNoiseVerrou,1,1));
         SLock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SLock(t,1:N)',...
                      u(:,t+1),lock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1));
    else
         lock(t) = W_out*SLock(t,:)';
         SLock(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,SLock(t,1:N)',...
                      u(:,t+1),lock(t),unifrnd(-LvlNoiseRC,LvlNoiseRC,N,1));
    end
end
lock(T) = p*W_out*SLock(T,:)';

if ChangeScaleMG
    lock = atanh(lock) + 1;
end

disp('Décryptage');
%% 3 - Décryptage
Crack = Crypt - lock';
% M = mean(Crack(Q*150:end));
% M = mean(Crack(150:end));
M = A/2;
% CrackFiltre = filtreSortieEve(Crack,M,Q*bitRepete);
CrackFiltre = filtreSortieEve(Crack,M,bitRepete);
CrackFiltre(CrackFiltre == 1) = A;

%% 4 - Calcul d'erreur et affichage
calcErreurCrack;