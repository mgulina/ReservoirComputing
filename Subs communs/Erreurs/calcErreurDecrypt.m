% Cryptographie chaotique
% ***********************
% 
% Calcul d'erreurs pour la superposition (Bob)
% --------------------------------------------

%% 1 - Erreur de d�cryptage
ErreurDecrypt = Decrypt - Message;
ErreurDecryptFiltre = DecryptFiltre - Message;

nbrErreurDecrypt = sum(abs(ErreurDecryptFiltre)/A)/bitRepete %#ok<*NOPTS>
SER = nbrErreurDecrypt/nbrBit

%% 2 - Sorties graphiques
figDecrypt = figure('units','normalized',...
        'outerposition',outerPos,...
        'Name','D�cryptage',...
        'Visible','Off');
    
subplot(211);
    plot(T_out,Message,'b-o','LineWidth',trait);hold on;
    plot(T_out,Decrypt,'r-x','LineWidth',trait);
    plot(T_out,DecryptFiltre,'g-*','LineWidth',trait);
    plot([0 T_out(end)],[A/2 A/2],'k','LineWidth',trait);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    if A > 0
        ylim([-A 2*A]);
    else
%         ylim([2*A -A]);
    end
    title('Comparaison entre le message original et d�crypt�',...
        'FontSize',texte);
    legend('Original','D�crypt� sans filtre','D�crypt� avec filtre',...
           'Location','Best');
   set(gca,'FontSize',texte);
    
subplot(212);    
    plot(T_out,ErreurDecryptFiltre,'g-*','LineWidth',trait);
    xlabel('$t [s]$','FontSize',texte,'Interpreter','Latex');
    ylabel('$[AU]$','FontSize',texte,'Interpreter','Latex');
    title('Diff�rence entre le message original et d�crypt�',...
        'FontSize',texte);
    set(gca,'FontSize',texte);

% set(figDecrypt,'visible','on'); pause(10^-1);