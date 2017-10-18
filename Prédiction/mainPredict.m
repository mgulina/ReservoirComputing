% Pr�diction de syst�mes dynamiques
% *********************************

% Programme principal
% -------------------

%% 1 - Initialisation
clc; close all; clearvars; format short; 

cas = menu('Choisissez le syst�me',...
                'MG','Lorenz','FPA', 'Annuler');
pause(10^-1);

%% 2 - Options
%% 2.1 - Options graphiques
fullScreen = 1; % 1 : Affichage en plein �cran ; 0 : affichage dans une fen�tre

if fullScreen
    outerPos = [0 0.05 1 0.95];         %#ok<*UNRCH> % OuterPosFull
    trait = 2;                          % Epaisseur des traits
    texte = 20;                         % Taille du texte
else
    outerPos = [0.05  0.2  0.7 0.7];    % outerPosLock 
    trait = 1;                          % Epaisseur des traits
    texte = 10;                         % Taille du texte
end
% OuterPosTrain = [0.06  0.21  0.7 0.7];

%% 2.2 - M�trique d'erreur pour l'�volution libre
calcMSE = 1; % 1 : NRMSE ; 0 : Erreur relative
nMSE = 200;   % D�composition de 1+theta:T-trainEnd en intervalles de nMSE pas de temps

%% 3 - Lancement du programme de pr�diction par le RC
if cas == 1
    mainPredictMG;
    
elseif cas == 2   
    mainPredictLorenz;
    
elseif cas == 3
    mainPredictFctPerAlea;
    
else
    helpdlg('Programme avort�','Programme avort�');
    return;
end