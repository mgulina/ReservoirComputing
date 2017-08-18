% Classification de signal 
% ************************

% Programme principal
% -------------------

clc; close all; clearvars; format short;

% Options graphiques
fullScreen = 1; % 1 : Affichage en plein �cran ; 0 : affichage dans une fen�tre

if fullScreen
    outerPos = [0 0.05 1 0.95]; %#ok<*UNRCH> % OuterPosFull
    trait = 2; % Epaisseur des traits
    texte = 20; % Taille du texte
else
    outerPos = [0.05  0.2  0.7 0.7]; % outerPosLock 
    trait = 1; % Epaisseur des traits
    texte = 10; % Taille du texte
end
% OuterPosTrain = [0.06  0.21  0.7 0.7];

%% 1 - Construction de la fonction cible
tic;
cibleClass;
DureeCible = toc;

%% 2 - Construction du r�servoir
tic;
genResClass;
DureeGenRes = toc;

%% 3 - Entra�nement du r�servoir
tic;
trainClass;
DureeTrain = toc;
    
%% 4 - Calcul d'erreur et affichage
tic;
calcErreursTrain;
set(figErreurRC,'visible','on'); pause(10^-1);
% set(figCible,'visible','on'); pause(10^-1);
DureeErreur = toc;

Duree = DureeCible + DureeGenRes + DureeTrain + DureeErreur;