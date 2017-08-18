% Emulation de système chaotique par ESN
% **************************************

% Programme principal pour fonction périodique aléatoire
% ------------------------------------------------------

clc; close all;
clearvars -except cas outerPos trait texte outerPos;
format short;

%% Options graphiques
if ~exist('trait','var')
    trait = 1; % Epaisseur des traits
end

if ~exist('texte','var')
    texte = 10; % Taille du texte
end

if ~exist('outerPos','var')
    outerPos = [0.05  0.2  0.7 0.7]; % Affichage en fenêtre
end

%% 1 - Construction de la fonction cible
tic;
cibleFctPerAle;
DureeCible = toc;

%% 2 - Construction du réservoir
tic;
genResFctPerAle;
DureeGenRes = toc;

%% 3 - Entraînement du réservoir
tic;
theta = 0;
trainFctAleaPer;
DureeTrain = toc;

%% 4 - Calcul d'erreur et affichage
tic;
calcErreursTrain;
set(figErreurRC,'visible','on'); pause(10^-1);
DureeErreur = toc;

%% 5 - Tests supplémentaires
tic;
% testChaos;
DureeTests = toc;

Duree = DureeCible + DureeGenRes + DureeTrain + DureeErreur + DureeTests;