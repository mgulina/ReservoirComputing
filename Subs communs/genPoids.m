% G�n�rateur de poids 
% *******************
%
% G�n�re une matrice m X n o� un �l�ment prend sa valeur dans le 
% vecteur poids avec la probabilit� associ�e dans proba.

function W = genPoids(poids,proba,m,n)

%% 1 - Initialisation
if sum(proba) ~= 1
    error('Les probabilit�s ne sommes pas � 1.');
end

P = length(proba);
if P ~= length(poids)
    error('Nombre de probabilit�s inconsistant avec le nombre de poids.');
end

W = zeros(m,n);

%% 2 - Nombre de d�cimales maximal dans le vecteur de probabilit�s
log = cell(P,1);
posVirgule = zeros(P,1);
nbrDecimale = zeros(P,1);

for i = 1:P
    log{i} = num2str(proba(i)) == '.';
    posVirgule(i) = find(log{i});
    nbrDecimale(i) = length(num2str(proba(i))) - posVirgule(i);
end
N = max(nbrDecimale);

%% 3 - G�n�ration des poids
%% 3.1 - Vecteur de choix
Choix = zeros(1,10^N);
L1 = 1;
for i = 1:P
   L2 = L1 + proba(i)*10^N;
   Choix(L1:L2) = i;
   L1 = L2;
end

%% 3.2 - Choix des poids g�n�r�s
for j = 1:n
    for i = 1:m
        W(i,j) = poids(Choix(randi(10^N)));        
    end
end

W = sparse(W);
end