% Cryptographie chaotique
% ***********************
%
% Mélange non-linéaire en III/1
% -----------------------------

clc;
% close all;

%% 1 - Construction du signal d'entrée
disp('Construction du signal d''entrée');
formeMessage = menu('Choisissez la forme du message',...
                'Succession de sinus','Sinus à fréquence modulée',...
                'Sinus à amplitude modulée','Chaîne de bits', 'Annuler');
pause(0.1);

fullAttack = 0;

%% Succession de sinus
if formeMessage == 1
    nbrSinus = 7;           % Nombre de bits dans le cas où #omega = 2 (si pas de message entré dans genSin)
    omega = 2*pi*[0.01 0.02];
    h = 0.1;
    dt = 1/min(omega); % Sera multiplié par 2 pi

    [Exemple,T_out_ex,omegaOut_ex,msgCache_ex,msgClair_ex] = ...
        genSinus('Fini',nbrSinus,omega,h,dt*2*pi,'a');
    [Message,T_out_msg,omegaOut_msg,msgCache_msg,msgClair_msg] = ...
        genSinus('Fini',nbrSinus,omega,h,dt*2*pi,'hello');
    
    T_ex = T_out_ex(end); T_msg = T_out_msg(end);
    T_out_msg = T_out_msg + T_ex;
    T_tot = T_ex + T_msg;

    inputFactor = 0.02;
    
    inputSignal = inputFactor*[Exemple ; Message(2:end)];

    T_out = [T_out_ex T_out_msg(2:end)];
    T = length(T_out);
    
 %% Sinus à fréquence modulée
elseif formeMessage == 2
    B = 3;
    fc_ex = 5*10^-3;
    fm_ex = 5*10^-4;
    fc_msg = 5*10^-3;
    fm_msg = 5*10^-4;
    h = 0.5;
    T_tot = 6000;
        
    [Exemple,T_out_ex] = genSinus('Modulation',B,fc_ex,fm_ex,h,T_tot);
    [Message,T_out_msg] = genSinus('Modulation',B,fc_msg,fm_msg,h,T_tot);
    
    T_ex = T_out_ex(end); T_msg = T_out_msg(end);
    T_out_msg = T_out_msg + T_ex;
    T_tot = T_ex + T_msg;

    inputFactor = 0.01;
    inputSignal = inputFactor*[Exemple ; Message(2:end)];

    T_out = [T_out_ex T_out_msg(2:end)];
    T = length(T_out);

%% Sinus à amplitude modulée
elseif formeMessage == 3
    error('a terminer éventuellement plus tard');
%     nbrBit = 24;
%     bitRepete = 200;
%     nbrBitsFinal = nbrBit*bitRepete;
%     
%     omega = 2*pi/bitRepete;
%     h = 1; % doit être unitaire
% 
%     [port,T_out] = genSinus('Fini',2*nbrBit+1,omega,h); % + 1 pour avoir assez de sinus
%         
%     [bits,~,~] = genMessage(bitRepete,2*nbrBit);
%     
%     T_ex = nbrBitsFinal;
%     T = length(port) - rem(length(port),bitRepete);
%     T_out = T_out(1:T);
%     port = port(1:T);
%     
%     bitFactor = 0.1;
%     inputFactor = 0.1;
%     
%     inputSignal = inputFactor*(port + bitFactor*bits);
    
    

%% Chaîne de bits
    elseif formeMessage == 4
        nbrBit = 320;
        bitRepete = 50;
        nbrBitsFinal = nbrBit*bitRepete;
        h = 1; % h doit être unitaire 
        
        [Exemple,msgCache_ex,msgClair_ex] = genMessage(bitRepete,nbrBit);
        [Message,msgCache_msg,msgClair_msg] = genMessage(bitRepete,nbrBit);
        
        T_ex = round(nbrBitsFinal/h);
        T_out_ex = 0:h:nbrBitsFinal;
        T_out_msg = nbrBitsFinal+h:h:2*nbrBitsFinal;
        T_out = [T_out_ex T_out_msg(2:end)];
        
        T_tot = T_out_msg(end);
        T = length(T_out);
        
        inputFactor = 0.01;
        inputSignal = inputFactor*[Exemple ; Message];
else
    error('La variable nbrFreqFini n''a pas été définie.');
end
    
    A_eps = 10^-4; % Bruit pendant la communication

%% 2 - Transmission du message
disp('Transmission du message');
%% 2.1 - Initialisation des systèmes d'Alice et Bob
tau = 17;
A_filtre = 10;
source =  @sourceMG;
alice_tau = 0.5*ones(round((tau+1)/h),1);

alice = zeros(T,1); alice(1) = alice_tau(round((tau+1)/h));
bob = alice;

%% 2.2 - Boucle de transmission
% t - \tau <= 0
for t = 1:round((tau)/h)+1
    fa = source(alice_tau(t)) + inputSignal(t);
    fb = source(alice_tau(t) + A_eps*unifrnd(-1,1));
    alice(t+1) = alice(t)*exp(-h/A_filtre) + fa*(1 - exp(-h/A_filtre));
    bob(t+1) = bob(t)*exp(-h/A_filtre) + fb*(1 - exp(-h/A_filtre)); 
end

% t - \tau > 0
for t = round((tau)/h)+2:T-1
    fa = (source(alice(t-round(tau/h))) + source(alice(t-round((tau)/h)+1)))/2 ...
        + inputSignal(t);
    fb = (source(alice(t-round(tau/h)) + A_eps*unifrnd(-1,1) ) ...
        + source(alice(t-round((tau)/h)+1) + A_eps*unifrnd(-1,1)))/2;
    alice(t+1) = alice(t)*exp(-h/A_filtre) + fa*(1 - exp(-h/A_filtre));
    bob(t+1) = bob(t)*exp(-h/A_filtre) + fb*(1 - exp(-h/A_filtre)); 
