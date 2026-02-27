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
% load('salida_pt_op.mat');

sim_time=2000;
t_step=600;
RIC=7;

% los nominales para cada estructura
nominales_u_desc=[zeros(1,7),0.09339684396540276,zeros(1,3)];
fhu1_ini=1.5;
fhu2_ini=4.7;
fcu2_ini_a=12.4;
fcu2_ini_b=12.3;
nominales_u_desc=[zeros(1,7),0.09339684396540276,fhu1_ini,fhu2_ini,fcu2_ini_a];
nominales_u_spar=[zeros(1,4),0.033898338995926314,zeros(1,3),fhu1_ini,fhu2_ini,fcu2_ini_a];
nominales_u_full=[zeros(1,1),0.12857054742755492,zeros(1,5),0.10288666136733358,fhu1_ini,fhu2_ini,fcu2_ini_b];

%% ELEGIR QUE ESTRUCTURA DE CONTROL SE USA 
initials=nominales_u_desc;  % CORRER PARA DESC
select_area='d';            
load('G_modelo_desc_v1','G_modelo')
% load('G_modelo_desc_v2','G_modelo')
load('salida_pt_op_desc.mat','salida_pto_op')
initials_red=[fhu1_ini,fhu2_ini,0.09339684396540276,fcu2_ini_a];
%% ---
initials=nominales_u_spar;  % CORRER PARA SPAR
select_area='s';            
load('G_modelo_spar_v1','G_modelo')
% load('G_modelo_spar_v2','G_modelo')
load('salida_pt_op_spar.mat','salida_pto_op')
initials_red=[fhu1_ini,fhu2_ini,0.033898338995926314,fcu2_ini_a];
%% ---
initials=nominales_u_full;  % CORRER PARA FULL
select_area='f';            
load('G_modelo_full_v1','G_modelo')
% load('G_modelo_full_v2','G_modelo')
load('salida_pt_op_full.mat','salida_pto_op')
initials_red=[fhu1_ini,fhu2_ini,0.12857054742755492,0.10288666136733358];
%%
inicializar_entradas_ej7;
inicializar_areas_ej7;
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
add_value=0.1;
mult_value=1.15;
nom_ini=initials;
% nom_fin=[nom_ini(1)+add_value,nom_ini(2)*mult_value,nom_ini(3:11)+add_value]
nom_fin=nom_ini*mult_value;
nom_fin(nom_fin == 0) = nom_fin(nom_fin == 0) + add_value;

nom_fin(9:11)=[10 10 10]

