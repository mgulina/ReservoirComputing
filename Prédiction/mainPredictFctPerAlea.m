% Emulation de syst�me chaotique par ESN
% **************************************

% Programme principal pour fonction p�riodique al�atoire
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
    outerPos = [0.05  0.2  0.7 0.7]; % Affichage en fen�tre
end

%% 1 - Construction de la fonction cible
tic;
cibleFctPerAle;
DureeCible = toc;

%% 2 - Construction du r�servoir
tic;
genResFctPerAle;
DureeGenRes = toc;

%% 3 - Entra�nement du r�servoir
tic;
theta = 0;
trainFctAleaPer;
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