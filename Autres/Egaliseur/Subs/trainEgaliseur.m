% Apprentissage pour l'égaliseur de canaux
% ****************************************

disp('Entraînement');

%% 1 - Paramètres d'entraînement
transient = 1000; % Fin du transient
trainEnd = 5100; % Fin de la séquence d'apprentissage

trainSeq = transient+1:trainEnd; % Séquence d'apprentissage

lambda = 0.998; % Taux d'oubli pour l'algorithme RLS

%% 2 - Transient
disp('Transient');

S = [zeros(N,1)' u(1)]; % Etat initial du réservoir
for t = 3:transient     
     S = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(1:N)',u(t+1),d(t-delai),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end

%% 3 - Apprentissage RLS
disp('Apprentissage RLS');

%% 3.1 - Matrice auxiliaire
psi_inv = zeros(N+K,N+K);
for i = 1:N+K
    psi_inv(i,i) = 10^10;
end

y_hat = zeros(1,T); % Sortie RC
d_hat = zeros(1,T); % Sortie RC (filtrée)
W_out = zeros(L,N+K); % Initialisation des poids de sortie
x = S(1:N)';
for t = transient+1:trainEnd
    %% 3.2 - Mise à jour du réservoir
    S = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(1:N)',u(t+1),d(t-delai),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
    
    %% 3.3 - Algorithme RLS (Recursive least squares)
    v = psi_inv*S';
    k = v./(lambda + S*v);
    y_hat(t) = W_out*S';
    e = d(t-delai) - y_hat(t);
    W_out = W_out + k'*e;
    psi_inv = 1/lambda * (psi_inv - k*(S*psi_inv));
    
    %% 3.4 - Filtre de sortie
    if y_hat(t) < -2
        d_hat(t) = -3;
    elseif y_hat(t) < 0
        d_hat(t) = -1;
    elseif y_hat(t) < 2
        d_hat(t) = 1;
    elseif y_hat(t) < 4
        d_hat(t) = 3;
    else
        d_hat(t) = 0;
    end
end

%% 3.5 - Erreur pendant l'entraînement
erreurTrain = 100*abs(d(trainSeq-delai)-d_hat(trainSeq))...
    ./abs(d(trainSeq-delai));
posErreurTrain = find(erreurTrain) + transient;
nbrErreurTrain = length(posErreurTrain);

clearvars v k e psi_inv;

%% 4 - Evolution autonome
disp('Evolution autonome');

%% 4.1 - Initialisation
erreurLibre = zeros(1,length(trainEnd+1:T));
posErreurLibre = [];
nbrErreurLibre = 0;
stop = 0;

%% 4.2 - Evolution des états internes
for t = trainEnd+1:T
    %% 4.2.1 - Mise à jour du réservoir
    S = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(1:N)',u(t+1),d(t-delai),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
    
    %% 4.2.2 - Filtre du signal de sortie
    y_hat(t) = W_out*S';
    if y_hat(t) < -2
        d_hat(t) = -3;
    elseif y_hat(t) < 0
        d_hat(t) = -1;
    elseif y_hat(t) < 2
        d_hat(t) = 1;
    elseif y_hat(t) < 4
        d_hat(t) = 3;
    else
        d_hat(t) = 0;
    end
    
    %% 4.2.3 - Vérification
    erreurLibre(t) = d(t-2) - d_hat(t);
    if erreurLibre(t) ~= 0
        posErreurLibre = [posErreurLibre t]; %#ok<AGROW>
        nbrErreurLibre = nbrErreurLibre + 1;
    end
    
    if nbrErreurLibre == 10
        stop = 1;
        break;
    end
    
    %% 4.2.4 - Progression
    if rem(t,round((T-trainEnd)/100)) == 0
        clc;
        disp([num2str(round(100*(t-trainEnd)/(T-trainEnd))),' %']);
    end
end
clc;

if stop
    disp(['Test interrompu à ', num2str(100*(t-trainEnd)/(T-trainEnd)),' %']);
else
    disp('Test terminé à 100%');
end