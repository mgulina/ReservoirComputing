% Classification de signaux carr�s et sinuso�daux
% ***********************************************

% Arrondir les valeurs de y_hat avant de les r�injecter pour �valuer
% les suivantes --> classification parfaite.

disp('Entra�nement');

%% 1 - D�finitions des diff�rentes s�quences
transient = 1000; % Fin du transient
trainEnd = T - 1000; % Fin de la s�quence d'apprentissage
test84 = trainEnd+1 + 84;

trainSeq = transient+1:trainEnd; % S�quence d'apprentissage
libreSeq = trainEnd+1:T; % S�quence d'�volution libre

%% 2 - Evolution des �tats internes
S = zeros(T,N+K); S(1,:) = [zeros(N,1)' u(:,1)]; % Etat initial du r�servoir

for t = 1:trainEnd
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',u(:,t+1),Cible(t),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end

%% 3 - Calcul des W_out et de la sortie
disp('Calcul des poids de sortie');
W_out = calcPoidsSortie(S(trainSeq,:),Cible(trainSeq),ridge);
y_train = [zeros(1,transient) W_out*S(trainSeq,:)'];

%% 4 - Evolution autonome
disp('Evolution autonome');
y_hat = [round(y_train) zeros(1,T-trainEnd)];

clearvars y_train;

for t = trainEnd+1:T-1
    y_hat(t) = round(W_out*S(t,:)');
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',u(:,t+1),y_hat(t),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));     
end
y_hat(T) = round(W_out*S(T,:)');