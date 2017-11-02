% Cryptographie chaotique
% ***********************
%
% Superposition 
% --------------

methodeEve = menu('Choisissez la méthode pour Eve',...
                'Exemple de message','Verrouillage',...
                'Annuler');
pause(10^-3);

%% 1 - Paramètres
if methodeEve == 1
    h = 0.02;                                  % Pas
    % Q = 1;
    bitRepete = 50;                          % Nombre de répétitions successives d'un bit : même bit pendant h*bitRepete secondes 
    % CryptTransient = 150                  % 
    nbrBitLock = 8*50; %ceil(150/bitRepete/h); % Nombre de bit nul commençant le message :
    nbrBit = 8*50 + nbrBitLock;                % Nombre de bit composant le message caché
    nbrBitTrain = 8*50;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-5;                           % Amplitude du bruit lors de la transmission
    lock3d = 0;                            

    
elseif methodeEve == 2 % Verrouillage
    h = 0.02;                                  % Pas
    % Q = 1;
    bitRepete = 1;                          % Nombre de répétitions successives d'un bit : même bit pendant h*bitRepete secondes 
    % CryptTransient = 150                  % 
    nbrBitLock = 8*200; %ceil(150/bitRepete/h); % Nombre de bit nul commençant le message :
    nbrBit = 8*500 + nbrBitLock;                % Nombre de bit composant le message caché
    % nbrBitTrain = 8*100;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-5;                           % Amplitude du bruit lors de la transmission
    lock3d = 0;                   

else
    helpdlg('Programme avorté','Programme avorté');
    return;
end

%% 2 - Cryptographie par superposition
%% 2.1 - Cryptage
AliceLorenz;

%% 2.2 - Décryptage
BobLorenz;

%% 2.3 - Décodage
% EveExempleLorenz;
EveTrainAvantLorenz; % Verrouillage