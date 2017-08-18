% G�n�rateur de sinus modul�s en fr�quence
% *********************************************
%
% G�n�re une suite de sinus modul�s en fr�quence.
%
% Ce sigal peut �tre con�u de deux mani�res : 
%   - meth = 'Fini' : N sinus cons�cutifs de pulsation al�atoirement 
%           choisie dans le vecteur omegaIn. Le pas de temps est h.
%
%   - meth = 'Modulation' : sin(2*pi*fc*t - B*cos(2*pi*fm*t)) est 
%           g�n�r� avec un pas de temps h jusque T_tot.
%
% Les param�tres doivent �tre entr� dans l'ordre suivant : 
%   - meth = 'Fini' : N, omegaIn, h
%   - meth = 'Modulation' : B, fc, fm, h, T_tot
% 

function [Message,T_out] = genSinus(meth,varargin)
    meth = lower(meth);
    
    if strcmp(meth,'fini')
        N = varargin{1};
        omegaIn = varargin{2};
        h = varargin{3};
        
        if h > 1
            error('Le pas doit �tre inf�rieur ou �gal � 1.'); 
        end
%         d = -round(log10(h));
        L = length(omegaIn);
        Message = 0;
        T_out = 0;
        T_tot = 0;

        for i = 1:N
            w = omegaIn(randi(L));
            T = 2*pi/w;
            n = length(h:h:T);
            Message = [Message  sin(w*(linspace(h,T,n)))];
            T_out = [T_out (h:h:T)+T_out(end)];
        end

        Message = Message';

    elseif strcmp(meth,'modulation')
        B = varargin{1};
        fc = varargin{2};
        fm = varargin{3};
        h = varargin{4};
        T_tot = varargin{5};
        
        T_out = 0:h:T_tot;
        Message = sin(2*pi*fc*T_out - B*cos(2*pi*fm*T_out))';
    end
    
    

end