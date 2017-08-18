% Filtre en sortie pour Bob
% *************************

function DecryptFiltre = filtreSortieBob(Decrypt,A,bitRepete)
disp('Filtre en sortie');

DecryptFiltre = zeros(size(Decrypt));

for i = 1:bitRepete:length(Decrypt)
    temp = mean(Decrypt(i:i+bitRepete-1));
    if temp < A/2
        DecryptFiltre(i:i+bitRepete-1) = 0;
    else
        DecryptFiltre(i:i+bitRepete-1) = A;
    end
end