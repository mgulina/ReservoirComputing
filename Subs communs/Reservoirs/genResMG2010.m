% Construction d'un reservoir pour prédire l'évolution d'un MG
% ************************************************************

% Basé sur Jaeger (The “echo state” approach to analysing and training 
% recurrent neural networks 2010)
% -------------------------------------------------------------------

disp('Construction du réservoir');

%% 1 - Dimensions
if ~exist('N','var')
    N = 400; % Nombre de neurones
end
K = 1; % Dimension de l'entrée
L = 1; % Dimension de la sortie

%% 2 - Poids
W = genPoids([0 -0.4 0.4],[0.9875 0.00625 0.00625],N,N); % Conexions internes
W_in = genPoids([0 -0.14 0.14],[0.5 0.25 0.25],N,K); % Masque d'entrée
W_fb = unifrnd(-0.56,0.56,N,L); % Poids du retour
W_out = zeros(L,N+K); % Initialisation des poids de sortie

%% 3 - Mise à l'échelle des connexions
if ~exist('rho','var')
    rho = 0.79; % Rayon spectral final
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
    C = 0.44; % Constante globale    
end
if ~exist('a','var')
    a = 0.9; % Leak
end
if ~exist('LvlNoise','var')
    LvlNoise = 0; % Niveau de bruit
end
ridge = 0; % Méthode d'inversion de la matrice de corrélation
f_RC = 'tanh'; % Fonction du réservoir