end
    
%% 2.3 - Traitement du signal de sortie et décryptage
disp('Décryptage');

[c,dot_c] = sortieMelange(alice,bob,h); % Construction de c et dot_c
Decrypt = A_filtre*dot_c + c; % Récupération du message

if formeMessage == 4
    DecryptFiltre = filtreSortieBob(Decrypt,inputFactor,bitRepete);
end

%% 3 - Interception du signal par Eve 
disp('Interception du signal par Eve');

%% 3.1 - Entraînement sur un exemple
% Exemple configuré au %% 1

% Construction du réservoir
if formeMessage == 1
    ChangeScaleMG = 0;
     N = 250;
%     gamma = 0.01;
    delta = h;
%     gainIn = 1;
    gainFb = 0.;
%     rho = 0.79;
     C = 0.22;
%      a = 0.9;
%     LvlNoise = 10^-5;
    
elseif formeMessage == 2    
    ChangeScaleMG = 0;
     N = 250;
%     gamma = 0.01;
    delta = h;
    gainIn = 0.9;
%     rho = 0.79;
%     a = 0.9;
%     LvlNoise = 10^-4;
    
    if fullAttack
        C = 0.44; %#ok<*UNRCH>
        gainFb = 0.8;
    else
        C = 0.05;
        gainFb = 0;
    end
    
elseif formeMessage == 3
    ChangeScaleMG = 0;
%     N = 1500;
%     gamma = 0.01;
    delta = h;
    gainIn = 0.9;
    gainFb = 0.8;
%     rho = 0.79;
%     C = 0.44;
%     a = 0.9;
    LvlNoise = 10^-4;
    
elseif formeMessage == 4
    ChangeScaleMG = 0;
%     N = 1500;
%     gamma = 0.01;
    delta = h;
    gainIn = 0.9;
%     rho = 0.79;
%     a = 0.9;
%     C = 0.44;
%     LvlNoise = 10^-4;
    if fullAttack      
        gainFb = 0.8; %#ok<*UNRCH>
    else
        gainFb = 0;
    end
end

genResMG;

fullTrain = 1;      transient = 1000;       trainEnd = round((T_ex)/h);

% Signal d'apprentissage
if fullAttack
    tmp = T;
    u = alice' + A_eps*unifrnd(-1,1,size(alice'));
    Cible = bob(1:trainEnd) + A_eps*unifrnd(-1,1,size(bob(1:trainEnd)));
else
    tmp = T;
    u = alice' + A_eps*unifrnd(-1,1,size(alice'));
    Cible = inputSignal(1:trainEnd) + A_eps*unifrnd(-1,1,size(inputSignal(1:trainEnd)));
end
T = trainEnd; %#ok<NASGU>

% Entraînement
trainSimpleMG;
calcErreursTrain;

%% 3.2 - Décodage
disp('Emulation par le réservoir');

T = tmp;

y_hat = [y_hat zeros(1,T-trainEnd)];
S = [S ; zeros(T - trainEnd,N+K)];

for t = trainEnd+1:T-1
    U = alice(t) + A_eps*unifrnd(-1,1);  
    y_hat(t) = W_out*S(t,:)';
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',U,y_hat(t),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end
y_hat(T) = W_out*S(T,:)';

%% 3.3 - Traitement du signal de sortie et décodage
disp('Décodage');
if fullAttack
    [z,dot_z] = sortieMelange(alice,y_hat,h); % Construction de z et dot_z
    Decode = A_filtre*dot_z + z; % Décodage du message
else
    Decode = y_hat';
end

if formeMessage == 4
    M = mean(Decode(nbrBitsFinal:end));
%         M = inputFactor/2;
    DecodeFiltre = filtreSortieEve(Decode,M,bitRepete);
    DecodeFiltre(DecodeFiltre == 1) = inputFactor;
end

%% 4 - Transformées de Fourier
if formeMessage ~= 4
    [f_a,p_a] = tfPerso(T_out,alice);
    % p_a = p_a./max(p_a);

    [f_input_ex,p_input_ex] = tfPerso(T_out(trainSeq),inputSignal(trainSeq));
    [f_input_msg,p_input_msg] = tfPerso(T_out(trainEnd+1:T),inputSignal(trainEnd+1:T));

    [f_Decrypt_ex,p_Decrypt_ex] = tfPerso(T_out(trainSeq),Decrypt(trainSeq));
    [f_Decrypt_msg,p_Decrypt_msg] = tfPerso(T_out(trainEnd+1:T),Decrypt(trainEnd+1:T));

    [f_Decode_ex,p_Decode_ex] = tfPerso(T_out(trainSeq),Decode(trainSeq));
    [f_Decode_msg,p_Decode_msg] = tfPerso(T_out(trainEnd+1:T),Decode(trainEnd+1:T));
end

%% 5 - Erreurs et sorties graphiques
if formeMessage ~= 4
    spectreAliceFig = figure('units','normalized',...
            'outerposition',[0.05  0.1  0.9 0.9],...
            'Name','Spectre du signal transmis',...
            'Visible','Off');
        plot(f_a,p_a,'b-.');
        xlim([0 1.2]);
        xlabel('f [Hz]'); title('Spectre du signal transmis');   
end

calcErreurMelange;