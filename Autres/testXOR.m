clc;

u = [0 1 0 1;0 0 1 1]
Win = [1 0;1 1; 0 1]
Wout = [-1 2 -1]
x = Win*u
y = mod(Wout*x,2)