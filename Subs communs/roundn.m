% Arrondi d'un réel conservant n décimales
% *******************************************

function x = roundn(x,n)

x = round(10^n*x)/10^n;