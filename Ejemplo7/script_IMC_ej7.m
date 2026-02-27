%rga/imc
% load('G_modelo_desc_v1','G_modelo')
% load('G_modelo_spar_v1','G_modelo')
% load('G_modelo_full_v1','G_modelo')
% load('G_modelo_desc_v2','G_modelo')
% load('G_modelo_spar_v2','G_modelo')
% load('G_modelo_full_v2','G_modelo')
%%
G=G_modelo;
G_EE=dcgain(G);
% lambda=RGA(dcgain(G));

%ordenamiento diagonal
% G completa
Gred_d=G(:,[8 9 10 11]);
Gred_s=G(:,[5 9 10 11]);
Gred_f=G(:,[2 8 9 10]);

% columna_cero=[tf(0);tf(0);tf(0);tf(0)];
% Gred_d(:,1)=columna_cero; Gred_d(:,3)=columna_cero; Gred_d(:,4)=columna_cero;
% Gred_d(:,5)=columna_cero; Gred_d(:,6)=columna_cero; Gred_d(:,7)=columna_cero; Gred_d(:,8)=columna_cero;
% 
% Gred_s(:,1)=columna_cero; Gred_s(:,2)=columna_cero; Gred_s(:,4)=columna_cero;
% Gred_s(:,5)=columna_cero; Gred_s(:,6)=columna_cero; Gred_s(:,7)=columna_cero; Gred_s(:,11)=columna_cero;
% 
% Gred_f(:,1)=columna_cero; Gred_f(:,3)=columna_cero; Gred_f(:,4)=columna_cero;
% Gred_f(:,5)=columna_cero; Gred_f(:,6)=columna_cero; Gred_f(:,7)=columna_cero; Gred_f(:,11)=columna_cero;

% REORDENAR
Greo_d=Gred_d;
Greo_s=Gred_s;
Greo_f=Gred_f;

%  8 9 10 11
%(3)(1)(2)(4)
Greo_d(:,[1 3])=Greo_d(:,[3 1]);
%  10 9 8 11
%(2)(1)(3)(4)
Greo_d(:,[1 2])=Greo_d(:,[2 1]);
%  9 10 8 11
%(1)(2)(3)(4)

Greo_s=Greo_s(:,[2 3 1 4]);

%  2 8 9 10
%(3)(4)(1)(2)
Greo_f=Greo_f(:,[3 4 1 2]);
%  9 10 2 8
%(1)(2)(3)(4)

% ELIMINAR ELEMENTOS QUE DEBERIAN SER 0
Gd=Greo_d;
Gs=Greo_s;
Gf=Greo_f;

Gd([1 2 4],3)=tf(0);
Gs(1,3)=tf(0);
% ---

% idx1 = 2;
% idx2 = 4;
% G_d(:,[idx1,idx2]) = fliplr(G_d(:,[idx1,idx2]));

% NO HAY TIEMPOS MUERTOS
% polos=-1./pole(G_d(:,1))+1;
% polos=[polos;-1./pole(G_d(:,2))+1];
% polos=[polos;-1./pole(G_d(:,3))+1];
% polos=[polos;-1./pole(G_d(:,4))+1];
% polo_max_d=max(polos)
% polos=-1./pole(G_d(:,1))+1;
% polos=[polos;-1./pole(G_s(:,2))+1];
% polos=[polos;-1./pole(G_s(:,3))+1];
% polos=[polos;-1./pole(G_s(:,4))+1];
% polo_max_s=max(polos)

G_d_EE = dcgain(Gd);

%Debido al error planta-modelo, se debe evaluar el T. de Garcia-Morari para
%asegurar existencia de un ajuste del Filtro que estabilice el lazo cerrado
GGG = dcgain(Greo_d)*inv(G_d_EE);
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
% filt=20;
filt=10;
fd1 = tf([0 1],[(filt) 1]);
fd2 = tf([0 1],[(filt) 1]);
fd3 = tf([0 1],[(filt) 1]);
fd4 = tf([0 1],[(filt) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

%%

Kimc_u_d = (Gd)^-1*F_d;
Kimc_u_s = (Gs)^-1*F_d;
Kimc_u_f = (Gf)^-1*F_d;

K_clasica_d = [eye(size(Kimc_u_d))-Kimc_u_d*Gd]^-1*Kimc_u_d;
K_clasica_s = [eye(size(Kimc_u_s))-Kimc_u_s*Gs]^-1*Kimc_u_s;
K_clasica_f = [eye(size(Kimc_u_f))-Kimc_u_s*Gf]^-1*Kimc_u_f;


%% DESCEN
Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s
% Kimc_u=Kimc_u_f

Gimc=Gd
% Gimc=Gs
% Gimc=Gf

K_clasica = K_clasica_d
% K_clasica = K_clasica_s;
% K_clasica = K_clasica_f;

switch_var=0;
aE112=a112_d;
aE121=a121_d;
aE213=a213_d;
aE222=a222_d;

%% SPARSE
% Kimc_u=Kimc_u_d
Kimc_u=Kimc_u_s
% Kimc_u=Kimc_u_f

% Gimc=Gd
Gimc=Gs
% Gimc=Gf

% K_clasica = K_clasica_d
K_clasica = K_clasica_s;
% K_clasica = K_clasica_f;

switch_var=1
aE112=a112_s;
aE121=a121_s;
aE213=a213_s;
aE222=a222_s;

%% FULL
% Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s
Kimc_u=Kimc_u_f

% Gimc=Gd
% Gimc=Gs
Gimc=Gf

% K_clasica = K_clasica_d
% K_clasica = K_clasica_s;
K_clasica = K_clasica_f;

switch_var=2;
aE112=a112_f;
aE121=a121_f;
aE213=a213_f;
aE222=a222_f;
