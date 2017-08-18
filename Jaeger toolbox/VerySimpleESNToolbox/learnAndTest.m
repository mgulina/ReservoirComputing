% Version from 2004/02/27, Herbert Jaeger

% do the actual learning and also testing.
%
% Before this script can be run, the stage must be set by
% 1. a previous call to "generateNet"
% 2. generation of training&testing time series, which 
%    must be available as a matlab array "sampleinput" for 
%    the input time series and "sampleout" for the output (= teacher)
%    timeseries. For instance, a call to the preconfigured script
%    "generateTrainTestData" will produce such data. 
%
% Please read the readme.txt carefully... 
%
% generateNet and teacher time series in the form of
% k-dim input and l-dim output data provided in following arrays:
% sampleinput: size k,runlength
% sampleout: size l,runlength

%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%
% learning performance critically depends on spectral radius, and the
% input/output shifts and scalings, and outputFeedbackScaling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set spectral radius of reservoir weight matrix and scaling of output
% feedback weights. The latter is column vector
% specRad = 0.8; ofbSC = [1;1];

% noislevel: noise added to reservoir update during learning. Important for
% networks that have to actively generate dynamic patters (for instance,
% periodic signals, chaotic attractors), that is, networks where output
% feedback weights are present. In such cases, adding noise increases
% stability and decreases precision.
% noiselevel = 0.000;
% linearOutputUnits = 0; % 1 = use linear output units, 0 = sigmoid output units
% linearNetwork = 0; % 1 = use liner units in DR, 0 = use tanh units

% 1 = compute linear regression directly by solving Wiener Hopf equation
% with inverting covariance matrix; 0 = compute linear regression via
% pseudoinverse. 1 is faster and more space-economical, but less accurate. 
% WienerHopf = 1; 
% initialRunlength: initial update cycles where network is driven by
% teacher data; internal signals obtained here are discarded before
% learning (= washout of initial transients)
% initialRunlength = 100;
% number of update steps used for computing output weights
% sampleRunlength = 1000;
% freeRunlength is number of steps the trained network is left 
% running freely before plotting and testing starts. Mostly set to 0, 
% sometimes useful if trained network may be unstable and one wants to 
% check whether it stably runs for a long time
% freeRunlength = 0;
% plotRunlength is the length of the testing sequence. Data from this 
% sequence are used for generating various result plots and for computing
% test performance statistics
% plotRunlength = 100;

plotStates = [1 2 3 4]; % plot internal network states of ...
% units indicated in row vector; maximally 4 are plotted. Data from
% plotRunlength are plotted

% inputscaling is column vector of dimension of input
% inputscaling = [0.1;0.5];
% % inputshift is column vector of dimension of input
% inputshift = [0;1];
% % teacherscaling is column vector of dimension of output
% teacherscaling = [0.3;0.3];
% % teacherscaling is column vector of dimension of output
% teachershift = [-.2;-0.2];

disp('Learning and testing.........');
% disp(sprintf('netDim = %g   specRad =  %g   noise = %g    ',...
%     netDim, specRad, noiselevel));
% disp(sprintf('output feedback Scaling = %s', num2str(ofbSC')));
% disp(sprintf('inSC = %s', num2str(inputscaling')));
% disp(sprintf('inShift = %s', num2str(inputshift')));
% disp(sprintf('teacherSC = %s', num2str(teacherscaling')));
% disp(sprintf('teachershift = %s', num2str(teachershift')));
% disp(sprintf('WienerHopf = %g   linearOuts = %g   linearNet = %g',...
%     WienerHopf,linearOutputUnits, linearNetwork));
% disp(sprintf('initRL = %g  sampleRL = %g  plotRL = %g  ',...
%     initialRunlength, sampleRunlength, plotRunlength));


totalstate =  zeros(totalDim,1);    
internalState = totalstate(1:netDim);
intWM = intWM0 * specRad;
ofbWM = ofbWM0 * diag(ofbSC);
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end
statePL = zeros(length(plotStates),plotRunlength);
plotindex = 0;
msetest = zeros(1,outputLength); 
msetrain = zeros(1,outputLength); 


for i = 1:initialRunlength + sampleRunlength + freeRunlength + plotRunlength 
    
    if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i) + inputshift];  % in is column vector  
    else in = [];
    end
    teach = [diag(teacherscaling) * sampleout(:,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = f([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    end
    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
    else
        netOut = f(outWM *[internalState;in]);
    end
    totalstate = [internalState;in;netOut];    
    
    %collect states and results for later use in learning procedure
    if (i > initialRunlength) & (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internalState' in']; %fill a row
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teach';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teach))'; %fill a row
        end
    end
    %force teacher output 
    if i <= initialRunlength + sampleRunlength
        totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach; 
    end
    %update msetest
    if i > initialRunlength + sampleRunlength + freeRunlength
        for j = 1:outputLength
            msetest(1,j) = msetest(1,j) + (teach(j,1)- netOut(j,1))^2;
        end
    end
    %compute new model
    if i == initialRunlength + sampleRunlength
        if WienerHopf
            covMat = stateCollectMat' * stateCollectMat / sampleRunlength;
            pVec = stateCollectMat' * teachCollectMat / sampleRunlength;
            outWM = (inv(covMat) * pVec)';
        else
            outWM = (pinv(stateCollectMat) * teachCollectMat)'; 
        end
        %compute mean square errors on the training data using the newly
        %computed weights
        for j = 1:outputLength
            if linearOutputUnits
                msetrain(1,j) = sum((teachCollectMat(:,j) - ...
                    (stateCollectMat * outWM(j,:)')).^2);
            else
                msetrain(1,j) = sum((f(teachCollectMat(:,j)) - ...
                    f(stateCollectMat * outWM(j,:)')).^2);
            end
            msetrain(1,j) = msetrain(1,j) / sampleRunlength;
        end
    end    
    %write plotting data into various plotfiles
    if i > initialRunlength + sampleRunlength + freeRunlength 
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = in;
        end
        teacherPL(:,plotindex) = teach; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = totalstate(plotStates(j),1);
        end
    end
end
%end of the great do-loop




% print diagnostics in terms of normalized RMSE (root mean square error)

msetestresult = msetest / plotRunlength;
teacherVariance = var(teacherPL');
disp(sprintf('train NRMSE = %s', num2str(sqrt(msetrain ./ teacherVariance))));
disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));
disp(sprintf('average output weights = %s', num2str(mean(abs(outWM')))));


% input plot
figure(fig2);
subplot(inputLength,1,1);
plot(inputPL(1,:));
title('final effective inputs','FontSize',8);
for k = 2:inputLength
    subplot(inputLength,1,k);
    plot(inputPL(k,:));
end


% plot first 4 (maximally) of internal states listed in plotStates
if length(plotStates) > 0 
    figure(fig3);
    subplot(2,2,1);
    plot(statePL(1,:));
    title('internal states','FontSize',8);
    for k = 2:length(plotStates)
        subplot(2,2,k);
        plot(statePL(k,:));
    end    
end

% plot weights
 
    figure(fig4);
    subplot(outputLength,1,1);   
    plot(outWM(1,:));
    title('output weights','FontSize',8);
    for k = 2:outputLength
        subplot(outputLength,1,k);
        plot(outWM(k,:));
    end  


% plot overlay of network output and teacher  
figure(fig5);
subplot(outputLength,1,1);   
plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
title('teacher (blue) vs. net output (green)','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
end  





