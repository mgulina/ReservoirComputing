% Apprentissage du comportement d'une fonction p�riodique al�atoire
% *****************************************************************

disp('Entra�nement');

%% 1 - Initialisation
%% 1.1 - D�finitions des diff�rentes s�quences
transient = 1000; % Fin du transient
trainEnd = transient + 1000; % Fin de la s�quence d'apprentissage
test84 = trainEnd + 84;

trainSeq = transient+1:trainEnd; % S�quence d'apprentissage
libreSeq = trainEnd+1:T; % S�quence d'�volution libre

%% 1.3 - Fonctions d'activation u
u = 0.2*ones(1,T);

%% 2 - Entra�nement
S = zeros(T,N+K); S(1,:) = [zeros(N,1)' u(:,1)]; % Etat initial du r�servoir
trainSimple;