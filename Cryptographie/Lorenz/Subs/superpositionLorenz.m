% Cryptographie chaotique
% ***********************
%
% Superposition 
% --------------

methodeEve = menu('Choisissez la m�thode pour Eve',...
                'Exemple de message','Verrouillage',...
                'Annuler');
pause(10^-3);

%% 1 - Param�tres
if methodeEve == 1
    h = 0.02;                                  % Pas
    % Q = 1;
    bitRepete = 50;                          % Nombre de r�p�titions successives d'un bit : m�me bit pendant h*bitRepete secondes 
    % CryptTransient = 150                  % 
    nbrBitLock = 8*50; %ceil(150/bitRepete/h); % Nombre de bit nul commen�ant le message :
    nbrBit = 8*50 + nbrBitLock;                % Nombre de bit composant le message cach�
    nbrBitTrain = 8*50;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-5;                           % Amplitude du bruit lors de la transmission
    lock3d = 0;                            

    
elseif methodeEve == 2 % Verrouillage
    h = 0.02;                                  % Pas
    % Q = 1;
    bitRepete = 1;                          % Nombre de r�p�titions successives d'un bit : m�me bit pendant h*bitRepete secondes 
    % CryptTransient = 150                  % 
    nbrBitLock = 8*200; %ceil(150/bitRepete/h); % Nombre de bit nul commen�ant le message :
    nbrBit = 8*500 + nbrBitLock;                % Nombre de bit composant le message cach�
    % nbrBitTrain = 8*100;                       % Nombre de bit composant le message exemple
    A = 10^-2;                                 % Amplitude du message
    A_eps = 0;10^-5;                           % Amplitude du bruit lors de la transmission
    lock3d = 0;                   

else
    helpdlg('Programme avort�','Programme avort�');
    return;
end

%% 2 - Cryptographie par superposition
%% 2.1 - Cryptage
AliceLorenz;

%% 2.2 - D�cryptage
BobLorenz;

%% 2.3 - D�codage
% EveExempleLorenz;
EveTrainAvantLorenz; % Verrouillage