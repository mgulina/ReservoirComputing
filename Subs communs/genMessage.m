% G�n�rateur de messages al�atoires en binaires
% *********************************************
%
% G�n�re une suite de N bits, chacun �tant r�p�t� bitRepete fois.

function [Message,msgCache,msgClair] = genMessage(bitRepete,N,varargin)

if ~(bitRepete == round(bitRepete)) || bitRepete < 0
    error('La r�p�tition d''un bit doit �tre un naturel.');
end

if mod(N,8) ~= 0 || N < 0
    error('Le nombre de bits doit �tre un multiple positif de 8.');
end

Message = zeros(N*bitRepete,1);
msgCache = zeros(N/8,8);
msgClair = zeros(N/8,1);

L = 0;
for i = 1:N
    bit = randi(2) - 1; % Bit al�atoire
    bits(i) = bit;
    Message(L+1:L+bitRepete) = bit; % R�p�tition sur bitRepete
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