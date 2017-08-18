% Source pour le système de Mackey - Glass
% ******************************************

function out = sourceMG(x_tau)

beta = 0.2; gamma = 0.1; n = 10;

out = beta/gamma*x_tau/(1 + x_tau^n);

end