% Verrouillage de deux systèmes MG avec deux efficacités différentes 
% ******************************************************************

%% 1 - Paramètres
q1 = 0.25;
q2 = 0.75;

%% 2 - Verrouillage
%% 2.1 - Première valeur de q
disp('Verrouillage MG sur MG (1)');
q = q1;
MGLockMG;

primaire1 = primaire;
lock1 = lock;
unlock1 = unlock;
ER_lock1 = ER_lock;
nrmse1 = nrmse;

%% 2.1 - Seconde valeur de q
disp('Verrouillage MG sur MG (2)');
q = q2;
MGLockMG;

primaire2 = primaire;
lock2 = lock;
unlock2 = unlock;
ER_lock2 = ER_lock;
nrmse2 = nrmse;

%% 3 - Comparaison graphique des erreurs
figMGLockMG_compare = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Verrouillage d''un Mackey - Glass sur un autre',...
        'Visible','Off');

if ~calcMSE
    plot(T_out,log10(ER_lock1),'g-*','LineWidth',trait); hold on;
    plot(T_out,log10(ER_lock2),'k-*','LineWidth',trait);

%     title('Evolution de l''erreur relative entre le primaire et le verrouillé','FontSize',texte);
    title('Logarithmic evolution of the relative error','FontSize',texte);
    xlabel('$t [AU]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$\mathcal{R}$','FontSize',texte,'Interpreter','Latex');

    legend(['q = ',num2str(q1)],['q = ',num2str(q2)],...
        'Location','SouthEast');
    
    plot([T_lock T_lock],get(gca,'ylim'),'m','LineWidth',trait);
    plot([T_libre T_libre],get(gca,'ylim'),'m','LineWidth',trait);

    set(gca,'FontSize',texte);
    axis tight;
else
    plot(T_out(tMSE),log10(nrmse1),'g-*','LineWidth',trait); hold on;
    plot(T_out(tMSE),log10(nrmse2),'k-*','LineWidth',trait);
   
    title('Logarithmic evolution of the NRMSE','FontSize',texte);
    xlabel('$t [AU]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');

    legend(['q = ',num2str(q1)],['q = ',num2str(q2)],...
        'Location','SouthEast');
    
    plot([T_lock T_lock],get(gca,'ylim'),'m','LineWidth',trait);
    plot([T_libre T_libre],get(gca,'ylim'),'m','LineWidth',trait);

    set(gca,'FontSize',texte); 
    axis tight;
end
    
set(figMGLockMG_compare,'visible','on')