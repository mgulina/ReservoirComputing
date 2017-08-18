% Mise à l'échelle du rayon spectral d'une matrice
% ************************************************

function [W_rho,alpha] = normRayonSpectral(W,rho)

%% 1 - Cas d'une matrice "sparse"
if issparse(W)
    opts.disp = 0;
    drap = 0 ; 
    while ~drap   
        try
            alpha = rho/abs(eigs(W,1,'lm', opts));
            drap = 1;
        catch %#ok<CTCH>
            drap = 0;
        end
    end
    W_rho = alpha*W;

%% 2 - Cas d'une matrice "full"
else
    drap = 0 ; 
    while ~drap   
        try
            alpha = rho/max(abs(eig(W)));
            drap = 1;
        catch %#ok<CTCH>
            drap = 0;
        end
    end
    W_rho = alpha*W;
end