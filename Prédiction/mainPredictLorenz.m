% Emulation de syst�me chaotique par ESN
% **************************************

% Programme principal pour Lorenz
% -------------------------------

clc; close all;
clearvars -except calcMSE nMSE cas outerPos trait texte outerPos;
format short;

%% Options graphiques
if ~exist('trait','var')
    trait = 1; % Epaisseur des traits
end

if ~exist('texte','var')
    texte = 10; % Taille du texte
end

if ~exist('outerPos','var')
    outerPos = [0.05  0.2  0.7 0.7]; % Affichage en fen�tre
end

%% 1 - Construction de la fonction cible
tic;
ChangeScaleLorenz = 1;
cibleLorenz;
DureeCible = toc;

%% 2 - Construction du r�servoir
tic;
genResLorenz;
DureeGenRes = toc;

%% 3 - Entra�nement du r�servoir
tic;
tauTrain = 0; % Retard entre le RC et le Lorenz en unit� de pas d'int�gration
trainSimpleLorenz;
% TrainAvanceLorenz; % A mettre � jour
DureeTrain = toc;

%% 4 - Calcul d'erreur et affichage
tic;
calcErreursTrain;
set(figErreurRC,'visible','on'); pause(10^-1);
DureeErreur = toc;

%% 5 - Tests suppl�mentaires
tic;
% testChaos;
DureeTests = toc;

Duree = DureeCible + DureeGenRes + DureeTrain + DureeErreur + DureeTests;