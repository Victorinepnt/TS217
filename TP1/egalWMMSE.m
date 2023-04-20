function [sigegalise] = egalWMMSE(P,L,vn,rn,Vn,sigmas,SNR)

varbruit = sigmas/(10^(SNR/10));

Vdag=conj(Vn)';

WMMSE = ((Vdag*Vn+varbruit^2/sigmas^2*diag(1*ones(P+L,1)))^-1)*Vdag;

pn2 = zeros(P,P+L);
for i=1:P
    pn2(i,:) = conv(vn,flip(WMMSE(i,:)));
end

Sd2 = zeros(P,1);

for i=1:P
   Sd2(i)=abs(pn2(i,i)).^2/(sum(abs(pn2(i,:)).^2)-abs(pn2(i,i)).^2);
end

[maxi,d] = max(Sd2);

sigegalise = filter(flip(WMMSE(d,:)),1,rn);