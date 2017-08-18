% Cryptographie chaotique
% ***********************
%
% Superposition : Eve (avec un exemple)
% -------------------------------------

disp('Eve');

%% 1 - Entraînement du réservoir
%% 1.1 - Création du message connu
messageTrain = genMessage(bitRepete,nbrBitTrain).*A;

%% 1.2 - Signal porteur du message connu
T_tot = (length(messageTrain) - 1)*h;
CI = rand; 
cibleMG;

%% 1.3 - Séparation du signal porteur et du message connu
gainFb = 0;
genResMG;
% if Q ~= 1
%     interpT_out = linspace(0,T_tot,Q*length(T_out));
%     interpT = Q*length(T_out);
% end

u = Cible' + messageTrain' + unifrnd(-A_eps,A_eps,size(Cible'));

% if Q ~= 1
%     u = interp1(T_out,u,interpT_out,'spline'); %#ok<*NASGU>
%     Cible = interp1(T_out,Cible,interpT_out,'spline')';
% 
%     T_out = interpT_out; T = length(T_out);
% end

transient = 500;   trainEnd = T-1;     test84 = T;     fullTrain = 1;
trainSimpleMG;
calcErreursTrain;

%% 2 - Décryptage
disp('Décryptage');

T_tot = (length(Crypt) - 1)*h; T_out = 0:h:T_tot; T = length(T_out);

% if Q ~= 1
%     interpT_out = linspace(0,T_tot,Q*length(T_out));
%     interpCrypt = interp1(T_out,Crypt,interpT_out,'spline');
% 
%     T_tot = (length(interpCrypt) - 1)*h; T_out = interpT_out; T = length(T_out);
%     u = interpCrypt;
% else 
    u = Crypt;
%     interpT_out = T_out;
% end

S = zeros(T,N+K); S(1,:) = [zeros(N,1) ; u(:,1)]';
for t = 1:T-1
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,0,...
                      S(t,1:N)', u(:,t+1), 0,...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end

% if Q ~= 1
%     Crack = interpCrypt - W_out*S';
% else
    Crack = Crypt - W_out*S';
% end

%% 3 - Filtre en sortie
% M = mean(Crack(Q*150:end));
% M = mean(Crack(150:end));
M = A/2;
% CrackFiltre = filtreSortieEve(Crack,M,Q*bitRepete);
CrackFiltre = filtreSortieEve(Crack,M,bitRepete);
CrackFiltre(CrackFiltre == 1) = A;

%% 4 - Calcul d'erreur et affichage
calcErreurCrack;