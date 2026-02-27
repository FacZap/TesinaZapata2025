ini_comun;
RIC=7;

fhu1_ini=1.5;
fhu2_ini=4.7;
fcu2_ini_a=12.4;
fcu2_ini_b=12.3;

nominales_u_spar=[zeros(1,4),0.033898338995926314,zeros(1,3),fhu1_ini,fhu2_ini,fcu2_ini_a];


% ---
initials=nominales_u_spar;  % CORRER PARA SPAR
select_area='s';            
load('G_modelo_spar_v1','G_modelo')
% load('G_modelo_spar_v2','G_modelo')
load('salida_pt_op_spar.mat','salida_pto_op')
initials_red=[fhu1_ini,fhu2_ini,0.033898338995926314,fcu2_ini_a];

%
inicializar_entradas_ej7;
inicializar_areas_ej7;
clc;

%%
G=G_modelo;
G_EE=dcgain(G);
% lambda=RGA(dcgain(G));

%ordenamiento diagonal
% G completa
Gred_s=G(:,[5 9 10 11]);


% REORDENAR
Greo_s=Gred_s;


Greo_s=Greo_s(:,[2 3 1 4]);

% ELIMINAR ELEMENTOS QUE DEBERIAN SER 0
Gs=Greo_s;

Gs(1,3)=tf(0);
% ---

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
filt=100;
fd1 = tf([0 1],[(filt) 1]);
fd2 = tf([0 1],[(filt) 1]);
fd3 = tf([0 1],[(filt) 1]);
fd4 = tf([0 1],[(filt) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

%
Kimc_u_s = (Gs)^-1*F_d;

K_clasica_s = [eye(size(Kimc_u_s))-Kimc_u_s*Gs]^-1*Kimc_u_s;
K_clasica_2 = [eye(size(Kimc_u_s))-Kimc_u_s*Gs]^-1;


% SPARSE
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

Kimc1=Kimc_u;
Gc1=K_clasica_2;

%% PID
% load('G_candidata.mat')
% load('IMC_s_matrices.mat')

% alternative_sparse_PID_calculation;

slots=  [1 2 3 4;
         1 2 3 4;
         1 2 3 4;
         1 2 3 4;];
     
% Kc_per=0.01;
% Kc_per=0.0015;
Kc_per=0.5;
Tp_per=1;
for i=1:1:4 %fila
    for j=slots(i,:) %columna
        if j~=0
            Kp=dcgain(Gs(i,j));
            Tp=-1/pole(Gs(i,j));
            if Kp~=0 && Tp~=0
               [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,Kc_per,Tp_per,0.5,1);
               Kc(i,j)=kc;Taoi(i,j)=taoi;Taod(i,j)=taod;
            else
                Kc(i,j)=0;Taoi(i,j)=0;Taod(i,j)=0;
            end
        end
        PID_s(i,j)=tf(pid(Kc(i,j),Taoi(i,j)))
%         PID_s(i,j)=tf(pid(Kc(i,j),Taoi(i,j)))
        
    end
end
PID_u=PID_s;
Taod_s=Taod
Taoi_s=Taoi
Kc_s=Kc
% save('PID_s')

for i=1:1:4
    for j=1:1:4
        Kc_d(i,j)=0;
        Taod_d(i,j)=0;
        Taoi_d(i,j)=0;
        Kc_f(i,j)=0;
        Taod_f(i,j)=0;
        Taoi_f(i,j)=0;
        PID_d(i,j)=tf(0);
        PID_f(i,j)=tf(0);
    end
end


