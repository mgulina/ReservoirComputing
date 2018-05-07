% Construction d'un reservoir pour pr�dire l'�volution d'un MG
% ************************************************************

disp('Construction du r�servoir');

%% 1 - Dimensions
if ~exist('N','var')
    N = 1500; % Nombre de neurones
end
K = 1; % Dimension de l'entr�e
L = 1; % Dimension du retour

%% 2 - Poids
if ~exist('gamma','var')
    gamma = 0.01; % Connectivit�
end

W = sprand(N,N,gamma); W = spfun(@minusPoint5,W); % Conexions internes
W_in = unifrnd(-1,1,N,K); % Masque d'entr�e
W_fb = unifrnd(-1,1,N,L); % Poids du retour
W_out = zeros(L,N+K); % Initialisation des poids de sortie

%% 3 - Mise � l'�chelle des connexions
if ~exist('rho','var')
    rho = 0.79; % Rayon spectral final
end
W = normRayonSpectral(W,rho);

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
    C = 0.44; % Constante globale    
end
if ~exist('a','var')
    a = 0.9; % Leak
end
if ~exist('LvlNoise','var')
    LvlNoise = 0; % Niveau de bruit
end
ridge = 0; % M�thode d'inversion de la matrice de corr�lation
f_RC = 'tanh'; % Fonction du r�servoir

esn_check = abs(1 - delta*C*(a - rho));