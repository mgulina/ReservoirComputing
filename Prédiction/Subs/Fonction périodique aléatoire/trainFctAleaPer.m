% Apprentissage du comportement d'une fonction périodique aléatoire
% *****************************************************************

disp('Entraînement');

%% 1 - Initialisation
%% 1.1 - Définitions des différentes séquences
transient = 1000; % Fin du transient
trainEnd = transient + 1000; % Fin de la séquence d'apprentissage
test84 = trainEnd + 84;

trainSeq = transient+1:trainEnd; % Séquence d'apprentissage
libreSeq = trainEnd+1:T; % Séquence d'évolution libre

%% 1.3 - Fonctions d'activation u
u = 0.2*ones(1,T);

%% 2 - Entraînement
S = zeros(T,N+K); S(1,:) = [zeros(N,1)' u(:,1)]; % Etat initial du réservoir
trainSimple;