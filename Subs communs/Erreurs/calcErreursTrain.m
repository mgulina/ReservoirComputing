% Emulation de syst�me chaotique par ESN
% **************************************

% Calcul d'erreurs pour l'entra�nement
% ------------------------------------

if ~exist('fullTrain','var')
    fullTrain = 0;
end

if ~exist('theta','var')
    theta = 0;
end

%% 1 - Erreurs
EA_train = abs(Cible(trainSeq+theta) - y_hat(trainSeq)');
ER_train = 100*EA_train./abs(Cible(trainSeq+theta));
mse_train = mean(EA_train.^2);
log10_mse_train = log10(mse_train) %#ok<*NOPTS>

if ~fullTrain
    EA_libre = abs(Cible(libreSeq(1+theta:T-trainEnd)) - y_hat(libreSeq(1:T-trainEnd-theta))');
    ER_libre = 100*EA_libre./abs(Cible(libreSeq(1+theta:T-trainEnd)));
    mse_libre = mean(EA_libre.^2);

    nrmse84 = sqrt((Cible(test84+theta) - y_hat(test84)).^2 / var(Cible) );

    log10_mse_libre = log10(mse_libre)
    log10_nrmse84 = log10(nrmse84)
end

%% 2 - Affichage
figErreurRC = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Entra�nement du r�servoir',...
        'Visible','Off');

if fullTrain    
    subplot(211); %#ok<*UNRCH>
else
    subplot(221);
end
    plot(T_out(trainSeq),Cible(trainSeq),'b-o','LineWidth',trait); hold on; 
    plot(T_out(trainSeq),y_hat(trainSeq),'r-x','LineWidth',trait);
    title('Comparaison entre fonction cible (bleu) et entra�n�e (rouge)',...
        'FontSize',texte);
%     legend('Fonction cible','Fonction entra�n�e','Location','Best');
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim([T_out(transient) T_out(trainEnd)]);
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    set(gca,'FontSize',texte);
    
if ~fullTrain    
subplot(222);
    plot(T_out(libreSeq),Cible(libreSeq)','b-o','LineWidth',trait); hold on;
    plot(T_out(libreSeq), y_hat(libreSeq),'r-x','LineWidth',trait);
    title('Comparaison entre fonction cible (bleu) et pr�dite (rouge)',...
        'FontSize',texte);
%     legend('Fonction cible','Fonction pr�dite','Location','Best');
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim(T_out([trainEnd T]));
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    set(gca,'FontSize',texte);
end

if fullTrain    
    subplot(212);
else
    subplot(223);
end
    plot(T_out(trainSeq),log10(ER_train),'g','LineWidth',trait); hold on;
    plot(T_out(trainSeq),EA_train);
    title('Erreur pendant l''entra�nement', 'FontSize',texte);
    legend('Log de l''erreur relative','Erreur absolue',...
        'Location','SouthEast');
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim(T_out([transient trainEnd]));
    ylabel('$\mathcal{R}$','FontSize',texte,'Interpreter','Latex');
    set(gca,'FontSize',texte);

if ~fullTrain    
subplot(224);
    plot(T_out(libreSeq(1+theta:T-trainEnd)),log10(ER_libre),'g','LineWidth',trait); hold on;
    plot(T_out(libreSeq(1+theta:T-trainEnd)),EA_libre);
    title('Erreur pendant l''�volution libre',...
        'FontSize',texte);
    legend('Log de l''erreur relative','Erreur absolue', 'Location','SouthEast');
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim(T_out([trainEnd T]));
    ylabel('$\mathcal{R}$','FontSize',texte,'Interpreter','Latex');
    set(gca,'FontSize',texte);
end

% set(figErreurRC,'visible','on'); pause(10^-1);