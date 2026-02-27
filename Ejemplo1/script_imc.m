INI;
%%
%rga/imc
load('G_candidata','G')
G_EE=dcgain(G);
lambda=RGA(dcgain(G));

%ordenamiento diagonal
% G completa
Gred=G(:,[1 2 3 7]);
G_d=Gred; G_s=Gred; % G_f=Gred;
G_reo=Gred;

G_d(2,1)=tf(0); G_d(3,1)=tf(0); G_d(4,1)=tf(0); %primera columna
G_d(2,2)=tf(0); G_d(4,2)=tf(0); %segunda columna, G(1,2) ya es cero
G_d(2,3)=tf(0); %tercera columna, G(1,3) y G(3,3) ya son cero

% FULL
% igual que sparse

% idx1 = 2;
% idx2 = 4;
% G_d(:,[idx1,idx2]) = fliplr(G_d(:,[idx1,idx2]));

% 1 2 3 7
% Swap column 4 with 2
G_d(:, [2 4]) = G_d(:, [4 2]);
G_reo(:, [2 4]) = G_reo(:, [4 2]);
G_s(:, [2 4]) = G_s(:, [4 2]);
% 1 7 3 2
% Swap column 3 with 4 (after the first swap)
G_d(:, [3 4]) = G_d(:, [4 3]);
G_reo(:, [3 4]) = G_reo(:, [4 3]);
G_s(:, [3 4]) = G_s(:, [4 3]);
% 1 7 2 3

% NO HAY TIEMPOS MUERTOS
polos=-1./pole(G_d(:,1))+1;
polos=[polos;-1./pole(G_d(:,2))+1];
polos=[polos;-1./pole(G_d(:,3))+1];
polos=[polos;-1./pole(G_d(:,4))+1];
polo_max_d=max(polos)
polos=-1./pole(G_d(:,1))+1;
polos=[polos;-1./pole(G_s(:,2))+1];
polos=[polos;-1./pole(G_s(:,3))+1];
polos=[polos;-1./pole(G_s(:,4))+1];
polo_max_s=max(polos)

G_d_EE = dcgain(G_d);

%Debido al error planta-modelo, se debe evaluar el T. de Garcia-Morari para
%asegurar existencia de un ajuste del Filtro que estabilice el lazo cerrado
GGG = dcgain(G_reo)*inv(G_d_EE);
autoval = eig(GGG);
r_autoval = real(autoval);
testeo = (r_autoval>0); %vector donde cada elem es 0 o 1. Es 1 si el autoval es >0
if testeo>0
    disp('*******************************************************')
    disp('Teorema garantiza estabilidad/robustez con esta factorización')    
    disp('*******************************************************')
else
    disp('*******************************************************')
    disp('Teorema NO garantiza estabilidad/robustez con esta factorización')   
    disp('*******************************************************')
end

% 01/07/25 20:00: "Mejor caso" hipotético (más agresivo), ~0.25*maxTau
% 01/07/25 20:00: "Mejor caso" hipotético (más agresivo), ~maxTau
filt=100;
fd1 = tf([0 1],[(filt) 1]);
fd2 = tf([0 1],[(filt) 1]);
fd3 = tf([0 1],[(filt) 1]);
fd4 = tf([0 1],[(filt) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

Kimc_u_d = (G_d)^-1*F_d;
Kimc_u_s = (G_s)^-1*F_d;

%% DESCEN
Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s

Gimc=G_d
% Gimc=G_s

K_clasica_d = [eye(size(Kimc_u_d))-Kimc_u_d*G_d]^-1*Kimc_u_d;
K_clasica_s = [eye(size(Kimc_u_s))-Kimc_u_s*G_s]^-1*Kimc_u_s;
% K_clasica = K_clasica_s;
K_clasica = K_clasica_d

% implementacion v2 pato
K_clasica_1 = Kimc_u;
K_clasica_2 = [eye(size(Kimc_u))-Kimc_u*Gimc]^-1;

%% SPARSE
% Kimc_u=Kimc_u_d
Kimc_u=Kimc_u_s

% Gimc=G_d
Gimc=G_s

K_clasica_d = [eye(size(Kimc_u_d))-Kimc_u_d*G_d]^-1*Kimc_u_d;
K_clasica_s = [eye(size(Kimc_u_s))-Kimc_u_s*G_s]^-1*Kimc_u_s;
K_clasica = K_clasica_s;
% K_clasica = K_clasica_d

% implementacion v2 pato
K_clasica_1 = Kimc_u;
K_clasica_2 = [eye(size(Kimc_u))-Kimc_u*Gimc]^-1;

