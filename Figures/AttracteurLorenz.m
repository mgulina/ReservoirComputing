% Théorie Qualitative des Systèmes Dynamiques
% *******************************************

% Travaux Dirigés : séance 1 (partie 2/2)
% ---------------------------------------

% Prenez comme valeurs de paramètres sigma = 10, rho = 28, beta = 8/3.
% A nouveau, représentez l’évolution du système dynamique pour des condi-
% tions initiales très proches, ainsi que leur évolution composante par
% composante.

%% 1 - Initialisation
close all; clear; clc;

%% 1.1 - Paramètrisation
sigma = 10; rho = 28; beta = 8/3;
T_tot = 30;

%% 1.2 - Choix de l'exercice à réaliser
Ex = questdlg('Quel exercice voulez-vous effectuer ?', ...
                         'Choix de l''exercice', ...
                         'Composante par composante', 'Evolution',...
                         'Annuler',...
                         'Evolution');
                     
if strcmp(Ex,'Composante par composante')
    %% 2 - Intégration des équations de l'attracteur
    CI = [0 0.1 0 sigma rho beta];
    [~,Y] = ode45(@EquationLorenz,[0 T_tot],CI); 
    x = Y(:,1);     y = Y(:,2);     z = Y(:,3);
    
    %% 3 - Représentations graphiques
    %% 3.1 - Trajectoire des composantes
    fig = figure('units','normalized',...
        'outerposition',[0  0.027  1 0.972]);
    
    N = length(x);
    t = linspace(0,T_tot,N);   
    
    subplot(1,2,1);
    plot(t,x,'r', t,y,'g', t,z,'b','LineWidth',2); grid on; 
    set(gca,'FontSize',17);
    xlabel('t[s]'); 
	title('Trajectoire composante par composante');
    legend('x','y','z','Location','Best');    

    %% 3.2 - Attracteur de Lorenz
    subplot(1,2,2);             
    plot3(x,y,z,'-','color',[0 0 1],'LineWidth',2); view(30,30);  
    set(gca,'FontSize',17); grid on;
    xlabel('x'); ylabel('y'); zlabel('z');
%     title('Représentation de l''attracteur étrange de Lorenz');
    
elseif strcmp(Ex,'Evolution')
    %% 2 - Intégration des équations des pendules
    %% 2.1 - Conditions initiales de référence
    CI = [0 0.1 0 sigma rho beta];
    [~,Y] = ode45(@EquationLorenz,[0 T_tot],CI); 
    x = Y(:,1);     y = Y(:,2);     z = Y(:,3);

    %% 2.2 - Conditions initiales légèrement modifiée
    prompt = {'x', 'y', 'z', '\sigma', '\rho', '\beta'};
    name = 'Nouvelles conditions initiales';
    numlines = 1;
    defaultanswer = {'0','0.101','0', ...
        num2str(sigma),num2str(rho),num2str(beta)};

    options.Resize = 'on';
    options.WindowStyle = 'normal';
    options.Interpreter = 'tex';

    modif = inputdlg(prompt,name,numlines,defaultanswer,options);
    
    CIm = zeros(6,1);
    for j = 1:6
        CIm(j) = eval(modif{j});
    end
    
    [~,Ym] = ode45(@EquationLorenz,[0 T_tot],CIm);
    xm = Ym(:,1);     ym = Ym(:,2);     zm = Ym(:,3);

    %% 3 - Représentations graphiques
    %% 3.1 - Comparaison des trajectoires composante par composante
    fig = figure('units','normalize',...
        'outerposition',[0  0.027  1 0.972]);
    
    N = min([length(x) length(xm)]);
    t = linspace(0,T_tot,N);
    
    subplot('Position',[0.05  0.7  0.4 0.23]);    
    plot(t,x(1:N),'r',t,xm(1:N),'c'); grid on;
    title('Comparaison des composantes x');
    legend('x','xm','Location','Best');
    
    subplot('Position',[0.05  0.38  0.4 0.23]);    
    plot(t,y(1:N),'g',t,ym(1:N),'m'); grid on;
    title('Comparaison des composantes y');
    legend('y','ym','Location','Best');
    
    subplot('Position',[0.05  0.07  0.4 0.23]);    
    plot(t,z(1:N),'b',t,zm(1:N),'y'); grid on;
    title('Comparaison des composantes z');
    legend('z','zm','Location','Best');
    xlabel('t[s]')

    %% 3.2 - Comparaison de l''évolution des attracteurs
    subplot('Position',[0.51  0.225  0.45 0.45]); hold on; 
        
    for i = 1:N
        if i > 1
            delete(plt1(i)); delete(plt2(i)); 
            delete(dot1(i)); delete(dot2(i));
        end
        
        view(30,30);
        plt1(i+1) = plot3(x(1:i),y(1:i),z(1:i),'b');      %#ok<*SAGROW>
        dot1(i+1) = plot3(x(i),y(i),z(i),...
            'o','MarkerFaceColor','b','MarkerSize',10);
        
        plt2(i+1) = plot3(xm(1:i),ym(1:i),zm(1:i),'color',[1 .3 0]);
        dot2(i+1) = plot3(xm(i),ym(i),zm(i),...
            'o','MarkerFaceColor',[1 .3 0],'MarkerSize',10);
        if i == 1
            xlabel('x'); ylabel('y'); zlabel('z');
            title('Représentation de l''attracteur étrange de Lorenz');
        end 
        pause(0.01);
    end
    
elseif strcmp(Ex,'Annuler')
    warndlg('Programme avorté.');
    return;
else
    error('Choix avorté.');
end