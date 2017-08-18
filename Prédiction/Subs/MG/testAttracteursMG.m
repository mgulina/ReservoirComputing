% Comparaison des attracteurs pour le système de Mackey - Glass
% *************************************************************

if tau == 17
    lag = round(17/h);
elseif tau == 30
    lag = round(20/h);
else
    lag = 2;
end

figAttracteurMG = figure('units','normalized',...
        'outerposition',[0.06  0.41  0.7 0.5],...
        'Name','Attracteur de Mackey  - Glass',...
        'Visible','Off');

subplot(121);
plot(Cible(trainEnd+lag:T),Cible(trainEnd:T-lag),'b');
title('Attracteur cible');

subplot(122);
plot(y_hat(trainEnd+lag:T),y_hat(trainEnd:T-lag),'r');
title('Attracteur prédit');

set(figAttracteurMG,'visible','on'); pause(10^-1);