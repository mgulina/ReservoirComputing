% Cryptographie chaotique
% ***********************
% 
% Calcul d'erreurs pour le mélange
% --------------------------------

%% 1 - Erreurs
EA_Decrypt = abs(Decrypt-inputSignal);
ER_Decrypt = 100*EA_Decrypt./abs(inputSignal);
mse_Decrypt = mean(EA_Decrypt.^2);

EA_Decode = abs(Decode-inputSignal);
ER_Decode = 100*EA_Decode./abs(inputSignal);
mse_Decode_ex = mean(EA_Decode(trainSeq).^2);
mse_Decode_msg = mean(EA_Decode(trainEnd+1:T).^2);

EA_TF_Decrypt_ex = abs(p_Decrypt_ex-p_input_ex);
ER_TF_Decrypt_ex = 100*EA_TF_Decrypt_ex./abs(p_input_ex);
mse_TF_Decrypt_ex = mean(EA_TF_Decrypt_ex.^2);

EA_TF_Decrypt_msg = abs(p_Decrypt_msg-p_input_msg);
ER_TF_Decrypt_msg = 100*EA_TF_Decrypt_msg./abs(p_input_msg);
mse_TF_Decrypt_msg = mean(EA_TF_Decrypt_msg.^2);

EA_TF_Decode_ex = abs(p_Decode_ex-p_input_ex);
ER_TF_Decode_ex = 100*EA_TF_Decode_ex./abs(p_input_ex);
mse_TF_Decode_ex = mean(EA_TF_Decode_ex.^2);

EA_TF_Decode_msg = abs(p_Decode_msg-p_input_msg);
ER_TF_Decode_msg = 100*EA_TF_Decode_msg./abs(p_input_msg);
mse_TF_Decode_msg = mean(EA_TF_Decode_msg.^2);

log10_mse_Decode_ex = log10(mse_Decode_ex) %#ok<*NOPTS>
log10_mse_Decode_msg = log10(mse_Decode_msg)
log10_mse_TF_Decode_ex = log10(mse_TF_Decode_ex)
log10_mse_TF_Decode_msg = log10(mse_TF_Decode_msg)
%% 3 - Sorties graphiques
signalsFig = figure('units','normalized',...
        'outerposition',[0.05  0.1  0.9 0.9],...
        'Name','Résultats du décryptage et du décodage',...
        'Visible','Off');
    
subplot(4,1,1)
    plot(T_out,alice,'c-*'); hold on;
    plot(T_out,bob,'b-o');
    plot(T_out,y_hat(1:length(T_out)),'r-x');
    plot(T_out,alice-bob,'k-o');
    plot(T_out,z,'y-x'); 
    
    legend('a','b','y','a-b','a-y','Location','NorthEast');
    xlabel('t [s]');
    
    plot([T_out(trainEnd) T_out(trainEnd)],get(gca,'YLim'),...
        'm--','LineWidth',3);
    
subplot(4,1,2);
    plot(T_out,inputSignal,'c-o'); hold on;
    plot(T_out,Decrypt,'b-x');
    plot(T_out,Decode,'r-x');
    
    legend('Input','Decrypt','Decode','Location','NorthEast');
    
    limYinput = [-inputFactor inputFactor]*2;
    ylim(limYinput);
    xlabel('t [s]');

    plot([T_out(trainEnd) T_out(trainEnd)],get(gca,'YLim'),...
        'm--','LineWidth',3);
    
subplot(4,1,3);
    plot(T_out,log10(ER_Decrypt),'b-*'); hold on;
    plot(T_out,log10(ER_Decode),'g-*'); 
    
    legend('Erreur Decrypt','Erreur Decode','Location','NorthEast');
    xlabel('t [s]');
    
    plot([T_out(trainEnd) T_out(trainEnd)],get(gca,'YLim'),...
        'm--','LineWidth',3);

subplot(4,2,7);
    plot(f_input_ex,p_input_ex,'c-o'); hold on;
    plot(f_Decrypt_ex,p_Decrypt_ex,'b-x');
    plot(f_Decode_ex,p_Decode_ex,'r-+');
    
    legend('FFT Input','FFT Decrypt','FFT Decode', 'Location','NorthEast');
    
    xlim([0 1.2]);
    xlabel('f [Hz]'); title('Exemple');
    
subplot(4,2,8);
    plot(f_input_msg,p_input_msg,'c-o'); hold on;
    plot(f_Decrypt_msg,p_Decrypt_msg,'b-x');
    plot(f_Decode_msg,p_Decode_msg,'r-+');

    legend('FFT Input','FFT Decrypt','FFT Decode', 'Location','NorthEast');

    xlim([0 1.2]);
    xlabel('f [Hz]'); title('Message');     
% set(signalsFig,'Visible','on');