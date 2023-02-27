function [signal_traite] = traitement_final(trame_originale, signal_bruit)

    % extraire un échantillon de 10000 éléments du signal bruiteux
    echantillon = signal_bruit(1:10000);
    % calculer la puissance du bruit à partir de l'échantillon
    puissance_bruit = var(echantillon);
    % transformer la trame en fréquence
    fft_trame = fft(trame_originale);
    % calculer la longueur de la trame
    longueur_trame = length(fft_trame);
    % estimer la DSP (densité spectrale de puissance)
    dsp_estimee = ones(longueur_trame,1)*puissance_bruit;
    % améliorer le signal en utilisant la formule donnée
    signal_ameliore = ((abs(fft_trame)).^2)/longueur_trame - dsp_estimee;
    % vérifier si tous les éléments du signal amélioré sont positifs
    for i=1:longueur_trame
        if(signal_ameliore(i)<0)
            signal_ameliore(i) = 0;
        end
    end
    % calculer la racine carrée de n*signal_ameliore
    racine_carre = sqrt(longueur_trame*signal_ameliore);
    % calculer le signal traité en utilisant la formule donnée
    signal_traite_fft = racine_carre.*exp(1j*angle(fft_trame));
    % transformer le signal traité en domaine temporel
    signal_traite = ifft(signal_traite_fft)';