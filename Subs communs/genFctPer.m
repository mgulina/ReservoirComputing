% Générateur de fonctions périodiques aléatoires
% **********************************************
%
% Aléatoire : f est la fonction cible.
% Alternée  : f est la fonction cible et u la fonction d'activation.

function varargout = genFctPer(periode,nbrPer,type)

if ~(periode == round(periode)) || periode < 0
    error('La période doit être un naturel.');
end

if ~(nbrPer == round(nbrPer)) || nbrPer < 0
    error('Le nombre de répétition doit être un naturel.');
end

type = lower(type);

f = zeros(nbrPer*periode,1);

if strcmp(type,'aléatoire')
    % Morceau de longueur periode répété nbrPer fois
    f1 = rand([periode,1]);
    
    L = 0;
    for i = 1:nbrPer
        f(L+1:L+periode) = f1;
        L = L + periode;
    end
    
    varargout = {f};
    
elseif strcmp(type,'alternée')
    % Fonction carrée
    u1 = zeros(periode,1);
    m1 = round(periode/2);
    u1(1:m1) = 1;             u1(m1+1:periode) = -1;
    
    % Sinus
    t = 1:periode;
    u2 = sin(2*pi/periode*t);
    
    L = 0;
    for i = 1:nbrPer
        choix = randi(2); % Choix entre u1 et u2
        if choix == 1
            u(L+1:L+periode) = u1;
            f(L+1:L+periode) = 1;
        else
            u(L+1:L+periode) = u2;
        end
        L = L + periode;
        
        varargout = {f,u}; 
    end
else
    error('Type de fonction inconnu.');
end

end