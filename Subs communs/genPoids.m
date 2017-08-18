% Générateur de poids 
% *******************
%
% Génère une matrice m X n où un élément prend sa valeur dans le 
% vecteur poids avec la probabilité associée dans proba.

function W = genPoids(poids,proba,m,n)

%% 1 - Initialisation
if sum(proba) ~= 1
    error('Les probabilités ne sommes pas à 1.');
end

P = length(proba);
if P ~= length(poids)
    error('Nombre de probabilités inconsistant avec le nombre de poids.');
end

W = zeros(m,n);

%% 2 - Nombre de décimales maximal dans le vecteur de probabilités
log = cell(P,1);
posVirgule = zeros(P,1);
nbrDecimale = zeros(P,1);

for i = 1:P
    log{i} = num2str(proba(i)) == '.';
    posVirgule(i) = find(log{i});
    nbrDecimale(i) = length(num2str(proba(i))) - posVirgule(i);
end
N = max(nbrDecimale);

%% 3 - Génération des poids
%% 3.1 - Vecteur de choix
Choix = zeros(1,10^N);
L1 = 1;
for i = 1:P
   L2 = L1 + proba(i)*10^N;
   Choix(L1:L2) = i;
   L1 = L2;
end

%% 3.2 - Choix des poids générés
for j = 1:n
    for i = 1:m
        W(i,j) = poids(Choix(randi(10^N)));        
    end
end

W = sparse(W);
end