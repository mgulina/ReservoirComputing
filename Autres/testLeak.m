clear; clc; %close all;

T_tot = 10;
h = 0.01;
tau = 10;
A = 2;
x0 = 0;
C1 = 1;
C2 = 0;

T_out = 0:h:T_tot;
T = round(T_tot/h);

x = zeros(1,T); x(1) = x0;
X = x;

% Différences finies
for n = 1:T
    if n*h < tau
        C = C1;
    else
        C = C2;
    end
    x(n+1) = x(n) + h*(C-A*x(n));
end

% % Solution exacte
% drap = 0;
% for n = 2:T+1
%     t = n*h;
%     if t < tau
%         C = C1;
%         X(n) = C/A*(1 - exp(-A*t)) + x0*exp(-A*t);
%     else
%         if drap == 0
%             x1 = X(n-1); drap = 1;
%         end
%         C = C2;
%         X(n) =  C/A*(1 - exp(-A*(t-tau))) + x1*exp(-A*(t-tau));
%     end
% end

plot(T_out,x,'b','LineWidth',2); hold on;
% axis square;
% plot(T_out,X,'r');