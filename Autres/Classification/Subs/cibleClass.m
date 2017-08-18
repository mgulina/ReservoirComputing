% Fonction d'activation et cible pour la classification de signal
% ***************************************************************

disp('Fonction cible');

periode = 20;
nbrPeriode = 150;

[Cible,u] = genFctPer(periode,nbrPeriode,'Alternée');

T_tot = periode*nbrPeriode;
T_out = (1:T_tot);
T = length(T_out);

figCible = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Fonction d''entrée et fonction d''apprentissage',...
        'Visible','Off');
    
plot(u,'b','LineWidth',2); hold on;
plot(Cible,'r','LineWidth',2);
xlabel('t [s]','FontSize',20);
xlim([0 15*periode]); ylim([-1.1 1.1]);
set(gca,'FontSize',20);