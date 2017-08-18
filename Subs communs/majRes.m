% Mise à jour de l'état du réservoir
% **********************************
%
% Entrées :
% ---------
% f_RC : Fonction non-linéaire du réservoir
% delta : Pas du réservoir
% leak : Taux de fuite
% C : Constante de temps globale
% W_in : Masque d'entrée
% W : Connexions internes
% W_fb : Poids de retour
% x : Etat courant du réservoir --> x(n)
% u : Fonction d'activation --> u(n+1)
% y : Fonction de retour ou "professeur"  --> y(n)
% bruit : Bruit pendant l'entraînement
%
% Sortie :
% --------
% S : Etat généralisé du réservoir mis à jour

function S = majRes(f_RC,delta,leak,C,W_in,W,W_fb,x,u,y,bruit)

x = (1 - delta*C*leak)*x ...
    + delta*C*feval(f_RC, W_in*u + W*x + W_fb*y + bruit);

S = [x ; u]';