% Cryptographie chaotique
% ***********************
%
% Mélange non-linéaire en III/1
% -----------------------------

clearvars; 
clc;
% close all;

%% 1 - Construction du signal d'entrée
disp('Construction du signal d''entrée');
nbrFreqFini = menu('Choisissez la forme du message',...
                'Succession de sinus','Sinus à fréquence modulée',...
                'Annuler');
pause(0.1);            
if nbrFreqFini == 1
    nbrSinus = 5;
    omega = [0.01];
    h = 0.1;

    [Exemple,T_out_ex] = genSinus('Fini',nbrSinus,omega,h);
    [Message,T_out_msg] = genSinus('Fini',nbrSinus,omega,h);
    
    T_ex = T_out_ex(end); T_msg = T_out_msg(end);
    T_out_msg = T_out_msg + T_ex;
    T_tot = T_ex + T_msg;

    inputFactor = 0.05;
    
    inputSignal = inputFactor*[Exemple ; Message(2:end)];

    T_out = [T_out_ex T_out_msg(2:end)];
    T = length(T_out);
    
elseif nbrFreqFini == 2
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
    
else
    error('La variable nbrFreqFini n''a pas été définie.');
end
    
    A_eps = 10^-2; % Bruit pendant la communication

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

%% 3 - Interception du signal par Eve 
disp('Interception du signal par Eve');

%% 3.1 - Entraînement sur un exemple
% Exemple configuré au %% 1

% Construction du réservoir
if nbrFreqFini == 1
    ChangeScaleMG = 0;
%     N = 1500;
%     gamma = 0.01;
    delta = h;
    gainIn = 0.9;
    gainFb = 0.;
%     rho = 0.79;
%     C = 0.44;
%     a = 0.9;
    LvlNoise = 10^-5;
    
else 
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
end

genResMG;

fullTrain = 1;      transient = 1000;       trainEnd = round((T_ex)/h);

% Signal d'apprentissage
tmp = T;        u = alice';     Cible = bob(1:trainEnd);
T = trainEnd; %#ok<NASGU>

% Entraînement
trainSimpleMG;
calcErreursTrain;

%% 3.2 - Décodage
disp('Emulation du signal de Bob');

T = tmp;

y_hat = [y_hat zeros(1,T-trainEnd)];
S = [S ; zeros(T - trainEnd,N+K)];

for t = trainEnd+1:T-1
    U = alice(t); % Refaire u plus long    
    y_hat(t) = W_out*S(t,:)';
    S(t+1,:) = majRes(f_RC,delta,a,C,W_in,W,W_fb,...
                      S(t,1:N)',U,y_hat(t),...
                      unifrnd(-LvlNoise,LvlNoise,N,1));
end
y_hat(T) = W_out*S(T,:)';

%% 3.3 - Traitement du signal de sortie et décodage
disp('Décodage');
[z,dot_z] = sortieMelange(alice,y_hat,h); % Construction de z et dot_z
Decode = A_filtre*dot_z + z; % Décodage du message

%% 4 - Transformées de Fourier
[f_a,p_a] = tfPerso(T_out,alice);
% p_a = p_a./max(p_a);

[f_input_ex,p_input_ex] = tfPerso(T_out(trainSeq),inputSignal(trainSeq));
[f_input_msg,p_input_msg] = tfPerso(T_out(trainEnd+1:T),inputSignal(trainEnd+1:T));

[f_Decrypt_ex,p_Decrypt_ex] = tfPerso(T_out(trainSeq),Decrypt(trainSeq));
[f_Decrypt_msg,p_Decrypt_msg] = tfPerso(T_out(trainEnd+1:T),Decrypt(trainEnd+1:T));

[f_Decode_ex,p_Decode_ex] = tfPerso(T_out(trainSeq),Decode(trainSeq));
[f_Decode_msg,p_Decode_msg] = tfPerso(T_out(trainEnd+1:T),Decode(trainEnd+1:T));

%% 5 - Erreurs et sorties graphiques
spectreAliceFig = figure('units','normalized',...
        'outerposition',[0.05  0.1  0.9 0.9],...
        'Name','Spectre du signal transmis',...
        'Visible','On');
    plot(f_a,p_a,'b-x');
    xlim([0 1.2]);
    xlabel('f [Hz]'); title('Spectre du signal transmis');   
    
calcErreurMelange;