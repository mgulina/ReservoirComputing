% Arrondi d'un r�el conservant n d�cimales
% *******************************************

function x = roundn(x,n)

x = round(10^n*x)/10^n;