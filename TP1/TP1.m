clear all,
close all,
clc,

%% Partie 2

Ns=500;    %Nombre de symboles
Ds=1e6;     %Debit symbole
Fse=4;      %Facteur sur echantillonnage
Fe=4e6;     %Fréquence echantillonnage
N=2;        %Nombre de bits par symbole
Ntot=Ns*N;  %Nombre de bits
M=4;
SNR = 20;

%Création du flux binaire
bits=randi([0 M-1],1,Ntot);

%Création de la modulation
modi = pskmod(bits, M,pi*3/M,'gray');
sigmas = var(modi);

figure,
plot(modi,'*');

% % Filtrage
%Données du filtre
Span=8;
alpha=0.35;

%Création du filtre
filtre=rcosdesign(alpha,Span,Fse);
s=conv(filtre,modi);

sech = upsample(s,Fse);


% % Tracé du périodogramme
figure,
pwelch(s);


%% Partie 4

%canal1
n = 21;
d2 = -2.5;
d1 = 1.3;

hn2 = canal1(d2,n);

hn1 = canal1(d1,n);


%fvtool(hn1);

%canal2

hn0 = canal1(0,n);

test1 = canal2(1,1,hn0, canal1(1,n));

test2 = canal2(1,1,hn0, canal1(2,n));

test3 = canal2(1,1,hn0, canal1(3,n));

figure,
freqz(test1,1,1024,Fe);
hold all,

test1 = canal2(1,1,hn0, canal1(1,n));hold on,
freqz(test2,1,1024,Fe);
freqz(test3,1,1024,Fe);
legend('Cas 1', 'Cas 2', 'Cas 3');

%% Egalisation

alpha1 = 1;
P = 1000;
L = 1;

varbruit = sigmas/(10^(SNR/10));
bruit=sqrt(varbruit)*(randn(1,P+L)+1i*randn(1,P+L));


vn = [1 alpha1];

rn = conv(modi,vn);

rnb = rn + bruit;

%Q2



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

%Q3

figure,
subplot(2,1,1),
plot(rnb,'*'); 

sigegalise = filter(flip(WFZ(d,:)),1,rnb);

subplot(2,1,2),
plot(sigegalise,'*');
title("Signal après égalisation");




%Q4

Vdag=conj(Vn)';

esp=mean(abs(Sd-flip(WFZ)'.*rn).^2);

prt1 = ((Vdag*Vn+varbruit^2/sigmas^2*diag(1*ones(P+L,1)))^-1)*Vdag;

WMMSE = zeros(P+L,P+L);

for i=1:P+L
    WMMSE(i,:) = prt1(:,1)-esp(1,:)';
end

pn2 = zeros(P,P+L+1);
for i=1:P
    pn2(i,:) = conv(vn,flip(WMMSE(i,:)));
end

Sd2 = zeros(P,1);

for i=1:P
   Sd2(i)=abs(pn2(i,i)).^2/(sum(abs(pn2(i,:)).^2)-abs(pn2(i,i)).^2);
end

[maxii,dd] = max(Sd2);

figure,
subplot(2,1,1),
plot(rn,'*'); 

sigegalise = filter(flip(WMMSE(d,:)),1,rn);

subplot(2,1,2),
plot(sigegalise,'*');
title("Signal après égalisation");
