function [signal_fenetre,fenetre]=fenetrage_signal(signal_decoupe,type_fenetre)

longeur_signal=length(signal_decoupe(1,:));
fenetre=window(type_fenetre,length(signal_decoupe(:,1)));


for jj=1:longeur_signal
    signal_fenetre(:,jj)=signal_decoupe(:,jj).*fenetre;
end