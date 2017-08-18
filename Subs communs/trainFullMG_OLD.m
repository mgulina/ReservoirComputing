% Copie du comportement d'un système MG
% *************************************

disp('Entraînement'); fullTrain = 1;

%% 1 - Initialisation
%% 1.1 - Définitions des différentes séquences
transient = 1; % Fin du transient
trainEnd = T-1; % Fin de la séquence d'apprentissage
test84 = T;

trainSeq = transient+1:trainEnd; % Séquence d'apprentissage
libreSeq = trainEnd+1:T; % Séquence d'évolution libre

%% 1.2 - Fonction d'activation
if ~exist('u','var')
    u = 0.2*ones(1,T);
end

%% 2 - Entraînement
S = zeros(T,N+K); S(1,:) = [zeros(N,1) ; u(:,1)]'; % Etat initial du réservoir
trainSimple;

%% 3 - Retour vers l'échelle originale
if ChangeScaleMG
    Cible = atanh(Cible) + 1;
    y_hat = atanh(y_hat) + 1; 
end