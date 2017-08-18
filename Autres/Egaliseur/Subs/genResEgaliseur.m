% Construction d'un reservoir pour l'�galiseur de canaux
% ******************************************************

disp('Construction du r�servoir');

%% 1 - Dimensions
N = 46; % Nombre de neurones
K = 1; % Dimension de l'entr�e
L = 1; % Dimension de la sortie

%% 2 - Poids
W = sprand(N,N,0.2); W = spfun(@minusPoint5,W); % Conexions internes
W_in = unifrnd(-0.025,0.025,N,K); % Masque d'entr�e
W_fb = 1; % Poids du retour

%% 3 - Mise � l'�chelle des conexions
rayonSpectral = 0.5;
W = normRayonSpectral(W,rayonSpectral);

if ~exist('gainIn','var')
    gainIn = 1; % Gain d'entr�e
end
W_in = gainIn*W_in;

if ~exist('gainFb','var')
    gainFb = 1; % Gain de retour
end
W_fb = gainFb*W_fb;

%% 4 - Param�tres d'entra�nement
if ~exist('delta','var')
    delta = 1;    
end
if ~exist('C','var')
    C = 1; % Constante globale    
end
if ~exist('a','var')
    a = 1; % Leak
end
if ~exist('LvlNoise','var')
    LvlNoise = 0; % Niveau de bruit
end
f_RC = 'tanh'; % Fonction du r�servoir 