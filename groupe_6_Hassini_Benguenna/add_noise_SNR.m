function [out_signal, SNR_new] = add_noise_SNR(signal, SNR)

    signal_len = length(signal); % longeur du signal                                                                                          

    %% Génération du bruit                                                                                                                    
    Noise = randn(signal_len,1); % Bruit Blanc Gaussien                                                                                       

    %% Calcul de Puissances                                                                                                                   
    Signal_power = sum(signal.^2); % Puissance du signal d'entrée power                                                                       
    Noise_power = sum(Noise.^2); % Puissance du BBG                                                                                           

    %% Facteur de multiplication                                                                                                              

    sigma = sqrt(10^(-SNR/10)*(Signal_power/Noise_power));
    Noise = Noise*sigma;
    out_signal = signal + Noise;



    SNR_new = snr(out_signal, Noise);

end

