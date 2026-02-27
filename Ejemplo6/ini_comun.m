%ini
clearvars -except k_table X Y Z omitted tiempos k_incr evolucion index increment aux_matrix
close all;
for i=1:4
    for j=1:11
        G_modelo(i,j)=tf(0);
    end
end

global u_minimo u_maximo u_nominal delta_u y_minimo y_maximo y_nominal delta_y
global d_minimo d_maximo   df_minimo df_maximo df_nominal delta_df

s1= 30;%ganancia de las válvulas

% global Ts
% Defino el tiempo_ds de muestreo. (Ts=1seg)
% Ts=0.5;
%   para iniciar los intercambiadores
est = 1; 

% datos
Thin1=543; fh1=18;  hh1=1;
Thin2=493; fh2=22;  hh2=1;
Tcin1=323; fc1=20;  hc1=1;
Tcin2=433; fc2=50;  hc2=1;
Tcuin=288; Tcuout=293; hhu=1;  
Thuin=523; Thuout=523; hcu=1;
sp1=433; sp2=333; sp3=483; sp4=483;
% fcu1=36;
% fcu2=44;
% fhu2=14.8;
fcu1=1.45;
fcu2=5;
fhu2=15;
setpoints=[160+273 60+273 210+273 210+273];

% sim_time=2000;
sim_time=60000;
t_step=20000;
t_sp_change=0;
delta_sp_1=0;
delta_sp_2=0;
delta_sp_3=0;
delta_sp_4=0;