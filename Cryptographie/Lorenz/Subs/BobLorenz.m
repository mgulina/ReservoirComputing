% Cryptographie chaotique
% ***********************
% 
% Superposition : Bob
% -------------------

disp('Bob');

%% 1 - Verrouillage du système de Bob sur celui de Alice 
%% 1.1 - Initialisation
% Paramètres
q = 0.95;               % Parfait à eps près pour q >= 0.25
p = 1-q;                % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

% Initialisation du système de Bob
zB = [p*rand + q*(Crypt(1)) zeros(1,T-1)];
vR = 0; wR = 0;

%% 1.2 - Verrouillage
for t = 1:T-1
    
    LorenzR = Lorenz_rk4(h,[zB(t),vR,wR]);
    uR = LorenzR(1); vR = LorenzR(2); wR = LorenzR(3);
        
    if t < nbrBitLock*bitRepete
        zB(t+1) = p*uR + q*(Crypt(t+1));
        if lock3d
            vR = p*vR + q*Cible(t+1,2);
            wR = p*wR + q*Cible(t+1,3);
        end
    else
        zB(t+1) = uR;
    end
end

EA_lock = abs(zB-zA);
ER_lock = EA_lock./abs(zA);

%% 2 - Décryptage
Decrypt = Crypt - zB;
Decrypt(1:nbrBitLock*bitRepete) = 0;
DecryptFiltre = filtreSortieBob(Decrypt,A,bitRepete);

%% 3 - Calcul d'erreur et affichage
calcErreurDecrypt;