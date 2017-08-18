% Fonctions d'activation et fonction cible pour l'�galiseur de canaux
% ******************************************************************

disp('Fonctions d''activation et fonction cible');

%% 1 - S�quence � moduler
%% 1.1 - Param�tre temporel
T = 1000 + 5000 + 10^6; % transient + trainSeq + testSeq
T_out = 1:T;

%% 1.2 - D�pendance de q : de d(t - lag) jusqu'� d(t + d�lai)
delai = 2; 
lag = 7;

%% 1.3 - G�n�ration de la s�quence al�atoire
disp('G�n�ration de la s�quence al�atoire');
d = full(genPoids([-3 -1 1 3],[0.25 0.25 0.25 0.25],1,T+delai+lag));

%% 2 - Modulation sous bruit blanc contr�l�
%% 2.1 - Rapport du signal au bruit final
snrFin = 32;

%% 2.2 - Modulation
disp('Modulation');
q = zeros(T+lag,1);
u = zeros(T+lag,1);
noise = normrnd(0,5,T+lag,1);

for t = (1:T)+lag
    q(t-lag) = 0.08*d(t+2) - 0.12*d(t+1) + d(t) + 0.18*d(t-1) - 0.1*d(t-2) ...
    + 0.091*d(t-3) - 0.05*d(t-4) + 0.04*d(t-5) + 0.03*d(t-6) + 0.01*d(t-7);

    u(t-lag) = q(t-lag) + 0.036*q(t-lag)^2 - 0.011*q(t-lag)^3;

%     if rem(t,round(T/10)) == 0
%         clc;
%         disp([num2str(100*(t+lag)/(T+lag)),' %']);
%     end
end
clc;
snr = 10*log10(mean(u)^2/mean(noise)^2);

%% 2.3 - Mise � jour du rapport de signal au bruit
factMaj = 1/10^((snrFin-snr)/(20));
noise = factMaj*noise;

%% 2.4 - Signal bruit�
u = u + noise + 30;

clear t snr;