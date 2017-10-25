 %% 1 - Erreurs
EA_lock = abs(lock-primaire);
ER_lock = EA_lock./abs(primaire);
  
% On calcule la MSE à partir du premier minimum de l'erreur absolue
T_locked = find(EA_lock == min(EA_lock),1);
lockSeq = T_locked:T;
mse_lock = mean(EA_lock(lockSeq).^2);

log10_mse_lock = log10(mse_lock) %#ok<*NOPTS>

if calcMSE
    tMSE = 1:nMSE:T;
    EA = cell(length(tMSE),1);
    ER = cell(length(tMSE),1);
    mse = zeros(length(tMSE),1);
    nrmse = zeros(length(tMSE),1); 
    for i = 1:length(tMSE)-1
        EA{i} = abs(primaire(tMSE(i):tMSE(i+1)) - lock(tMSE(i):tMSE(i+1)));
        ER{i} = EA{i}./abs(primaire(tMSE(i):tMSE(i+1)));
        mse(i) = sqrt(mean(EA{i}.^2));
        nrmse(i) = mse(i)/(max(primaire(tMSE(i):tMSE(i+1))) - min(primaire(tMSE(i):tMSE(i+1))));
    end
end

%% 2 - Affichage
subplot(211); hold on;
    plot(T_out,primaire,'b-x','LineWidth',trait); 
    plot(T_out,lock,'r-o','LineWidth',trait);
%     plot(T_out,unlock,'k','LineWidth',trait);

    title('Evolution of the systems','FontSize',texte);
    xlabel('$t [AU]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    
%     legend('Primaire','Verrouillé','Non verrouillé',...
%         'Location','SouthEast');
    legend('Primary','Locked',...
        'Location','SouthEast');
    
    plot([T_lock T_lock],get(gca,'ylim'),'m','LineWidth',trait);
    plot([T_libre T_libre],get(gca,'ylim'),'m','LineWidth',trait);
    set(gca,'FontSize',texte);
    axis tight;

subplot(212); hold on;
    if ~calcMSE
        plot(T_out,log10(ER_lock),'g-*','LineWidth',trait); hold on;
    %     plot(T_out,EA_lock,'b-*','LineWidth',trait);
    
    %     title('Evolution de l''erreur relative entre le primaire et le verrouillé','FontSize',texte);
        title('Logarithmic evolution of the relative error','FontSize',texte);
        xlabel('$t [AU]$','FontSize',texte,'Interpreter','Latex');
        ylabel('$\mathcal{R}$','FontSize',texte,'Interpreter','Latex');
        
    %     legend('Log de l''erreur relative','Erreur absolue',...
    %         'Location','SouthEast');
    
        plot([T_lock T_lock],get(gca,'ylim'),'m','LineWidth',trait);
        plot([T_libre T_libre],get(gca,'ylim'),'m','LineWidth',trait);
        
        set(gca,'FontSize',texte);
        axis tight;
    else
        plot(T_out(tMSE),log10(nrmse),'g-*','LineWidth',trait); hold on;
        
        title('Logarithmic evolution of the NRMSE','FontSize',texte);
        xlabel('$t [AU]$','FontSize',texte,'Interpreter','Latex');
        ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
        
        plot([T_lock T_lock],get(gca,'ylim'),'m','LineWidth',trait);
        plot([T_libre T_libre],get(gca,'ylim'),'m','LineWidth',trait);
        
        set(gca,'FontSize',texte); 
        axis tight;
    end