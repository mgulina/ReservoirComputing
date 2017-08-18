function out = Lorenz_rk4(h,y)

Y = y;              k1 = h*equationLorenz(0,Y)';
Y = y + k1/2;       k2 = h*equationLorenz(0,Y)';
Y = y + k2/2;       k3 = h*equationLorenz(0,Y)';
Y = y + k3;         k4 = h*equationLorenz(0,Y)';

out = (y + (1/6)*(k1 + 2*k2 + 2*k3 + k4));