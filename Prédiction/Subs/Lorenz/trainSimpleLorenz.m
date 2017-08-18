% Apprentissage du comportement d'un système Lorenz
% *************************************************

disp('Entraînement');

%% 1 - Initialisation
%% 1.1 - Définitions des différentes séquences
if ~exist('transient','var')
    transient = 1000; % Fin du transient
end
if ~exist('trainEnd','var')
    trainEnd = transient + 6000; % Fin de la séquence d'apprentissage
end
if ~exist('test84','var')
    test84 = trainEnd + 84;
end

trainSeq = transient+1:trainEnd; % Séquence d'apprentissage
libreSeq = trainEnd+1:T; % Séquence d'évolution libre

%% 1.2 - Fonction d'activation
if ~exist('u','var')
    u = 0.2*ones(1,T);
end

%% 2 - Entraînement
S = zeros(T,N+K); S(1,:) = [zeros(N,1)' u(:,1)]; % Etat initial du réservoir
trainSimple;