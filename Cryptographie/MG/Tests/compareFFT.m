% Comparaison entre la transformée de Fourier d'un Mackey - Glass pur
% et d'un Mackey - Glass porteur d'un message binaire.

%% 1 - Initialisation
%% 1.1 - Message
bitRepete = 1; % Estimation en secondes de la période du MG2
nbrBit = 10000;   % Nombre de bit composant le message
A = 1;          % Amplitude
Message = genMessage(bitRepete,nbrBit).*A;

%% 1.2 - Mackey - Glass
h = 0.5; T_tot = (length(Message) - 1)*h;
CibleMG;

%% 2 - Calcul des Tranformées de Fourier
CibleMGCrypto = Cible + Message;
[f_cible,p_cible] = TF(T_out,Cible);
[f_crypt,p_crypt] = TF(T_out,CibleMGCrypto);

%% 3 - Sortie Graphique
figCryptoFFT = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Entraînement du réservoir',...
        'Visible','Off');
plot(f_cible,p_cible,'b'); hold on;
plot(f_crypt,p_crypt,'r');
xlabel('f [Hz]'); xlim([0 0.15]);
title('Comparaison des transformées de Fourier');
legend('MG pur','MG crypté','Location','Best');
set(figCryptoFFT,'visible','on'); pause(10^-1);