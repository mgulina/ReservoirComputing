% Fonction cible périodique aléatoirement générée
% ************************************************

disp('Fonction cible');

periode = 100;
nbrPeriode = 30;

Cible = genFctPer(periode,nbrPeriode,'Aléatoire');

T_tot = periode*nbrPeriode;
T_out = (0:T_tot-1);
T = length(T_out);