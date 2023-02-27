function [X, f] = Mon_Welch(x, Nfft, Fe)
length_sig=length(x);
nb_fft=ceil(length_sig/20);
M=zeros(100,Nfft);
    
l=0;
for i=1:Nfft:nb_fft
    l=l+1;
    M(l,:)=fftshift(fft(x(i:i+Nfft-1),Nfft),Nfft);
end
m=mean(abs(M).^2,1);
X=[m(Nfft/2+1:Nfft),m(1:Nfft/2)];
f=-Fe/2:Fe/Nfft:Fe/2-Fe/Nfft+1;
  
    
end