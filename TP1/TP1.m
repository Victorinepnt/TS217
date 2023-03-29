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

% % Filtrage
%Données du filtre
Span=8;
alpha=0.35;

%Création du filtre
filtre=rcosdesign(alpha,Span,Fse);
s=conv(filtre,mod);

sech = s(1:Fse:end);


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


