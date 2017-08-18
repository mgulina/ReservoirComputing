% Construction d'un reservoir pour prédire Lorenz X
% *************************************************

disp('Construction du réservoir');
%% 1 - Dimensions
N = 1500; % Nombre de neurones
K = 1; % Dimension de l'entrée
L = 1; % Dimension de la sortie

%% 2 - Poids
if ~exist('gamma','var')
    gamma = 0.02; % Connectivité
end

W = sprand(N,N,gamma); W = spfun(@minusPoint5,W); % Conexions internes
W_in = unifrnd(-1,1,N,K); % Masque d'entrée
W_fb = unifrnd(-1,1,N,L); % Poids du retour
W_out = zeros(L,N+K); % Initialisation des poids de sortie

%% 3 - Mise à l'échelle des conexions
rayonSpectral = 0.97;
W = normRayonSpectral(W,rayonSpectral);

if ~exist('gainIn','var')
    gainIn = 0.5; % Gain d'entrée
end
W_in = gainIn*W_in;

if ~exist('gainFb','var')
    gainFb = 0.5; % Gain de retour
end
W_fb = gainFb*W_fb;

%% 4 - Paramètres d'entraînement
if ~exist('delta','var')
    delta = 1;    
end
if ~exist('C','var')
    C = 0.44; % Constante globale    
end
if ~exist('a','var')
    a = 0.9; % Leak
end
if ~exist('LvlNoise','var')
    LvlNoise = 10^-6; % Niveau de bruit
end
ridge = 0; % Méthode d'inversion de la matrice de corrélation
f_RC = 'tanh'; % Fonction du réservoir