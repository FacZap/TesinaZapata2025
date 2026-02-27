ini_comun;
RIC=6;

nominales_u_full=[zeros(1,1),0.059640541275225376,zeros(1,5),0.1844696794738052,zeros(1,3)];

% --- CORRER PARA FULL
initials=nominales_u_full;  % CORRER PARA FULL
select_area='f';            
load('G_modelo_full_v1','G_modelo')
load('G_modelo_full_v3','G_modelo')
load('salida_pt_op_full.mat','salida_pto_op')
%
inicializar_entradas;
inicializar_areas;
clc;

%%
G=G_modelo;
G_EE=dcgain(G);
% lambda=RGA(dcgain(G));

%ordenamiento diagonal
% G completa
Gred_f=G(:,[2 8 9 10]);

% REORDENAR
Greo_f=Gred_f;

%  2 8 9 10
%(3)(4)(1)(2)
Greo_f=Greo_f(:,[3 4 1 2]);
%  9 10 2 8
%(1)(2)(3)(4)

Gf=Greo_f;


% G_d_EE = dcgain(Gd);
% 
% %Debido al error planta-modelo, se debe evaluar el T. de Garcia-Morari para
% %asegurar existencia de un ajuste del Filtro que estabilice el lazo cerrado
% GGG = dcgain(Greo_d)*inv(G_d_EE);
% autoval = eig(GGG);
% r_autoval = real(autoval);
% testeo = (r_autoval>0); %vector donde cada elem es 0 o 1. Es 1 si el autoval es >0
% if testeo>0
%     disp('*******************************************************')
%     disp('Teorema garantiza estabilidad/robustez con esta factorización')    
%     disp('*******************************************************')
% else
%     disp('*******************************************************')
%     disp('Teorema NO garantiza estabilidad/robustez con esta factorización')   
%     disp('*******************************************************')
% end

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

Kimc_u_f = (Gf)^-1*F_d;

K_clasica_f = [eye(size(Kimc_u_f))-Kimc_u_f*Gf]^-1*Kimc_u_f;

K_clasica_2_f = [eye(size(Kimc_u_f))-Kimc_u_f*Gf]^-1;


% FULL
% Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s
Kimc_u=Kimc_u_f

% Gimc=Gd
% Gimc=Gs
Gimc=Gf

% K_clasica = K_clasica_d
% K_clasica = K_clasica_s;
K_clasica = K_clasica_f;
% K_clasica_2 = K_clasica_2_d;
% K_clasica_2 = K_clasica_2_s;
K_clasica_2 = K_clasica_2_f;

% build_PID_tf;

switch_var=2;
inicializar_areas

Kimc1=Kimc_u;
Gc1=K_clasica_2;

%% PID

% load('G_candidata.mat')
% load('IMC_s_matrices.mat')

slots=  [1 2 3 4;
         1 2 3 4;
         1 2 3 4;
         1 2 3 4;];
     
Kc_per=0.1;
Tp_per=0.5;
for i=1:1:4 %fila
    for j=slots(i,:) %columna
        if j~=0
            Kp=dcgain(Gf(i,j));
            Tp=-1/pole(Gf(i,j));
            if Kp~=0 && Tp~=0
                [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,Kc_per,Tp_per,0.5,1);
                Kc(i,j)=kc;Taoi(i,j)=taoi;Taod(i,j)=taod;
            else
                Kc(i,j)=0;Taoi(i,j)=0;Taod(i,j)=0;
            end
        end
        PID_f(i,j)=tf(pid(Kc(i,j),Taoi(i,j)))
    end
end
Taod_f=Taod
Taoi_f=Taoi
Kc_f=Kc
% save('PID_f')

for i=1:1:4
    for j=1:1:4
        Kc_s(i,j)=0;
        Taod_s(i,j)=0;
        Taoi_s(i,j)=0;
        Kc_d(i,j)=0;
        Taod_d(i,j)=0;
        Taoi_d(i,j)=0;
        PID_s(i,j)=tf(0);
        PID_d(i,j)=tf(0);
    end
end

