% Filtre en sortie pour le décodage (Eve)
% ***************************************

function DecodeFiltre = filtreSortieEve(Crack,M,bitRepete)
disp('Filtre en sortie');

DecodeFiltre = zeros(size(Crack));
Crack(Crack >= M) = 1;
Crack(Crack < M) = 0;

for i = 1:bitRepete:length(Crack)
    temp = mean(Crack(i:i+bitRepete-1));
    if temp < 1/2
        DecodeFiltre(i:i+bitRepete-1) = 0;
    else
        DecodeFiltre(i:i+bitRepete-1) = 1;
    end
end