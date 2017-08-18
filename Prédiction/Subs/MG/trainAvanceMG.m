% Apprentissage du comportement d'un système chaotique par ESN
% ************************************************************

% Entraînement avancé
% -------------------

disp('Entraînement avancé');

%% 1 - Paramètres d'entraînement
%% 1.1 - Méthode d'inversion de la matrice de corrélation
ridge = 0;

%% 1.2 - Définitions des différentes périodes
transient = 1000; % Fin du transient

trainEnd = T - 500; % Fin de la séquence d'apprentissage
trainSeq = transient+1:trainEnd; % Séquence d'apprentissage

testEnd = trainEnd+84;
testSeq = trainEnd:testEnd; % Séquence de test pour NRMSE

%% 1.3 - Fonctions d'activation u et d'apprentissage forcé y
u = 0.2*ones(K,T+1);
y = Cible(trainSeq); % Ne sert que pour les graphes et W_out

%% 1.4 - Autres
delta = 1;
C = 0.44; % Constante globale
a = 0.9; % Leak
noise = zeros(1,T);

f_RC = 'tanh';

%% 1.4 - Etat initial du réservoir
x = zeros(N,1);
S = zeros(T,N+K); S(1,:) = [x' u(:,1)];

%% 2 - Entraînement de base
disp(['Apprentissage : n = ',num2str(1)]);
for t = 1:trainEnd
    x1 = (1 - delta*C*a)*x;    x2 = W_in*u(:,t+1) + W*x + W_fb*Cible(t);
    x = x1 + delta*C*feval(f_RC,x2 + noise(t));
    S(t+1,:) = [x' u(:,t+1)];    
end

%% 3 - Calcul des W_out
disp(['Calcul des poids de sortie : n = ',num2str(1)]);
R = S(trainSeq,:)'*S(trainSeq,:); % Corrélation
P = y'*S(trainSeq,:); % Corrélation croisée

if ridge == 0
    W_out = P*pinv(R);
else
    W_out = P*(R + ridge*speye(size(R)))^-1;
end

clearvars R P;

%% 4 - Entraînement avancé
%% 4.1 - Nouvelle cible
imax = 2; % >= 2
NewCible = [Cible(1:trainEnd) zeros(trainEnd,imax-1)];

for i = 2:imax
    NewCible(1,i) = NewCible(1,i-1);
    x = zeros(N,1);
    S(1,:) = [x' u(:,1)];
    for t = 1:trainEnd
        x1 = (1 - delta*C*a)*x;    x2 = W_in*u(:,t+1) + W*x + W_fb*NewCible(t,i-1);
        x = x1 + delta*C*feval(f_RC,x2 + noise(t));  
        S(t+1,:) = [x' u(:,t+1)]; 

       NewCible(t+1,i) = W_out*S(t+1,:)';
    end

    Newy = NewCible(trainSeq,i);

    %% 4.2 - Apprentissage avancé
    disp(['Apprentissage : n = ',num2str(i)]);
    x = zeros(N,1);
    S = zeros(T,N+K); S(1,:) = [x' u(:,1)];

    for t = 1:trainEnd
        x1 = (1 - delta*C*a)*x;    x2 = W_in*u(:,t+1) + W*x + W_fb*NewCible(t,i);
        x = x1 + delta*C*feval(f_RC,x2 + noise(t));  
        S(t+1,:) = [x' u(:,t+1)];
    end

    %% 4.3 - Calcul des W_out et de la sortie
    disp(['Calcul des poids de sortie : n = ',num2str(i)]);
    R = S(trainSeq,:)'*S(trainSeq,:); % Corrélation
    P = Newy'*S(trainSeq,:); % Corrélation croisée

    if ridge == 0
        W_out = P*pinv(R);
    else
        W_out = P*(R + ridge*speye(size(R)))^-1;
    end

    clearvars R P;
end
y_train = [zeros(1,transient) W_out*S(trainSeq,:)'];

%% 5 - Evolution autonome
disp('Evolution autonome');
y_hat = [y_train zeros(1,T-trainEnd+1)];

clearvars y_train;

for t = trainEnd+1:T  
    y_hat(t) = W_out*S(t,:)';
    x1 = (1 - delta*C*a)*x;    x2 = W_in*u(:,t+1) + W*x + W_fb*y_hat(t);
    x = x1 + delta*C*feval(f_RC,x2 + noise(:,t));
    S(t+1,:) = [x' u(:,t+1)];
end

%% 6 - Traitement des données pour MG
Cible = atanh(Cible) + 1;
NewCible = atanh(NewCible) + 1;
y = atanh(y) + 1;
y_hat = atanh(y_hat) + 1;

clearvars t x1 x2 x;
