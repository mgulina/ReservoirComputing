% Cryptographie chaotique
% ***********************
%
% Superposition 
% --------------

methodeEve = menu('Choisissez la méthode pour Eve',...
                'Exemple de message','Verrouillage',...
                'Annuler');
            
%% 1 - Paramètres
if methodeEve == 1
    h = 1;                                  % Pas
    % Q = 1;
    bitRepete = 50;                          % Nombre de répétitions successives d'un bit : même bit pendant 75s
    % CryptTransient = 150                  % 
    nbrBitLock = 8*20; %ceil(150/bitRepete/h); % Nombre de bit nul commençant le message : correspond à 150s de verrouillage
    nbrBit = 8*50 + nbrBitLock;                % Nombre de bit composant le message caché
    nbrBitTrain = 8*100;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-2;                           % Amplitude du bruit lors de la transmission

    
elseif methodeEve == 2 % Verrouillage
    h = 1;                                  % Pas
    % Q = 1;
    bitRepete = 1;                          % Nombre de répétitions successives d'un bit : même bit pendant 75s
    % CryptTransient = 150                  % 
    nbrBitLock = 8*50; %ceil(150/bitRepete/h); % Nombre de bit nul commençant le message : correspond à 150s de verrouillage
    nbrBit = 8*500 + nbrBitLock;                % Nombre de bit composant le message caché
%     nbrBitTrain = 8*100;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-2;                           % Amplitude du bruit lors de la transmission

else
    helpdlg('Programme avorté','Programme avorté');
    return;
end

%% 2 - Cryptographie par superposition
%% 2.1 - Cryptage
Alice;

%% 2.2 - Décryptage
Bob;

%% 2.3 - Décodage
if methodeEve == 1
    EveExemple;
    
elseif methodeEve == 2 % Verrouillage
    EveTrainAvant;
else
    helpdlg('Programme avorté','Programme avorté');
    return;
end