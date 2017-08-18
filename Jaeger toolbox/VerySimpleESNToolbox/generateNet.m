% Create a ESN network. Call of this script returns: 
% 1. intWM0, sparse weight matrix of reservoir scaled to spectral radius 1, 
% 2. inWM random matrix of input-to-reservoir weights, 
% 3. ofbWM, output feedback weight matrix, 
% 4. initialOutWM all-zero initial weight matrix of reservoir-to-output units (is replaced
% by learnt weights as result of learning)

% note that variables netDim, inputLength, outputLength, connectivity must
% be set before this script is run (preferably by calling headers.m)


totalDim = netDim + inputLength + outputLength;

disp('Creating network ............');


% minusPoint5 is a little helper
% function that subtracts 0.5 from entries of a sparse matrix.


success = 0;
while not(success)
    try
intWM0 = sprand(netDim, netDim, connectivity);
intWM0 = spfun(@minusPoint5,intWM0);
opts.disp = 0;
SR = abs(eigs(intWM0,1, 'lm', opts));
intWM0 = intWM0/SR;
success = 1;
    catch
        ;
    end
end



% input weight matrix has weight vectors per input unit in colums
inWM = 2.0 * rand(netDim, inputLength)- 1.0;

% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections
initialOutWM = zeros(outputLength, netDim + inputLength);

%output feedback weight matrix has weights in columns
ofbWM0 = (2.0 * rand(netDim, outputLength)- 1.0);
