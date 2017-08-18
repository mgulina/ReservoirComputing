% Synchronisation de systèmes de Lorenz
% -------------------------------------

clear; clc; close all;

%% 1 - Initialisation
global sigma r b;
sigma = 16; r = 45.6; b = 4;

T_tot = 10;
CI = rand(1,3);
h = 0.0001;

T_out = 0:h:T_tot;
T = length(T_out);

%% 2 - Signal pilote
options_ode45 = odeset('AbsTol',eps);
Lorenz = ode45(@equationLorenz,[0 T_tot], CI, options_ode45);

Cible = deval(Lorenz,T_out)';

u = Cible(:,1)./10;
v = Cible(:,2)./10;
w = Cible(:,3)./20;

%% 3 - Synchronisation
disp('Synchronisation');
u_r = zeros(T,1); v_r = zeros(T,1); w_r = zeros(T,1);
A = 0.005;

% m = A*(randi(2,T,1)-1);

B = 3;
fc = 3*10^3;
fm = 10^2;
[m,~] = genSinus('Modulation',B,fc,fm,h,T_tot);
m = A*m;

s = u + m;

for t = 1:T-1
    u_r(t+1) = u_r(t) + h*(sigma*(v_r(t) - u_r(t)));
    v_r(t+1) = v_r(t) + h*(r*s(t) - v_r(t) - 20*s(t)*w_r(t));
    w_r(t+1) = w_r(t) + h*(5*s(t)*v_r(t) - b*w_r(t));
end

%% 4 - Décryptage
disp('Décryptage');

mPrime = s - u_r;

[f,p_m] = tfPerso(T_out,m);
[~,p_mPrime] = tfPerso(T_out,mPrime);

% fmin = find(f <= 15, 1, 'last' );
% p_mPrime(1:fmin) = 0;

% [T_out2,mPrime] = tfPerso(f,p_mPrime);
%% 5 - Sorties graphiques
clc;

figErreurLorenz = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Synchronisation de système de Lorenz',...
        'Visible','Off');
    
U = [min(u) max(u)]; V = [min(v) max(v)]; W = [min(w) max(w)]; 

subplot(3,3,1);
    plot(T_out,u,'b-o'); hold on;
    plot(T_out,u_r,'r-x');
    xlabel('t');
    title('Synchronisation sur la composante x');
    legend('Primaire','Synchronisé',...
        'Location','NorthEast');
    
subplot(3,3,4);
    line(U,U,'Color','r','LineWidth',2); hold on;
    plot(u,u_r,'g--');
    xlabel('u');
    ylabel('u_r');

subplot(3,3,7);
    semilogy(T_out,abs(u_r-u)./abs(u),'g');
    title('Evolution de l''erreur relative sur la composante x');
    xlabel('t');
    
subplot(3,3,2);
    plot(T_out,v,'b-o'); hold on;
    plot(T_out,v_r,'r-x');
    xlabel('t');
    title('Synchronisation sur la composante y');
    legend('Primaire','Synchronisé',...
        'Location','NorthEast');
    
subplot(3,3,5);
    line(V,V,'Color','r','LineWidth',2); hold on;
    plot(v,v_r,'g--');
    xlabel('v');
    ylabel('v_r');

subplot(3,3,8);
    semilogy(T_out,abs(v_r-v)./abs(v),'g');
    title('Evolution de l''erreur relative sur la composante y');
    xlabel('t');
    
subplot(3,3,3);   
    plot(T_out,w,'b-o'); hold on;
    plot(T_out,w_r,'r-x');
    xlabel('t');
    title('Synchronisation sur la composante z');
    legend('Primaire','Synchronisé',...
        'Location','NorthEast');
    
subplot(3,3,6);
    line(W,W,'Color','r','LineWidth',2); hold on;
    plot(w,w_r,'g--');
    xlabel('w');
    ylabel('w_r');

subplot(3,3,9);
    semilogy(T_out,abs(w_r-w)./abs(w),'g');
    title('Evolution de l''erreur relative  sur la composante z');
    xlabel('t');
    
figDecrypt = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Synchronisation de système de Lorenz',...
        'Visible','Off');

subplot(2,1,1);
    plot(T_out, m,'b-o'); hold on;
    plot(T_out, mPrime,'r-x');
        xlabel('t');
    title('Comparaison des messages');
    legend('Original','Décrypté',...
        'Location','NorthEast');
    
subplot(2,1,2);    
    plot(f,p_m,'b-o'); hold on;
    plot(f,p_mPrime,'r-x');
    title('Comparaison des spectres des messages');
    legend('Original','Décrypté',...
        'Location','NorthEast');
%     xlim([0,fc+5*fm]);
    
set(figErreurLorenz,'Visible','On');
set(figDecrypt,'Visible','On');