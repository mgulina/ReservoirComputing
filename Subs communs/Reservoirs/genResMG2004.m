% Construction d'un reservoir pour prédire l'évolution d'un MG
% ************************************************************

% Basé sur Jaeger (Harnessing Nonlinearity: Predicting Chaotic Systems 
% and Saving Energy in Wireless Communication 2004)
% --------------------------------------------------------------------

disp('Construction du réservoir');

%% 1 - Dimensions
if ~exist('N','var')
    N = 1000; % Nombre de neurones
end
K = 1; % Dimension de l'entrée
L = 1; % Dimension de la sortie

%% 2 - Poids
W = sprand(N,N,1/100); W = spfun(@minusPoint5,W); % Conexions internes
W_in = unifrnd(-1,1,N,K); % Masque d'entrée
W_fb = unifrnd(-1,1,N,L); % Poids du retour
W_out = zeros(L,N+K); % Initialisation des poids de sortie

%% 3 - Mise à l'échelle des connexions
if ~exist('rho','var')
    rho = 0.8; % Rayon spectral final
end
W = normRayonSpectral(W,rho);

if ~exist('gainIn','var')
    gainIn = 1; % Gain d'entrée
end
W_in = gainIn*W_in;

if ~exist('gainFb','var')
    gainFb = 1; % Gain de retour
end
W_fb = gainFb*W_fb;

%% 4 - Paramètres d'entraînement
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
    LvlNoise = 10^(-10); % Niveau de bruit
end
ridge = 0; % Méthode d'inversion de la matrice de corrélation
f_RC = 'tanh'; % Fonction du réservoir