% Construction d'un reservoir pour l'�volution d'une fonction al�atoire
% *********************************************************************

disp('Construction du r�servoir');

%% 1 - Dimensions
N = min(10*periode,1000); % Nombre de neurones
K = 1; % Dimension de l'entr�e
L = 1; % Dimension de la sortie

%% 2 - Poids
W = sprand(N,N,0.05); W = spfun(@minusPoint5,W); % Poids de r�currence
W_in = 0; % Masque d'entr�e
W_fb = unifrnd(-1,1,N,L); % Poids du retour
W_out = zeros(L,N+K); % Initialisation des poids de sortie

%% 3 - Mise � l'�chelle des conexions
rayonSpectral = 0.97;
W = normRayonSpectral(W,rayonSpectral);

if ~exist('gainIn','var')
    gainIn = 1; % Gain d'entr�e
end
W_in = gainIn*W_in;

if ~exist('gainFb','var')
    gainFb = 0.01; % Gain de retour
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
ridge = 0; % M�thode d'inversion de la matrice de corr�lation
f_RC = 'tanh'; % Fonction du r�servoir   