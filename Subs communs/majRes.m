% Mise � jour de l'�tat du r�servoir
% **********************************
%
% Entr�es :
% ---------
% f_RC : Fonction non-lin�aire du r�servoir
% delta : Pas du r�servoir
% leak : Taux de fuite
% C : Constante de temps globale
% W_in : Masque d'entr�e
% W : Connexions internes
% W_fb : Poids de retour
% x : Etat courant du r�servoir --> x(n)
% u : Fonction d'activation --> u(n+1)
% y : Fonction de retour ou "professeur"  --> y(n)
% bruit : Bruit pendant l'entra�nement
%
% Sortie :
% --------
% S : Etat g�n�ralis� du r�servoir mis � jour

function S = majRes(f_RC,delta,leak,C,W_in,W,W_fb,x,u,y,bruit)

x = (1 - delta*C*leak)*x ...
    + delta*C*feval(f_RC, W_in*u + W*x + W_fb*y + bruit);

S = [x ; u]';