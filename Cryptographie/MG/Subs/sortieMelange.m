% Cryptographie chaotique
% ***********************

% Traitement du signal en sortie pour le mélange
% ----------------------------------------------

function [z,dot_z] = sortieMelange(x,y,h)
    
    if size(x) ~= size(y)
        y = y';
    end
    
    z = x - y;

    dot_z = zeros(size(z));
    for t = 1:(length(z)-1)
        dot_z(t) = (z(t+1) - z(t))/h;
    end
end