% Verrouillage de deux systèmes MG (RC ou RK4) 
% ********************************************

% Programme principal
% -------------------

clc; close all; clearvars; format short; 

cas = menu('Choisissez le type de verrouillage',...
                'MG-MG','MG-RC','RC-MG','RC-RC','L-L','RC-L');
draplock = 1;
pause(10^-1);

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


if cas == 1
    Duree = 0;
    tic;
    MGLockMG;
    DureeLock = toc;
    
elseif cas == 2   
    mainPredictMG;
    tic;
    MGLockRC;
    DureeLock = toc;
    
elseif cas == 3
    rk4 = 0;
    mainPredictMG;
    tic;
    T_tot = 2000;
    T_lock = 500;
    T_libre = 1500;
    RCLockMG;
    DureeLock = toc;
    
elseif cas == 4
    tic;
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
    log10_nrmse84_1 = log10_nrmse84;
    
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
    log10_nrmse84_2 = log10_nrmse84;
    clearvars delta a C W_in W W_fb W_out S log10_mse_train ...
              log10_mse_libre log10_nrmse84;
    Duree = toc;
    
    tic;
    RCLockRC;
    DureeLock = toc;    

elseif cas == 5
    Duree = 0;
    tic;
    LoLockLo;
    DureeLock = toc;
    
elseif cas == 6
    rk4 = 0;
    mainPredictLorenz;
    tic;
    T_tot = 200;
    T_lock = 50;
    T_libre = 150;
    RCLockLo;
    DureeLock = toc;
    
else
    helpdlg('Programme avorté','Programme avorté');
    return;
end

Duree = Duree + DureeLock;