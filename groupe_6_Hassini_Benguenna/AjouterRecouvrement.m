function [SignalSortie] = AjouterRecouvrement(donneesEntree, poids, pourcentage)

longueurPoids = length(poids);
[hauteurDonneesEntree, longueurDonneesEntree] = size(donneesEntree);
SignalSortie = [];

for indice1 = 1 : longueurDonneesEntree - 1
    for indice2 = 1 : hauteurDonneesEntree - floor(hauteurDonneesEntree * (pourcentage / 100)) - 1
        calculDonneesEntree = donneesEntree(indice2 + floor(hauteurDonneesEntree * (pourcentage / 100)), indice1) + donneesEntree(indice2, indice1 + 1);
        calculPoids = poids(floor(longueurPoids * (pourcentage / 100))) + poids(1);
        SignalTemporaire(indice2) = calculDonneesEntree / calculPoids;
    end
    SignalSortie = [SignalSortie SignalTemporaire];
end
end
