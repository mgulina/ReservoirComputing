% Filtre de sortie et vérification des erreurs pour l'égaliseur de canaux
% ***********************************************************************

nbrErreurTrain
stop
nbrErreurLibre

%% 1 - Symbol Error Rate
nbrErreurMax = 10;
if nbrErreurLibre == nbrErreurMax
    ser = nbrErreurMax/length(trainEnd+1:posErreurLibre(nbrErreurMax)) %#ok<*NOPTS>
else    
    ser = nbrErreurLibre/length(trainEnd+1:T)
end

%% 2 - Affichage
figCanal = figure('units','normalized',...
        'outerposition',outerPos,...
        'Visible','Off');

subplot(411);
    plot(d(1:1000),'bo','LineWidth',trait); hold on; 
    title('1000 premières entrées du canal',...
        'FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    set(gca,'FontSize',texte);
    
subplot(412);
    plot(q(1:1000),'bo','LineWidth',trait); hold on; 
    title('1000 premières sorties du canal',...
        'FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');  
    set(gca,'FontSize',texte);
    
subplot(413);
    plot(trainSeq,d(trainSeq-delai),'bo','LineWidth',trait); hold on; 
    plot(trainSeq,y_hat(trainSeq),'rx','LineWidth',trait);
    plot(trainSeq,d_hat(trainSeq),'g*','LineWidth',trait);
    title('Comparaison entre fonction cible et entraînée',...
        'FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim([transient transient+trainEnd/2]);
    legend('Symboles cibles','Entrainement sans filtre','Avec filtre',...
        'Location','EastOutside');
    set(gca,'FontSize',texte);
    
subplot(414);
    plot(trainEnd+delai:T,d((trainEnd:T-delai))','bo','LineWidth',trait); hold on;
    plot(trainEnd+delai:T,y_hat(trainEnd+delai:T),'rx','LineWidth',trait);
    plot(trainEnd+delai:T,d_hat(trainEnd+delai:T),'g*','LineWidth',trait);
    title('Comparaison entre fonction cible et égalisée',...
        'FontSize',texte);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    xlim([trainEnd trainEnd+trainEnd/2]);     
    legend('Symboles cibles','Egalisation sans filtre','Avec filtre',...
        'Location','EastOutside');
    set(gca,'FontSize',texte);
    
set(figCanal,'visible','on');

clear t;