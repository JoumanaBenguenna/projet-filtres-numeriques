function [trame] = avec_recouvrement(signal,taille_trame,recouvrement)

%% Initialisation des longueurs de trames
longueur_signal=length(signal);
longueur_trame=floor(longueur_signal/taille_trame);
trame(:,1)=signal(1:longueur_trame+1);

%% Paramètres de la décomposition
pas_avance=(longueur_trame)-(longueur_trame)*(recouvrement/100);
debut=1+longueur_trame-(longueur_trame*(recouvrement/100));

%% Boucle principale
pas=2;
for i=debut:pas_avance:longueur_signal-longueur_trame
    trame(:,pas)=signal(i:i+longueur_trame);
    pas=pas+1;
end


