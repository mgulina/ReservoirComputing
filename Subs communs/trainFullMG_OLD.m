% Copie du comportement d'un syst�me MG
% *************************************

disp('Entra�nement'); fullTrain = 1;

%% 1 - Initialisation
%% 1.1 - D�finitions des diff�rentes s�quences
transient = 1; % Fin du transient
trainEnd = T-1; % Fin de la s�quence d'apprentissage
test84 = T;

trainSeq = transient+1:trainEnd; % S�quence d'apprentissage
libreSeq = trainEnd+1:T; % S�quence d'�volution libre

%% 1.2 - Fonction d'activation
if ~exist('u','var')
    u = 0.2*ones(1,T);
end

%% 2 - Entra�nement
S = zeros(T,N+K); S(1,:) = [zeros(N,1) ; u(:,1)]'; % Etat initial du r�servoir
trainSimple;

%% 3 - Retour vers l'�chelle originale
if ChangeScaleMG
    Cible = atanh(Cible) + 1;
    y_hat = atanh(y_hat) + 1; 
end