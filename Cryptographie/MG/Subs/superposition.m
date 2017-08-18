% Cryptographie chaotique
% ***********************
%
% Superposition 
% --------------

%% 1 - Param�tres
h = 1;                                  % Pas
% Q = 1;
bitRepete = 1;                          % Nombre de r�p�titions successives d'un bit : m�me bit pendant 75s
% CryptTransient = 150                  % 
nbrBitLock = 8*20; %ceil(150/bitRepete/h); % Nombre de bit nul commen�ant le message : correspond � 150s de verrouillage
nbrBit = 8*50 + nbrBitLock;                % Nombre de bit composant le message cach�
% nbrBitTrain = 8*100;                       % Nombre de bit composant le message exemple
A = 10^-2;                                 % Amplitude du message
A_eps = 0;10^-2;                           % Amplitude du bruit lors de la transmission

%% 2 - Cryptographie par superposition
%% 2.1 - Cryptage
Alice;

%% 2.2 - D�cryptage
Bob;

%% 2.3 - D�codage
% EveExemple;
EveTrainAvant; % Verrouillage