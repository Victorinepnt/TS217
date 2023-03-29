clear,
close all,
clc,

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
mod = pskmod(bits, M,pi*3/M,'gray',PlotConstellation=true);

%% Filtrage
%Données du filtre
Span=8;
alpha=0.35;

%Création du filtre
filtre=rcosdesign(alpha,Span,Fse);
s=conv(filtre,mod);

%% Tracé du périodogramme

