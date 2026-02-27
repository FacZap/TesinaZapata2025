% clear all;
load G_candidata.mat %modelo desescalado
select_area='d'

%% Selección proceso para control. Ordenado diagonal.

G0n=G(:,[1,7,2,3]); % modelo original, ordenado diagonal
G0nss=dcgain(G0n);

%% Analisis proceso
Lambda=G0nss.*(inv(G0nss))';
[U1,S1,V1]=svd(G0nss); 
NC=cond(G0nss); 


%%
% controllers design IMC. 

% % Invertible Process (sin tiempo muerto)
Gn1= G0n; %invertible (no tiene t muerto, ordenado diagonal

%%
% modelo invertible, ordenado diagonal, DEC / Full / Sparse

Gvn1 = [Gn1(1,1) 0 0 0; %DEC
        0 Gn1(2,2) 0 0;
        0 0 Gn1(3,3) 0;
        0 0 0 Gn1(4,4)];
    
% Gvn1 = [Gn1(1,1) Gn1(1,2) Gn1(1,3) Gn1(1,4); %Full
%         Gn1(2,1) Gn1(2,2) Gn1(2,3) Gn1(2,4);
%         Gn1(3,1) Gn1(3,2) Gn1(3,3) Gn1(3,4);
%         Gn1(4,1) Gn1(4,2) Gn1(4,3) Gn1(4,4)];  
    
% Gvn1 = [Gn1(1,1) 0          0           0; %sparse
%         Gn1(2,1) Gn1(2,2)   Gn1(2,3)    Gn1(2,4);
%         Gn1(3,1) 0          Gn1(3,3)    0;
%         Gn1(4,1) 0          Gn1(4,3)    Gn1(4,4)];     
       
Gvn1_ee=dcgain(Gvn1);

%%
%Debido al error planta-modelo, se debe evaluar el T. de Garcia-Morari para
%asegurar existencia de un ajuste del Filtro que estabilice el lazo cerrado

GGG = G0nss*(Gvn1_ee)^-1;
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

%%
% Filtro
% Valores máximos por canal de entrada: 0
filt=5
fd1 = tf([0 1],[filt 1]);%+10 +80
fd2 = tf([0 1],[filt 1]);%+2 +50
fd3 = tf([0 1],[filt 1]);
fd4 = tf([0 1],[filt 1]);

F_d = [fd1 0 0 0;
       0 fd2 0 0;
       0 0 fd3 0;
       0 0 0 fd4];
%%
%Controlador IMC dec
Kimc1 = (Gvn1)^-1*F_d;
%Kimc1=minreal(Kimc1);

%%
%Controlador equivalente para estructura Feedback
Gc1=(eye(4)-Kimc1*Gvn1)^-1*Kimc1;
Gc1=(eye(4)-Kimc1*Gvn1)^-1
Gc1=minreal(Gc1);

%% ----intento calculo PID-----

Kc=zeros(1,4);
Taoi=zeros(1,4);
Taod=zeros(1,4);
% for i=1:1:4
%     for j=1:1:7
%         Kp=dcgain(G(i,j));
%         Tp=-1/pole(G(i,j));
%         if Kp~=0 && Tp~=0
%             [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,0.9,1,5,1);
%             Kc(i,j)=kc,Taoi(i,j)=taoi,Taod(i,j)=taod;
%         else
%             Kc(i,j)=0,Taoi(i,j)=0,Taod(i,j)=0;
%         end
%     end
% end
Kc_per=1;
Tp_per=1;
for i=1:1:4
    Kp=dcgain(G_d(i,i));
    Tp=-1/pole(G_d(i,i));
    if Kp~=0 && Tp~=0
        [kc,taoi,taod]=IMC_Controladores_HEN(Kp,Tp,0,0.1,Tp_per,5,1);
        Kc(i)=kc;Taoi(i)=taoi;Taod(i)=taod;
    else
        Kc(i)=0;Taoi(i)=0;Taod(i)=0;
    end
end
% Taod(2)=1;
Taod_d=Taod
Taoi_d=Taoi
Kc_d=Kc
clear Taod Taoi Kc




