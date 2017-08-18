function [f,p] = tfPerso(t,x)

%% 1 - Initialisation
Fs = 1/(t(2)-t(1));          % Sampling frequency
L = length(x);               % Length of signal   
f = Fs*(0:(L/2))/L;          % Frequency domain

%% 2 - Fourier transform
Y = fft(x);                  % Fourier Transform
P2 = abs(Y/L);               % Two-sided spectrum
P1 = P2(1:round(L/2)+1);     % Single-sided spectrum

%% 3 - Final spectrum
p = 2*P1(2:end-1);              
Lf = length(f); Lp = length(p);
if Lf > Lp
    f = f(1:Lp);
else
    p = p(1:Lf);
end