% Cryptographie chaotique
% ***********************
% 
% Superposition : Alice
% ---------------------

disp('Alice');

%% 1 - Création du message caché
[Message,msgCache,msgClair] = genMessage(bitRepete,nbrBit);
Message = [zeros(1,nbrBitLock*bitRepete) (Message.*A)'];

%% 2 - Signal porteur et bruit expérimental
T_tot = (length(Message) - 1)*h;
CI = rand; rk4 = 1;
ChangeScaleMG = 0;
cibleMG;

zA = Cible';
if A_eps ~= 0
    bruitCrypt = unifrnd(-A_eps,A_eps,size(zA));
else
    bruitCrypt = 0;
end
%% 3 - Signal final
Crypt = zA + Message + bruitCrypt;