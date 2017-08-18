% Test du caractère chaotique d'un réservoir entraîné
% ***************************************************

%% 1 - Initialisation
%% 1.1 - Récupération de l'état final du RC
s = S(end,:);

%% 1.2 - Perturbation du système
Tc = round(317/h);
T1 = round(201/h);
T2 = round(301/h);
subT = round(16/h);

Spure = zeros(Tc,N+K); Spure(1,:) = s;
Sperturbe = Spure;
Sperturbe(1,1:N) = Sperturbe(1,1:N) + unifrnd(0,10^-7);

%% 2 - Evolution des systèmes
nmax = 1;
lambdaRC = 0;
hw = waitbar(0,'Calculs en cours. Veuillez patienter...');
set(findobj(hw,'type','patch'),'EdgeColor','k','FaceColor','b');
for n = 1:nmax
    pure = zeros(Tc,1);
    perturbe = zeros(Tc,1);

    
    for t = 1:Tc
        %% 2.1 - Système pure
        pure(t) = W_out*Spure(t,:)';    
        Spure(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,Spure(t,1:N)',...
                          u,pure(t),unifrnd(-LvlNoise,LvlNoise,N,1));

        %% 2.2 - Système perturbé
        perturbe(t) = W_out*Sperturbe(t,:)';    
        Sperturbe(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,Sperturbe(t,1:N)',...
                          u,perturbe(t),unifrnd(-LvlNoise,LvlNoise,N,1));                  
    end
    ecart = abs(pure - perturbe);

    d1 = norm(pure(T1:T1+subT) - perturbe(T1:T1+subT));
    d2 = norm(pure(T2:T2+subT) - perturbe(T2:T2+subT));
    lambdaRC = lambdaRC + log(d2/d1)/(T2-T1);
    
    waitbar(n/nmax,hw);
end
close(hw); pause(10^-1);
lambdaRC = lambdaRC/nmax;

%% 3 - Affichage
figChaos = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Test du caractère chaotique du réservoir entraîné',...
        'Visible','Off');
    
subplot(211);
    plot(ecart,'b');
    title('Evolution de l''écart')
    xlabel('Pas');
    

subplot(212);
    plot(pure,'b-x');hold on;
    plot(perturbe,'r-o');
    title('Comparaison de l''évolution des systèmes')
    legend('Système pure','Système perturbé','Location','SouthEast');
    xlabel('Pas');
    
set(figChaos,'visible','on'); pause(10^-1);