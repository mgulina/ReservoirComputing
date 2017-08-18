% tent map example

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


% create unit input sequence
sampleinput = ones(1,samplelength);

sampleout = zeros(1,samplelength);

startx = 0.1 * pi;

x = startx;

r = 1.9;
for n = 1:samplelength
    if x > 0.5
        x = r - r*x;
    else
        x = r*x;
    end
    sampleout(1,n) = x;
end



% plot generated sampleout
figure(fig1);
outdim = length(sampleout(:,1));
for k = 1:outdim
    subplot(outdim, 1, k);
    plot(sampleout(k,:));
    if k == 1
        title('sampleout','FontSize',8);
    end
end
    

