clear all,
close all,
clc,

%% Partie 2

Ns=5000;    %Nombre de symboles
Ds=1e6;     %Debit symbole
Fse=4;      %Facteur sur echantillonnage
Fe=4e6;     %Fréquence echantillonnage
N=2;        %Nombre de bits par symbole
Ntot=Ns*N;  %Nombre de bits
M=4;

%Création du flux binaire
bits=randi([0 1],1,Ntot);

%Création de la modulation
mod = pskmod(bits, M,pi*3/M,'gray');
figure,
plot(mod,'*');

% % Filtrage
%Données du filtre
Span=8;
alpha=0.35;

%Création du filtre
filtre=rcosdesign(alpha,Span,Fse);
s=conv(filtre,mod);

sech = upsample(s,Fse);


% % Tracé du périodogramme

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

vn = [1 alpha1];

sigcanal = conv(sech,hn1);

sigfiltre = conv(sigcanal,vn);

sigech = sigfiltre(Span:Fse:end);

%Q2

P = 100;
L = 1;

step = diag(vn(2)*ones(P+L,1))+diag(vn(1)*ones(P,1),1);
Vn = step(1:P,:);

pseudoinv = pinv(Vn);

pn = zeros(P,P+L);
for i=1:P
    pn(i,:) = conv(vn,flip(pseudoinv(i,:)));
end

Sd = zeros(P,1);

for i=1:P
   Sd(i)=abs(pn(i,i)).^2/(sum(abs(pn(i,:)).^2)-abs(pn(i,i)).^2);
end

[coeffegaliseur,d] = max(Sd);

%Q3

figure,
subplot(2,1,1),
plot(sigech,'*'); 

sigegalise = filter(coeffegaliseur,1,sigech);

subplot(2,1,2),
plot(sigegalise,'*');
title("Signal après égalisation");













