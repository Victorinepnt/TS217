clear,
close all,
clc,

%% Partie 2

Ns=500;    %Nombre de symboles
Ds=1e6;     %Debit symbole
Fse=4;      %Facteur sur echantillonnage
Fe=4e6;     %Fréquence echantillonnage
Te = 1/Fe;
N=2;        %Nombre de bits par symbole
Ntot=Ns*N;  %Nombre de bits
M=4;
SNR = 20;

%Création du flux binaire
bits=randi([0 M-1],1,Ntot);

%Création de la modulation
modi = pskmod(bits, M,pi*3/M,'gray');
sigmas = var(modi);

figure(1),
plot(modi,'*');
title("Modulation QPSK");

% % Filtrage
%Données du filtre
Span=8;
alpha=0.35;

%Création du filtre
filtre=rcosdesign(alpha,Span,Fse);
s=conv(filtre,modi);

sech = upsample(s,Fse);


% % Tracé du périodogramme
figure(2),
pwelch(s);


%% Partie 4

%canal1
n = 21;
d2 = -2.5;
d1 = 1.3;

hn2 = canal1(d2,n);

hn1 = canal1(d1,n);

% fvtool(hn2);
% title("Filtre pour d=-2.5");
% fvtool(hn1);
% title("Filtre pour d=1.3");

%canal2

hn0 = canal1(0,n);

test1 = canal2(1,1,hn0, canal1(1,n));

test2 = canal2(1,1,hn0, canal1(2,n));

test3 = canal2(1,1,hn0, canal1(3,n));

figure(4),
freqz(test1,1,1024,Fe);
hold all,

test1 = canal2(1,1,hn0, canal1(1,n));hold on,
freqz(test2,1,1024,Fe);
freqz(test3,1,1024,Fe);
legend('Cas 1', 'Cas 2', 'Cas 3');
%title("");

%% Egalisation

P=[10,30,100,1000,2000];
alpha1 = 1;
L = 1;

vn = [1 alpha1];

for i=1:length(P)
    %Creation du flux binaire
    bits=randi([0 M-1],1,P(i));
    
    %Creation de la modulation
    modi = pskmod(bits, M,pi*3/M,'gray');
    sigmas = var(modi);

    rn = conv(modi,vn);

    %Egalisation WF

    [sigegalise1,Vn]=egalWF(P(i),L,vn,rn);

    figure,

    subplot(3,1,1)
    plot(modi,'*')
    title("Signal sans bruit pour P=" + P(i));
    
    subplot(3,1,2),
    plot(rn,'*'); 
    title("Signal avec bruit pour P=" + P(i));
    
    subplot(3,1,3),
    plot(sigegalise1,'*');
    title("Signal apres Ã©galisation WF pour P=" + P(i));

    saveas(gcf, "ImageWF" + P(i), 'png');

    %Egalisation WMMSE

    sigegalise2 = egalWMMSE(P(i),L,vn,rn,Vn,sigmas,SNR);
    
    figure,
    
    subplot(3,1,1)
    plot(modi,'*')
    title("Signal sans bruit pour P=" + P(i));
    
    subplot(3,1,2),
    plot(rn,'*'); 
    title("Signal avec bruit pour P=" + P(i));
    
    
    subplot(3,1,3),
    plot(sigegalise2,'*');
    title("Signal apres Ã©galisation WMMSE pour P=" + P(i));
    
    saveas(gcf, "ImageWMMSE" + P(i), 'png');

    sum(sigegalise1==sigegalise2)
end
