 %% 1 - Erreurs
EA_lock = abs(lock-primaire);
ER_lock = EA_lock./abs(primaire);

% On calcule la MSE à partir du premier minimum de l'erreur absolue
T_lock = find(EA_lock == min(EA_lock),1);
lockSeq = T_lock:T;
mse_lock = mean(EA_lock(lockSeq).^2);

log10_mse_lock = log10(mse_lock) %#ok<*NOPTS>

%% 2 - Affichage
subplot(211); hold on;
    plot(T_out,primaire,'b-x','LineWidth',trait); 
    plot(T_out,lock,'r-o','LineWidth',trait);
    plot(T_out,unlock,'k','LineWidth',trait);
    title('Comparaison de l''évolution des systèmes','FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    legend('Primaire','Verrouillé','Non verrouillé',...
        'Location','SouthEast');
    set(gca,'FontSize',texte);

subplot(212); hold on;
    plot(T_out,log10(ER_lock),'g-*','LineWidth',trait); hold on;
    plot(T_out,EA_lock,'b-*','LineWidth',trait);
    title('Evolution de l''erreur relative entre le primaire et le verrouillé','FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$\mathcal{R}$','FontSize',texte,'Interpreter','Latex');
    legend('Log de l''erreur relative','Erreur absolue',...
        'Location','SouthEast');
    set(gca,'FontSize',texte);