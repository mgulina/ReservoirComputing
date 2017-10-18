% Emulation de syst�me chaotique par ESN
% **************************************

% Programme principal pour le MG
% ------------------------------

%% Compatabilit� avec le verrouillage
if ~exist('draplock','var')
    draplock = 0;
end

if draplock
    clc; close all; %#ok<UNRCH>
else
    clc; close all;
    clearvars -except calcMSE nMSE cas outerPos trait texte outerPos;
    format short;
end

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
% h = 1;
cibleMG;
% cibleMG2004;
% cibleMG_RK4; % Refaire �chantillonage pour fixer nbr de points

%% 2 - Construction du r�servoir
% LvlNoise = 10^-6;
genResMG;
% genResMG2004;
% genResMG2010;

%% 3 - Entra�nement du r�servoir
% tic;
theta = round(0/h); % D�lai entre le RC et le MG : 0 par d�faut
trainSimpleMG;
% trainAvanceMG; % A mettre � jour

%% 4 - Calcul d'erreur et affichage
% tic;
calcErreursTrain;
set(figErreurRC,'visible','on'); pause(10^-1);

%% 5 - Tests suppl�mentaires
% tic;
% testAttracteursMG;
% testChaos; % A mettre � jour

Duree = toc;