% Equation pour le système de Lorenz
% **********************************

function out = equationLorenz(t,x) %#ok<INUSL>
global sigma r b;
% sigma = 10; r = 28; b = 8/3;
out = zeros(3,1);

out(1) = sigma*(x(2) - x(1));
out(2) = r*x(1) - x(2) - x(1)*x(3);
out(3) = x(1)*x(2) - b*x(3);

end