% Calcul des W_out
% ****************

function W_out = calcPoidsSortie(S,y,ridge)

R = S'*S; % Corrélation
P = y'*S; % Corrélation croisée

if ridge == 0
    W_out = P*pinv(R);
else
    W_out = P*(R + ridge*speye(size(R)))^-1;
end

% keyboard;