% Cryptographie chaotique
% ***********************

% Programme principal
% -------------------

clc; close all; clearvars; format short;

% Options graphiques
fullScreen = 1; % 1 : Affichage en plein écran ; 0 : affichage dans une fenêtre

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

cas = menu('Choisissez la méthode de transmission',...
                'Superposition MG','Mélange MG','Superposition L','Annuler');

pause(10^-1);

tic;

if cas == 1
    superposition;
    set(figDecrypt,'visible','on'); pause(10^-1);
%     set(figErreurRC,'visible','on'); pause(10^-1);
    set(figCrack,'visible','on'); pause(10^-1);
    
elseif cas == 2
    melange;
    set(signalsFig,'Visible','on');
    
elseif cas == 3
    superpositionLorenz;
    set(figDecrypt,'visible','on'); pause(10^-1);
%     set(figErreurRC,'visible','on'); pause(10^-1);
    set(figCrack,'visible','on'); pause(10^-1);
    
else
    helpdlg('Programme avorté','Programme avorté');
    return;
    
end

toc