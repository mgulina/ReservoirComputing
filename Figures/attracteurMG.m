clearvars; clc;

T_tot = 3000;
T_in = 50;
tau = 17;
ChangeScaleMG = 0;
CI = 0.5;
h = 0.1;

sol = dde23(@equationMG,tau,CI,[0, T_tot]);

t_int = T_in+tau:h:T_tot;
x = deval(sol,t_int);
xlag = deval(sol,t_int - tau);
plot(x,xlag,'b','LineWidth',1);
set(gca,'FontSize',17);
% title('')
xlabel('y(t)','FontSize',20);
ylabel('y(t-\tau)','FontSize',20);
% axis([0 1.5 0 1.5])
axis square;

% % CibleMG
% cibleMG_RK4;
% t_int = T_in+tau:h:T_tot;
% % X = deval(solMG,t_int);
% % Xlag = deval(solMG,t_int - tau);
% X = Cible(t_int)-1;
% Xlag = Cible(t_int-tau)-1;
% hold on; plot(X,Xlag,'r');