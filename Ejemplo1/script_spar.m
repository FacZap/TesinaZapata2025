%rga/imc
INI;
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
filt=10;
fd1 = tf([0 1],[(filt) 1]);
fd2 = tf([0 1],[(filt) 1]);
fd3 = tf([0 1],[(filt) 1]);
fd4 = tf([0 1],[(filt) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

Kimc_u_d = (G_d)^-1*F_d;
Kimc_u_s = (G_s)^-1*F_d;

%% SPARSE
% Kimc_u=Kimc_u_d
Kimc_u=Kimc_u_s

% Gimc=G_d
Gimc=G_s

K_clasica_d = [eye(size(Kimc_u_d))-Kimc_u_d*G_d]^-1*Kimc_u_d;
K_clasica_s = [eye(size(Kimc_u_s))-Kimc_u_s*G_s]^-1*Kimc_u_s;
K_clasica = K_clasica_s;
% K_clasica = K_clasica_d

select_area='s'

%%

% help IMC_Controladores_HEN
% load('G_candidata.mat')
% load('IMC_d_matrices.mat')
% [Kc,Taoi,Taod]=IMC_Controladores_HEN(Kp,Tp1,Td,Kc_per,Tp1_per,L_filtro,use_PI_PID)
% % G(1,1)
% Kc: Ganancia proporcional ajustada.
% Taoi: Tiempo integral ajustado.
% Taod: Tiempo derivativo ajustado (solo para PID, 0 en PI y PI mejorado).

Kc=zeros(1,4);
Taoi=zeros(1,4);
Taod=zeros(1,4);
% for i=1:1:4
%     for j=1:1:7
%         Kp=dcgain(G(i,j));
%         Tp=-1/pole(G(i,j));
%         if Kp~=0 && Tp~=0
%             [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,0.9,1,0.5,1);
%             Kc(i,j)=kc,Taoi(i,j)=taoi,Taod(i,j)=taod;
%         else
%             Kc(i,j)=0,Taoi(i,j)=0,Taod(i,j)=0;
%         end
%     end
% end
Kc_per=0.1;
Tp_per=1;
for i=1:1:4
    Kp=dcgain(G_d(i,i));
    Tp=-1/pole(G_d(i,i));
    if Kp~=0 && Tp~=0
        [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,Kc_per,Tp_per,0.5,1);
        Kc(i)=kc;Taoi(i)=taoi;Taod(i)=taod;
    else
        Kc(i)=0;Taoi(i)=0;Taod(i)=0;
    end
end
% Taod(2)=1;
Taod_d=Taod
Taoi_d=Taoi
Kc_d=Kc
clear Kc Taoi Taod
% save('PID_d')
%%
% Matriz de PIDs?
% help pid
% pid(1,1)
% pid(1,1,1)
% help pidstd
% pidstd(1,1)
% pidstd(1,1,1)
% pause
%%
% load('G_candidata.mat')
% load('IMC_s_matrices.mat')

slots=  [1 2 3 4;
         1 2 3 4;
         1 2 3 4;
         1 2 3 4;];
     
Kc_per=0.1;
Tp_per=1;
for i=1:1:4 %fila
    for j=1:1:4 %columna
        if j~=0
            Kp=dcgain(G_s(i,j));
            Tp=-1/pole(G_s(i,j));
            if Kp~=0 && Tp~=0
                [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,Kc_per,Tp_per,0.5,1);
                Kc(i,j)=kc;Taoi(i,j)=taoi;Taod(i,j)=taod;
            else
                Kc(i,j)=0;Taoi(i,j)=0;Taod(i,j)=0;
            end
        end
    end
end
Taod_s=Taod
Taoi_s=Taoi
Kc_s=Kc
% save('PID_s')


