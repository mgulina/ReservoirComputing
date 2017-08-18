% Version from 2004/02/27, Herbert Jaeger

% %%%% generate training and testing time series for ESN training
% The learning-and-testing script learn.m expects data to be contained in
% two matrices named sampleinput (of size inputdim x samplelength) and
% sampleout (of size outputdim x samplelength). Such two matrices must be
% the result of calling this script.

% Note: the script learn.m does training AND testing. Training is done with
% an initial sequence of the data generated here, testing is done on
% remaining data. Therefore, the samplelength should be chosen of
% sufficient length to provide data for both training and  testing.

% in this demo example, we create such data from a simple NARMA equation.

disp('Generating data ............');
% disp(sprintf('sample length %g', samplelength ));


% create random input sequence
sampleinput = [ones(1,samplelength);rand(1,samplelength)];

 % use this input sequence to drive a NARMA equation
systemorder = 10;
sampleout = 0.1*ones(2,samplelength);
for n = systemorder +1 : samplelength
    % insert suitable NARMA equation on r.h.s.
    sampleout(1,n) = sampleinput(2,n-5) * sampleinput(2,n-10) ...
        + sampleinput(2,n-2) * sampleout(2,n-2);
    sampleout(2,n) = sampleinput(2,n-1) * sampleinput(2,n-3) ...
        + sampleinput(2,n-2) * sampleout(1,n-2);
end

% normalize input to range [0,1]
for indim = 1:length(sampleinput(:,1))
    maxVal = max(sampleinput(indim,:)); minVal = min(sampleinput(indim,:));
    if maxVal - minVal > 0
      sampleinput(indim,:) = (sampleinput(indim,:) - minVal)/(maxVal - minVal);
    end
end

% normalize output to range [-0.5,0.5]
for outdim = 1:length(sampleout(:,1))
    maxVal = max(sampleout(outdim,:)); minVal = min(sampleout(outdim,:));
    if maxVal - minVal > 0
       sampleout(outdim,:) = (sampleout(outdim,:) - minVal)/(maxVal - minVal)-0.5;
    end
end

% plot generated sampleout
figure(1); clf;
outdim = length(sampleout(:,1));
for k = 1:outdim
    subplot(outdim, 1, k);
    plot(sampleout(k,:));
    if k == 1
        title('sampleout','FontSize',8);
    end
end
    
% plot generated sampleinput
figure(2); clf;
outdim = length(sampleinput(:,1));
for k = 1:outdim
    subplot(outdim, 1, k);
    plot(sampleinput(k,:));
    if k == 1
        title('sampleinput','FontSize',8);
    end
end
    
