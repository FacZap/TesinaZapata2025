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
Taod
Taoi
Kc
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
    for j=slots(i,:) %columna
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


