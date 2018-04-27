% Cryptographie chaotique
% ***********************
% 
% Calcul d'erreurs pour la superposition (Eve)
% --------------------------------------------

%% 1 - Erreur de décryptage
T_tot = (length(Crypt) - 1)*h; T_out = 0:h:T_tot; T = length(T_out);

% if Q ~= 1
%     interpMessage = interp1(T_out,Message,interpT_out);
%     interpMessage = filtreSortieEve(interpMessage,A/2,Q*bitRepete);
%     interpMessage(interpMessage == 1) = A;
% end

% if Q ~= 1
%     ErreurCrack = Crack - interpMessage;
%     ErreurCrackFiltre = CrackFiltre - interpMessage;
% else
    ErreurCrack = Crack - Message;
    ErreurCrackFiltre = CrackFiltre - Message;
% end

% nbrErreurCrack = sum(abs(ErreurCrackFiltre)/A)/(Q*bitRepete) %#ok<*NOPTS>
nbrErreurCrack = sum(abs(ErreurCrackFiltre)/A)/(bitRepete) %#ok<*NOPTS>
SER = nbrErreurCrack/(nbrBit)

%% 2 - Sorties graphiques
figCrack = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','Décodage',...
        'Visible','Off');
    
subplot(211);
    plot(T_out,Message,'b','LineWidth',trait);hold on;
    plot(T_out,Crack,'r','LineWidth',trait);
    plot(T_out,CrackFiltre,'g','LineWidth',trait);
    plot([0 T_out(end)],[M M],'k','LineWidth',trait);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    ylim([-A 2*A]);
    title('Comparaison entre le message original et decodé',...
        'FontSize',texte);
    legend('Original','Decodé sans filtre','Decodé avec filtre',...
           'Location','Best');
   set(gca,'FontSize',texte);
    
subplot(212);    
    plot(T_out,ErreurCrackFiltre,'g','LineWidth',trait);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    title('Différence entre le message original et decodé',...
        'FontSize',texte);
    set(gca,'FontSize',texte);

% set(figCrack,'visible','on'); pause(10^-1);