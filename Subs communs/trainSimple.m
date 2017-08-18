% Entraînement d'un réservoir
% ***************************

% Version simple
% --------------
 
%% 1 - Entraînement
for t = 1:trainEnd
    U = u(:,t+1);
%     U = 0.2;
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',U,Cible(t),...
                      unifrnd(-LvlNoise,LvlNoise,N,1)); %#ok<*SAGROW>
end

%% 2 - Calcul des W_out et de la sortie
disp('Calcul des poids de sortie');

if ~exist('theta','var')
    theta = 0;
end

W_out = calcPoidsSortie(S(trainSeq,:),Cible(trainSeq+theta),ridge);

%% 3 - Séquence test
disp('Evolution autonome');
y_hat = [W_out*S(1:transient,:)' W_out*S(trainSeq,:)' ...
    zeros(1,T-trainEnd)];

for t = trainEnd+1:T-1
    U = u(:,t+1);   
%     U = 0.2;
    y_hat(t) = W_out*S(t,:)';
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',U,y_hat(t-theta),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end
y_hat(T) = W_out*S(T,:)';

clear U;