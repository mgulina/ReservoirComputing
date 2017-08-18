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
zB = [p*rand + q*(zA(1)) zeros(1,T-1)];

%% 1.2 - Verrouillage
for t = 1:T-1
    if T_out(t) < tau
        Y_T = zB(1);
    else
        Y_T = zB(t-round(tau/h)); 
    end
    
    if t < nbrBitLock*bitRepete            
        zB(t+1) = p*MG_rk4(h,zB(t),Y_T) + q*(Crypt(t+1));
    else
        zB(t+1) = MG_rk4(h,zB(t),Y_T);
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