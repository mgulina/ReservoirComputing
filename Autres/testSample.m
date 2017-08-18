max = 10;
n = 30;
x = linspace(0,max,n);
y = sin(x);

N = 2;
X = linspace(0,max,N*n);
Y = interp1(x,y,X,'spline');

t = linspace(0,max,max*1000);
f = sin(t);
plot(x,y,'bx'); hold on;
plot(X,Y,'ro');
plot(t,f,'g');