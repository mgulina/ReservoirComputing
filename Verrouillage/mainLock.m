% Verrouillage de deux syst�mes MG (RC ou RK4) 
% ********************************************

% Programme principal
% -------------------

%% 1 - Initialisation
clc; close all; clearvars; format short; 

cas = menu('Choisissez le type de verrouillage',...
                'MG-MG','MG-RC','RC-MG','RC-RC','L-L','L-RC','RC-L','Compare q');
draplock = 1;
pause(10^-1);

%% 2 - Options
%% 2.1 - Options graphiques
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

%% 2.2 - M�trique d'erreur
calcMSE = 1; % 1 : NRMSE ; 0 : Erreur relative
nMSE = 100;   % D�composition de 1+theta:T-trainEnd en intervalles de nMSE pas de temps

%% 3 - Lancement du programme de verrouillage
if cas == 1
    MGLockMG;
    
elseif cas == 2   
    mainPredictMG;
    MGLockRC;
    
elseif cas == 3
    rk4 = 0;
    mainPredictMG;
    RCLockMG;
    
elseif cas == 4
    CI = 0.1;
    cibleMG;
%     cibleMG2004;    
    genResMG;
%     GenResMG2004;
%     GenResMG2010;
    u1 = 0.2*ones(1,T); u = u1;
    trainSimpleMG;
    calcErreursTrain;
    
    delta1 = delta; a1 = a; C1 = C;
    W_in1 = W_in; W1 = W; W_fb1 = W_fb;
    W_out1 = W_out; s1 = S(end,:);
    log10_mse_train1 = log10_mse_train;
    log10_mse_libre1 = log10_mse_libre;
    
    CI = 0.5;
    cibleMG;
%     cibleMG2004;    
    genResMG;
%     genResMG2004;
%     genResMG2010;
    u2 = 0.2*ones(1,T); u = u2;
    trainSimpleMG;
    calcErreursTrain;

    delta2 = delta; a2 = a; C2 = C;
    W_in2 = W_in; W2 = W; W_fb2 = W_fb;
    W_out2 = W_out; s2 = S(end,:);
    log10_mse_train2 = log10_mse_train;
    log10_mse_libre2 = log10_mse_libre;
    
    clearvars delta a C W_in W W_fb W_out S log10_mse_train ...
              log10_mse_libre log10_nrmse84;
          
    RCLockRC;  

elseif cas == 5
    LoLockLo;

elseif cas == 6
    mainPredictLorenz;
    LoLockRC;
    
elseif cas == 7
    rk4 = 0;
    mainPredictLorenz;
    RCLockLo;
    
elseif cas == 8
    compare_q;
    
else
    helpdlg('Programme avort�','Programme avort�');
    return;
end