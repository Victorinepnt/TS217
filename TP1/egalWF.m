function [sigegalise,Vn] = egalWF(P,L,vn,rn)


step = diag(vn(2)*ones(P+L,1))+diag(vn(1)*ones(P,1),1);
Vn = step(1:P,:);

WFZ = pinv(Vn);

pn = zeros(P,P+L);
for i=1:P
    pn(i,:) = conv(vn,flip(WFZ(i,:)));
end

Sd = zeros(P,1);

for i=1:P
   Sd(i)=abs(pn(i,i)).^2/(sum(abs(pn(i,:)).^2)-abs(pn(i,i)).^2);
end

[maxi,d] = max(Sd);

sigegalise = filter(flip(WFZ(d,:)),1,rn);