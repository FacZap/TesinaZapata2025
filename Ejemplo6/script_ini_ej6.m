%ini
clear all;
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
load('salida_pt_op.mat');

% sim_time=2000;
sim_time=4000;
t_step=600;
RIC=6;

% los nominales para cada estructura
nominales_u_desc=[zeros(1,1),0.05454159133452416,zeros(1,9)];
nominales_u_spar=[zeros(1,2),0.1218689600950269,zeros(1,4),0.2593056269126446,zeros(1,3)];
nominales_u_full=[zeros(1,1),0.059640541275225376,zeros(1,5),0.1844696794738052,zeros(1,3)];

% %% ELEGIR QUE ESTRUCTURA DE CONTROL SE USA 
%% --- CORRER PARA DESC
initials=nominales_u_desc;  % CORRER PARA DESC
select_area='d';            
load('G_modelo_desc_v1','G_modelo')
load('G_modelo_desc_v3','G_modelo')
load('salida_pt_op_desc.mat','salida_pto_op')
%% --- CORRER PARA SPAR
initials=nominales_u_spar;  % CORRER PARA SPAR
select_area='s';            
load('G_modelo_spar_v1','G_modelo')
load('G_modelo_spar_v3','G_modelo')
load('salida_pt_op_spar.mat','salida_pto_op')
%% --- CORRER PARA FULL
initials=nominales_u_full;  % CORRER PARA FULL
select_area='f';            
load('G_modelo_full_v1','G_modelo')
load('G_modelo_full_v3','G_modelo')
load('salida_pt_op_full.mat','salida_pto_op')
%%
inicializar_entradas;
inicializar_areas;

clc;

%% PARA CAMBIAR VALORES RAPIDAMENTE (para hacer los escalones, identificar un modelo)
% add_value=0;
% mult_value=1;
% nom_ini=initials;
% % nom_fin=[nom_ini(1)+add_value,nom_ini(2)*mult_value,nom_ini(3:11)+add_value]
% nom_fin=nom_ini*mult_value;
% nom_fin(nom_fin == 0) = nom_fin(nom_fin == 0) + add_value;
% 
% nom_fin(9:11)=[0 0 0]
%% PARA CAMBIAR VALORES RAPIDAMENTE (para hacer los escalones, identificar un modelo)
% add_value=0.1;
% mult_value=1.15;
% nom_ini=initials;
% % nom_fin=[nom_ini(1)+add_value,nom_ini(2)*mult_value,nom_ini(3:11)+add_value]
% nom_fin=nom_ini*mult_value;
% nom_fin(nom_fin == 0) = nom_fin(nom_fin == 0) + add_value;
% 
% nom_fin(9:11)=[10 10 10]

%%
% u1_end  = nom_fin(1);
% u2_end  = nom_fin(2);
% u3_end  = nom_fin(3);
% u4_end  = nom_fin(4);
% u5_end  = nom_fin(5);
% u6_end  = nom_fin(6);
% u7_end  = nom_fin(7);
% u8_end  = nom_fin(8);
% u9_end  = nom_fin(9);
% u10_end  = nom_fin(10);
% u11_end  = nom_fin(11);


