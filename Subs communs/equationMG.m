% Equation pour le système de Mackey - Glass
% ******************************************

function out = equationMG(t,x,x_t) %#ok<INUSL>

beta = 0.2; gamma = 0.1; n = 10;

out = beta*x_t./(1 + x_t.^n) - gamma*x;

end