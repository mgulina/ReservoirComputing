% Générateur de sinus modulés en fréquence
% *********************************************
%
% Génère une suite de sinus modulés en fréquence.
%
% Ce sigal peut être conçu de deux manières : 
%   - meth = 'Fini' : N sinus consécutifs de pulsation aléatoirement 
%           choisie dans le vecteur omegaIn. Le pas de temps est h.
%           Si dt est entré, alors chacun des N sinus durera dt unité de 
%           temps, sinon si dt n'est pas entré ou que dt = 0, chacun des N
%           sinus durera 1 période.
%           Si seulement deux pulsations sont données, la plus petite est
%           associée à un bit 0 et la plus grande à un bit 1.
%           Dans ce cas, varargout contient les fréquences utilisées pour
%           générer la succession et les bits ainsi que le message en
%           clair, dans le cas où il y en a.
%
%   - meth = 'Modulation' : sin(2*pi*fc*t - B*cos(2*pi*fm*t)) est 
%           généré avec un pas de temps h jusque T_tot.
%           Dans ce cas, varargout ne contient aucune variable.
%
% Les paramètres doivent être entré dans l'ordre suivant : 
%   - meth = 'Fini' : N, omegaIn, h, (dt)
%   - meth = 'Modulation' : B, fc, fm, h, T_tot
%
% 

function [Message,T_out,varargout] = genSinus(meth,varargin)
    meth = lower(meth);
    
    if strcmp(meth,'fini')
        N = varargin{1};
        omegaIn = sort(varargin{2});
        h = varargin{3};
        try
            dt = varargin{4};
        catch
            dt = 0;
        end
        try
            msgClair = varargin{5};
            bits = dec2bin(varargin{5});
            [p,q] = size(bits); N = p*q;
            
            if rem(N,7) ~= 0 || N < 0
                    error('Le nombre de bits doit être un multiple positif de 7.');
            end

            msgCache = bits;
            drapMsg = 1;

        catch 
            drapMsg = 0;
        end
        
                
        if h > 1
            error('Le pas doit être inférieur ou égal à 1.'); 
        end
%         d = -round(log10(h));
        L = length(omegaIn);
        Message = 0;
        T_out = 0;
        omegaOut = zeros(N,1);
                    
        if dt == 0 % pas d'intervalle de temps : on fait une période par pulsation
            if L == 2
                if rem(N,7) ~= 0 || N < 0
                    error('Le nombre de bits doit être un multiple positif de 7.');
                end
                bits = zeros(N,1);
                
                for i = 1:N
                    w = omegaIn(randi(L));
                    omegaOut(i) = w;
                        if w == omegaIn(2)
                            bits(i) = 1;
%                         else 
%                             bits(i) = 0;
                        end
                    T = 2*pi/w;
                    n = length(h:h:T);
                    Message = [Message  sin(w*(linspace(h,T,n)))]; %#ok<*AGROW>
                    T_out = [T_out (h:h:T)+T_out(end)];
                end
            else
                for i = 1:N
                    w = omegaIn(randi(L));
                    omegaOut(i) = w;
                    T = 2*pi/w;
                    n = length(h:h:T);
                    Message = [Message  sin(w*(linspace(h,T,n)))];
                    T_out = [T_out (h:h:T)+T_out(end)];
                end
            end
            
        else
            T = dt;
            if L == 2
                if rem(N,7) ~= 0 || N < 0
                    error('Le nombre de bits doit être un multiple positif de 7.');
                end
                if ~exist('bits','var')
                    bits = zeros(N,1);
                    for i = 1:N
                        w = omegaIn(randi(L));
                        omegaOut(i) = w;
                            if w == omegaIn(2)
                                bits(i) = 1;
%                             else 
%                                 bits(i) = 0;
                            end
                        n = length(h:h:T);
                        Message = [Message  sin(w*(linspace(h,T,n)))];
                        T_out = [T_out (h:h:T)+T_out(end)];
                    end
                else
                    
                    for i = 1:N   
                            if strcmp(bits(i),'1')
                                w = omegaIn(end);
                                omegaOut(i) = w;
                            else 
                                w = omegaIn(1);
                                omegaOut(i) = w;
                            end
                        n = length(h:h:T);
                        Message = [Message  sin(w*(linspace(h,T,n)))];
                        T_out = [T_out (h:h:T)+T_out(end)];
                    end
                end
            
            else
                for i = 1:N
                    w = omegaIn(randi(L));
                    omegaOut(i) = w;
                    n = length(h:h:T);
                    Message = [Message  sin(w*(linspace(h,T,n)))];
                    T_out = [T_out (h:h:T)+T_out(end)];
                end
            end
        end
        Message = Message';
        if L ~= 2
            varargout = {omegaOut};
        elseif drapMsg == 0
            j = 1;
            for i = 1:N/7
                msgCache(i,1:7) = bits(j:j+6);
                j = j+7;
            end

            for i = 1:N/7
                msgClair(i) = bin2dec(num2str(msgCache(i,:)));
            end
            msgClair = char(msgClair);
            varargout = {omegaOut, msgCache, msgClair};
        else
            varargout = {omegaOut, msgCache, msgClair};
        end
        
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