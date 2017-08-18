% Générateur de messages aléatoires en binaires
% *********************************************
%
% Génère une suite de N bits, chacun étant répété bitRepete fois.

function [Message,msgCache,msgClair] = genMessage(bitRepete,N,varargin)

if ~(bitRepete == round(bitRepete)) || bitRepete < 0
    error('La répétition d''un bit doit être un naturel.');
end

if mod(N,8) ~= 0 || N < 0
    error('Le nombre de bits doit être un multiple positif de 8.');
end

Message = zeros(N*bitRepete,1);
msgCache = zeros(N/8,8);
msgClair = zeros(N/8,1);

L = 0;
for i = 1:N
    bit = randi(2) - 1; % Bit aléatoire
    bits(i) = bit;
    Message(L+1:L+bitRepete) = bit; % Répétition sur bitRepete
    L = L + bitRepete;
end

j = 1;
for i = 1:N/8
    msgCache(i,1:8) = bits(j:j+7);
    j = j+8;
end

for i = 1:N/8
    msgClair(i) = bin2dec(num2str(msgCache(i,:)));
end
msgClair = char(msgClair)';

end