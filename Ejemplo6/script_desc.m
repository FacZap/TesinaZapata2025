ini_comun;
RIC=6;

% los nominales para cada estructura
nominales_u_desc=[zeros(1,1),0.05454159133452416,zeros(1,9)];
initials=nominales_u_desc;  % CORRER PARA DESC
select_area='d';            
load('G_modelo_desc_v1','G_modelo')
load('G_modelo_desc_v3','G_modelo')
load('salida_pt_op_desc.mat','salida_pto_op')
%
inicializar_entradas;
inicializar_areas;

clc;

%% IMC

G=G_modelo;
G_EE=dcgain(G);
% lambda=RGA(dcgain(G));

%ordenamiento diagonal
% G completa
Gred_d=G(:,[2 9 10 11]);

% REORDENAR
Greo_d=Gred_d;

%  2 9 10 11
%(3)(1)(2)(4)
Greo_d(:,[1 3])=Greo_d(:,[3 1]);
%  10 9 2 11
%(2)(1)(3)(4)
Greo_d(:,[1 2])=Greo_d(:,[2 1]);
%  9 10 2 11
%(1)(2)(3)(4)


% ELIMINAR ELEMENTOS QUE DEBERIAN SER 0
Gd=Greo_d;

Gd(1,3)=tf(0);
% ---

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
filt1=300;
filt2=300;
fd1 = tf([0 1],[(filt1) 1]);
fd2 = tf([0 1],[(filt1) 1]);
fd3 = tf([0 1],[(filt2) 1]);
fd4 = tf([0 1],[(filt2) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

%
Kimc_u_d = (Gd)^-1*F_d;
K_clasica_d = [eye(size(Kimc_u_d))-Kimc_u_d*Gd]^-1*Kimc_u_d;
K_clasica_2_d = [eye(size(Kimc_u_d))-Kimc_u_d*Gd]^-1;

% DESCEN
Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s
% Kimc_u=Kimc_u_f

Gimc=Gd
% Gimc=Gs
% Gimc=Gf

K_clasica = K_clasica_d
% K_clasica = K_clasica_s;
% K_clasica = K_clasica_f;
K_clasica_2 = K_clasica_2_d;
% K_clasica_2 = K_clasica_2_s;
% K_clasica_2 = K_clasica_2_f;

% build_PID_tf;

switch_var=0;
inicializar_areas

Kimc1=Kimc_u;
Gc1=K_clasica_2;

%% PID

Kc=zeros(1,4);
Taoi=zeros(1,4);
Taod=zeros(1,4);

Kc_per=0.5;
Tp_per=1;
for i=1:1:4
    Kp=dcgain(Gd(i,i));
    Tp=-1/pole(Gd(i,i));
    if Kp~=0 && Tp~=0
        [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,Kc_per,Tp_per,0.5,1);
        Kc(i)=kc;Taoi(i)=taoi;Taod(i)=taod;
    else
        Kc(i)=0;Taoi(i)=0;Taod(i)=0;
    end
%     PID_d(i)=tf(pid(Kc(i),Taoi(i)))
    for j=1:1:4
        if i==j
            PID_d(i,j)=tf(pid(Kc(i),Taoi(i)))
        else
            PID_d(i,j)=tf(0);
        end
    end
end

% Taod(2)=1;
Taod_d=Taod
Taoi_d=Taoi
Kc_d=Kc
% save('PID_d')

for i=1:1:4
    for j=1:1:4
        Kc_s(i,j)=0;
        Taod_s(i,j)=0;
        Taoi_s(i,j)=0;
        Kc_f(i,j)=0;
        Taod_f(i,j)=0;
        Taoi_f(i,j)=0;
        PID_s(i,j)=tf(0);
        PID_f(i,j)=tf(0);
    end
end


