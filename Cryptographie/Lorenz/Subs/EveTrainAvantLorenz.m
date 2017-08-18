% Cryptographie chaotique
% ***********************

% Eve (sans exemple)
% ------------------

disp('Eve');

%% 1 - Entraînement du réservoir
CITrain = rand(1,3);
CibleTrain = zeros(T,3);
CibleTrain(1,:) = CITrain;
for t = 1:T-1
    CibleTrain(t+1,:) = Lorenz_rk4(h,CibleTrain(t,:));
end
CibleTrain = CibleTrain(:,1);

bruitTrain = unifrnd(-A_eps,A_eps,size(CibleTrain));
CibleTrain = CibleTrain + bruitTrain; clear bruitTrain;

genResLorenz;

u = 0.2*ones(1,T);

% interpT_out = T_out;
transient = round(7*bitRepete/h);   trainEnd = T-1;     test84 = T;     fullTrain = 1;
CibleTmp = Cible(:,1);
Cible = CibleTrain;
trainSimpleLorenz;
calcErreursTrain;

disp('Verrouillage');
%% 2 - Verrouillage du système de Bob sur celui de Alice 
%% 1.2 - Récupération des données du RC
% Etat final
s = S(end,:); clear S;
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
p = 1-q; % S'(t) = p*f(S'(t-tau)) + q*S(t)

%% 2 - Verrouillage
for t = 1:T-1
  
    if t < nbrBitLock*bitRepete    
         lock(t) = p*W_out*SLock(t,:)' + (1-p)*(Crypt(t) ...
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
Cible = CibleTmp;
calcErreurCrack;

figure;
plot(Crypt);
hold on;
plot(lock,'r');
% plot(zB,'g');
% plot(CrackFiltre,'g');