% help IMC_Controladores_HEN
% load('G_candidata.mat')
% load('IMC_d_matrices.mat')
% [Kc,Taoi,Taod]=IMC_Controladores_HEN(Kp,Tp1,Td,Kc_per,Tp1_per,L_filtro,use_PI_PID)
% % G(1,1)
% Kc: Ganancia proporcional ajustada.
% Taoi: Tiempo integral ajustado.
% Taod: Tiempo derivativo ajustado (solo para PID, 0 en PI y PI mejorado).
%% DESCENTRALIZADA

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
end
for i=1:1:4
    for j=1:1:4
        if i==j
          PID_d(i,j)=tf(pid(Kc(i),Taoi(i)))
        else
          PID_d(i,j)=0;
        end
    end
end
PID_u=PID_d;
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
%% SPAR
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

%% FULL

% load('G_candidata.mat')
% load('IMC_s_matrices.mat')

slots=  [1 2 3 4;
         1 2 3 4;
         1 2 3 4;
         1 2 3 4;];
     
Kc_per=0.2;
Tp_per=1;
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
PID_u=PID_f;
Taod_f=Taod
Taoi_f=Taoi
Kc_f=Kc
% save('PID_s')

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