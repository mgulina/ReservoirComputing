% Un pas d'intégration par RK4 du système de Mackey - Glass
% *********************************************************

function out = MG_rk4(h,y,Y_T)

Y = y;              k1 = h*equationMG(0,Y,Y_T);
Y = y + k1/2;       k2 = h*equationMG(0,Y,Y_T);
Y = y + k2/2;       k3 = h*equationMG(0,Y,Y_T);
Y = y + k3;         k4 = h*equationMG(0,Y,Y_T);

out = (y + (1/6)*(k1 + 2*k2 + 2*k3 + k4));

end