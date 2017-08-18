% Cryptographie chaotique
% ***********************
% 
% Superposition : Bob
% -------------------

disp('Bob');

%% 1 - Verrouillage du syst�me de Bob sur celui de Alice 
%% 1.1 - Initialisation
% Param�tres
q = 0.95;               % Parfait � eps pr�s pour q >= 0.25
p = 1-q;                % MG'(t) = p*f(MG'(t-tau)) + q*MG(t)

% Initialisation du syst�me de Bob
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

%% 2 - D�cryptage
Decrypt = Crypt - zB;
Decrypt(1:nbrBitLock*bitRepete) = 0;
DecryptFiltre = filtreSortieBob(Decrypt,A,bitRepete);

%% 3 - Calcul d'erreur et affichage
calcErreurDecrypt;