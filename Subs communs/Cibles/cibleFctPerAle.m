% Fonction cible p�riodique al�atoirement g�n�r�e
% ************************************************

disp('Fonction cible');

periode = 100;
nbrPeriode = 30;

Cible = genFctPer(periode,nbrPeriode,'Al�atoire');

T_tot = periode*nbrPeriode;
T_out = (0:T_tot-1);
T = length(T_out);