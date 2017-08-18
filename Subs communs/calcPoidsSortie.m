% Calcul des W_out
% ****************

function W_out = calcPoidsSortie(S,y,ridge)

R = S'*S; % Corr�lation
P = y'*S; % Corr�lation crois�e

if ridge == 0
    W_out = P*pinv(R);
else
    W_out = P*(R + ridge*speye(size(R)))^-1;
end

% keyboard;