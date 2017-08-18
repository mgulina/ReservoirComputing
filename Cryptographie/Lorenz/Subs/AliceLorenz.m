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

global sigma r b;
% sigma = 16; r = 45.6; b = 4;
sigma = 10; r = 28; b = 8/3;

T_tot = (length(Message) - 1)*h;
CI = rand(1,3);

T_out = 0:h:T_tot;
T = length(T_out);

%% 2 - Signal pilote
% options_ode45 = odeset('AbsTol',eps);
% Lorenz = ode45(@equationLorenz,[0 T_tot], CI, options_ode45);

% Cible = deval(Lorenz,T_out)';

Cible = zeros(T,3);
Cible(1,:) = CI;
for t = 1:T-1
    Cible(t+1,:) = Lorenz_rk4(h,Cible(t,:));
end

% u = Cible(:,1)./10;
% v = Cible(:,2)./10;
% w = Cible(:,3)./20;

zA = Cible(:,1)';
if A_eps ~= 0
    bruitCrypt = unifrnd(-A_eps,A_eps,size(zA));
else
    bruitCrypt = 0;
end
%% 3 - Signal final
Crypt = zA + Message + bruitCrypt;