% Fonction cible pour le syst�me de Mackey - Glass
% ************************************************

if ~exist('outTitle','var')
    disp('Fonction cible');
else
    if outTitle
        disp('Fonction cible');
    end
end

%% 1 - Param�tres
%% 1.1 - D�lai
if ~exist('tau','var')
    tau = 17; 
    drapTau = 0;
else
    if tau ~= 17
        drapTau = 1;
    else
        drapTau = 0;
    end
end

%% 1.2 - Condition initiale
if ~exist('CI','var')
    CI = 0.5;
    drapCI = 0;
else
    if CI ~= 0.5
        drapCI = 1;
    else
        drapCI = 0;
    end
end

%% 1.3 - Pas d'�chantillonnage
if ~exist('h','var')
    h = 0.5; 
end

%% 1.4 - Intervalle d'int�gration
if ~exist('T_tot','var')
    T_tot = round(7000*h); % Int�gration sur [0 T_tot]
end

%% 1.5 - Echantillonnage
T_out = 0:h:T_tot;
T = length(T_out);

%% 2 - Int�gration
if ~exist('rk4','var')
    rk4 = 0;
end

if rk4
    Cible = zeros(1,T); %#ok<*UNRCH>
    Cible(1) = CI(end);
    for t = 1:T-1
        if T_out(t) <= tau + h % + h car y(0) --> y(1)
            Y_T = CI;
        else
            Y_T = Cible(t-round(tau/h)); 
        end       

        Cible(t+1) = MG_rk4(h,Cible(t),Y_T);
    end
    
elseif T_tot > 35000 || drapCI || drapTau
    MG = dde23(@equationMG,tau,CI,[0, T_tot]);
else
    load('cibleMG.mat'); % Pr�calcul de MG o� T_tot = 35000 et CI = 0.5 avec tau = 17
end

%% 3 - Changement d'�chelle (oui par d�faut)
if exist('ChangeScaleMG','var')
    if rk4
        if ChangeScaleMG
            Cible = tanh(Cible - 1)';
        else
            Cible = Cible';
        end
    else
        if ChangeScaleMG
            Cible = tanh(deval(MG,T_out)' - 1);
        else
            Cible = deval(MG,T_out)';
        end
        clearvars MG;
    end
else
    if rk4
        Cible = tanh(Cible - 1)'; ChangeScaleMG = 1;
    else
        Cible = tanh(deval(MG,T_out)' - 1); ChangeScaleMG = 1;
        clearvars MG;
    end
end