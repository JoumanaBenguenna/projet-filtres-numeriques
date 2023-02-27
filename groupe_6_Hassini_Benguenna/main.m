clc;
clear;
close all;

%% Bruitage d'un signal de parole selon un rapport signal à bruit donné

%Bruit blanc gaussien
%% Variables
sigma = 1;
N_samples = 10000;
dirac_fc =zeros(201);
dirac_fc(101) = 1; 
time = 0:200;
RSB = 15;
fs = 10^5;


%Bruit blanc gaussien
WGN = randn(1,N_samples); 
FC_theorical = sigma.^2*dirac_fc; %Fonction d'autocorrélation
FC_biaised = xcorr(WGN,WGN,'biased'); %Estimateur biaisé
FC_unbiaised = xcorr(WGN,WGN,'unbiased'); %estimateur non biaisé
Spectre_Puissance = (abs(fftshift(fft(WGN))).^2)/N_samples; %Spectre de puissance
[Periodogram_WGN, f]= Mon_Welch(WGN,128,10000);
%Periodogram_WGN = cpsd(WGN); %Périodogramme
%psd = spectrogramme(WGN,WGN, window, overlap, nfft, fs)
DSP_WGN = sigma^2*ones(100); %DSP 


%% Bruitage du signal
% Loading the signal
load('fcno03fz.mat');
signal = fcno03fz;
size = length(signal);

% Adding the noise
[Noisy_signal5, snr5] = add_noise_SNR(signal, 5);
[Noisy_signal10, snr10] = add_noise_SNR(signal, 10);
[Noisy_signal15, snr15] = add_noise_SNR(signal, 15);

%% Procédure dite d’addition-recouvrement

%Sans recouvrement
trames_sans_recouvrement = sans_recouvrement(signal);

%Avec recouvrement
trames_avec_recouvrement = avec_recouvrement(signal, 64, 50);


%% Traitement d'une trame d*un signal de parole bruité par un bruit blanc gaussien
%Voir partie suivante (fonction traitement final)



%% Combiner les parties
%Variables
Nombre_trames=64;
Recouvrement=50;

%Chargement du signal
signal_new=load("fcno03fz.mat");
signal_new1 = -signal_new.fcno03fz;

%On récupère de signal bruité de la partie (I) -> Noisy Signal 15

%Décomposition
Trames=avec_recouvrement(Noisy_signal15,Nombre_trames,Recouvrement);

%Fenêtrage avec fenêtre de hamming
[signal_fenetre,wb]=fenetrage_signal(Trames,"hamming"); 

%Traitement trâme par trâme
for i=1:126
     signal_final(:,i) = traitement_final(signal_fenetre(:,i), Noisy_signal15);
end


%% Derniers 
Signal_final=AjouterRecouvrement(real(signal_final),wb,Recouvrement);
Signal_debruite=[zeros(1,floor(length(Trames(:,1))*(Recouvrement/100))) Signal_final];
Signal_debruite=[Signal_debruite zeros(1,length(signal_new1)-length(Signal_debruite))];




%% Representations
figure; 
subplot(3,1,1); 
plot(time,FC_theorical); 
title('Fonction d''autocorrelation d''un bruit blanc gaussien');
xlabel('Temps (s)');
ylabel('Amplitude'); 

subplot(3,1,2); 
plot(FC_biaised); 
title('Fonction d''autocorrelation (Estimateur biaisé)');
xlabel('Temps (s)');
ylabel('Amplitude'); 

subplot(3,1,3); 
plot(FC_unbiaised); 
title('Fonction d''autocorrelation (Estimateur non-biaisé)');
xlabel('Temps (s)');
ylabel('Amplitude');

figure; 
subplot(3,1,1); 
plot(Spectre_Puissance); 
title('Spectre de puissance d''un bruit blanc gaussien');
xlabel('Fréquence (Hz)');
ylabel('Amplitude'); 

subplot(3,1,2); 
plot(f, Periodogram_WGN); 
title('Périodogramme d’une réalisation d''un BBG');
xlabel('Fréquence (Hz)');
ylabel('Amplitude'); 

subplot(3,1,3); 
plot(DSP_WGN); 
title('Densité spectrale de puissance d''un BBG.');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');

figure;
subplot(2,1,1);
plot(signal);
title('Signal de parole non bruité');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(2,1,2);
spectrogram(signal);
title('Spectrogramme du signal de parole non bruité');
xlabel('Fréquences (Hz)');
ylabel('Amplitude');

figure;
subplot(2,1,1);
plot(Noisy_signal5);
title('signal de parole bruité à 5dB');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(2,1,2);
spectrogram(Noisy_signal5);
title('Spectrogramme du signal de parole bruité à 5dB');
xlabel('Fréquences (Hz)');
ylabel('Amplitude');

figure;
subplot(2,1,1);
plot(Noisy_signal10);
title('signal de parole bruité à 10dB');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(2,1,2);
spectrogram(Noisy_signal10);
title('Spectrogramme du signal de parole bruité à 10dB');
xlabel('Fréquences (Hz)');
ylabel('Amplitude');

figure;
subplot(2,1,1);
plot(Noisy_signal15);
title('signal de parole bruité à 15dB');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(2,1,2);
spectrogram(Noisy_signal15);
title('Spectrogramme du signal de parole bruité à 15dB');
xlabel('Fréquences (Hz)');
ylabel('Amplitude');

figure,
plot(Noisy_signal15,'c');

hold on,
plot(Signal_debruite,'m'),

hold on,
plot(signal_new1,'y');

legend("Signal bruité avec SNR de 10dB","Signal après traitement", "Signal d'origine");



figure;
subplot(2,1,1);
plot(Noisy_signal15,'c');
hold on,
plot(Signal_debruite,'m'),
hold on,
plot(signal_new1,'y');
%title('signal de parole bruité à 15dB');
xlabel('Temps (s)');
ylabel('Amplitude');
legend("Signal bruité avec SNR de 15dB","Signal après traitement", "Signal d'origine");

subplot(2,1,2);
spectrogram(Signal_debruite);
title('Spectrogramme du signal débruité');
xlabel('Fréquences (Hz)');
ylabel('Amplitude');


