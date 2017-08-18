% Fast Fourier Transform tutorial of MathWorks
% ********************************************
%
% Based on https://nl.mathworks.com/help/matlab/ref/fft.html
% ----------------------------------------------------------

%% 1 - Initialisation
%% 1.1 - Parameters
Fmax = 500;           % Maximal sampled frequency (500 to get signal in ms)
Fs = 2*Fmax;          % Sampling frequency
T = 1/Fs;             % Sampling period
L = 2000;             % Length of signal (> 200)
t = (0:L-1)*T;        % Time vector
f = Fs*(0:(L/2))/L;   % Frequency domain

%% 1.2 - Original and corrupted signals
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);   % Original
X = S + 2*randn(size(t));                   % Corrupted with Zero-Mean Random Noise

%% 1.3 - Preview of the corrupted signal
figTestFFT = figure('units','normalized',...
        'outerposition',[0.06  0.21  0.7 0.7],...
        'Name','Test of Fast Fourier Transform',...
        'Visible','Off');
    
subplot(311);
plot(Fs*t(1:200),X(1:200),'r'); hold on;
plot(Fs*t(1:200),S(1:200),'b');
title('Original and corrupted signals');
xlabel('t (milliseconds)');
ylabel('X(t)');
legend('Corrupted','Original','Location','SouthEast');

%% 2 - Fourier transform of the corrupted signal
Y = fft(X);                     % Fourier Transform
P2 = abs(Y/L);                  % Two-sided spectrum
P1 = P2(1:L/2+1);               % Single-sided spectrum
P1(2:end-1) = 2*P1(2:end-1);

subplot(312);
plot(f,P1,'r')
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% 3 - Fourier transform of the original signal
Y = fft(S);                     % Fourier Transform
P2 = abs(Y/L);                  % Two-sided spectrum
P1 = P2(1:L/2+1);               % Single-sided spectrum
P1(2:end-1) = 2*P1(2:end-1);

subplot(313);
plot(f,P1,'b');
title('Single-Sided Amplitude Spectrum of S(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');

set(figTestFFT,'visible','on'); pause(10^-1);