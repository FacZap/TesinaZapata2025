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
t_step=300;

% los nominales para cada estructura
% nominales_u_desc=[zeros(1,7),0.09339684396540276,zeros(1,3)];
fhu1_ini=1.5;
fhu2_ini=4.7;
fcu2_ini_a=12.4;
% fcu2_ini_b=12.3;
fcu2_ini_b=12.4;

%%
nominales_u_desc=[zeros(1,7),0.09339684396540276,fhu1_ini,fhu2_ini,fcu2_ini_a];
initials=nominales_u_desc;
%%
nominales_u_spar=[zeros(1,4),0.033898338995926314,zeros(1,3),fhu1_ini,fhu2_ini,fcu2_ini_a];
initials=nominales_u_spar;
%%
nominales_u_full=[zeros(1,1),0.12857054742755492,zeros(1,5),0.10288666136733358,fhu1_ini,fhu2_ini,fcu2_ini_b];
initials=nominales_u_full;
%% Datos de La corriente:

Thin1=543; fh1=18;  hh1=1;
Thin2=493; fh2=22;  hh2=1;
Tcin1=323; fc1=20;  hc1=1;
Tcin2=433; fc2=50;  hc2=1;
Tcuin=288; Tcuout=288; hhu=1;  
Thuin=523; Thuout=523; hcu=1;
sp1=433; sp2=333; sp3=483; sp4=483;

u1_in=0; u1_end=0; u2_in=0; u2_end=0; u3_in=0; u3_end=0; u4_in=0; u4_end=0; 
u5_in=0; u5_end=0; u6_in=0; u6_end=0; u7_in=0; u7_end=0; u8_in=0; u8_end=0; 
u9_in=0; u9_end=0; u10_in=0; u10_end=0; u11_in=0; u11_end=0;
d1_in=0; d1_end=0; d2_in=0; d2_end=0; d3_in=0; d3_end=0; d4_in=0; d4_end=0; 
d5_in=0; d5_end=0; d6_in=0; d6_end=0; d7_in=0; d7_end=0; d8_in=0; d8_end=0; 


u1_in=initials(1); u1_end=initials(1); u2_in=initials(2); u2_end=initials(2); u3_in=initials(3); u3_end=initials(3);
u4_in=initials(4); u4_end=initials(4); u5_in=initials(5); u5_end=initials(5); u6_in=initials(6); u6_end=initials(6);
u7_in=initials(7); u7_end=initials(7); u8_in=initials(8); u8_end=initials(8); u9_in=initials(9); u9_end=initials(9);
u10_in=initials(10); u10_end=initials(10); u11_in=initials(11); u11_end=initials(11);
d1_in=0; d1_end=0; d2_in=0; d2_end=0; d3_in=0; d3_end=0; d4_in=0; d4_end=0; 
d5_in=0; d5_end=0; d6_in=0; d6_end=0; d7_in=0; d7_end=0; d8_in=0; d8_end=0; 

%%
select_area='d';
inicializar_areas_ej7;
load('salida_pt_op_desc.mat')
%%
select_area='s';
inicializar_areas_ej7;
load('salida_pt_op_spar.mat')
%%
select_area='f';
inicializar_areas_ej7;
load('salida_pt_op_full.mat')
%%
add_value=0;
mult_value=1;
nom_ini=initials;
% nom_fin=[nom_ini(1)+add_value,nom_ini(2)*mult_value,nom_ini(3:11)+add_value]
nom_fin=nom_ini*mult_value;
nom_fin(nom_fin == 0) = nom_fin(nom_fin == 0) + add_value;

nom_fin(9:11)=[0 0 0]
%%
add_value=0.1;
mult_value=1.15;
nom_ini=initials;
% nom_fin=[nom_ini(1)+add_value,nom_ini(2)*mult_value,nom_ini(3:11)+add_value]
nom_fin=nom_ini*mult_value;
nom_fin(nom_fin == 0) = nom_fin(nom_fin == 0) + add_value;

nom_fin(9:11)=[10 10 10]

%%

sim('Red_problema7_lazo_abierto_v2021');

Thout_1_ini= yout(end,1); Thout_2_ini= yout(end,2);
Tcout_1_ini= yout(end,3); Tcout_2_ini= yout(end,4);
salida_pto_op=[Thout_1_ini Thout_2_ini Tcout_1_ini Tcout_2_ini];
%%
save('salida_pt_op_desc_v2021.mat','salida_pto_op')
% save('salida_pt_op_spar.mat','salida_pto_op')
save('salida_pt_op_spar_v2021.mat','salida_pto_op')
% save('salida_pt_op_full.mat','salida_pto_op')
save('salida_pt_op_full_v2021.mat','salida_pto_op')
save('T_out_iniciales.mat','Thout_1_ini','Thout_2_ini','Tcout_1_ini','Tcout_2_ini')

% save('xFinal_problema_6_lazo_abierto.mat', 'xFinal_problema_6_lazo_abierto')
% save('salida_pt_op.mat', 'salida_pto_op')
%% --- G ---
%Para Calcular el G del modelo y compararlo con el de Yan

%Cambio en MV1
u1_in  = nom_ini(1); u1_end  = nom_fin(1);
delta=u1_end-u1_in;
var_name='u1'; u_selected=1;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs;
% t_vect(find((y.data(:,1) - (Thout_1_ini + 0.63*(Thout_1_end-Thout_1_ini))) .* (Thout_1_end-Thout_1_ini) > 0, 1, 'last')) - t_vect(1);

u1_in  = nom_ini(1); u1_end  = nom_ini(1);

% simOut = sim('Red_problema7');
% build_tfs; % graph_ind

%Cambio en MV2
u2_in  = nom_ini(2); u2_end  = nom_fin(2);
delta=u2_end-u2_in;
var_name='u2'; u_selected=2;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u2_in  = nom_ini(2); u2_end  = nom_ini(2);

% simOut = sim('Red_problema7');

%Cambio en MV3
u3_in  = nom_ini(3); u3_end  = nom_fin(3);
delta=u3_end-u3_in;
var_name='u3'; u_selected=3;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u3_in  = nom_ini(3); u3_end  = nom_ini(3);
% simOut = sim('Red_problema7');

%Cambio en MV4
u4_in  = nom_ini(4); u4_end  = nom_fin(4);
delta=u4_end-u4_in;
var_name='u4'; u_selected=4;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u4_in  = nom_ini(4); u4_end  = nom_ini(4);
% simOut = sim('Red_problema7');

%Cambio en MV5
u5_in  = nom_ini(5); u5_end  = nom_fin(5);
delta=u5_end-u5_in;
var_name='u5'; u_selected=5;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u5_in  = nom_ini(5); u5_end  = nom_ini(5);
% simOut = sim('Red_problema7');

%Cambio en MV6
u6_in  = nom_ini(6); u6_end  = nom_fin(6);
delta=u6_end-u6_in;
var_name='u6'; u_selected=6;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u6_in  = nom_ini(6); u6_end  = nom_ini(6);
% simOut = sim('Red_problema7');

%Cambio en MV7
u7_in  = nom_ini(7); u7_end  = nom_fin(7);
delta=u7_end-u7_in;
var_name='u7'; u_selected=7;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u7_in  = nom_ini(7); u7_end  = nom_ini(7);
% simOut = sim('Red_problema7');

%Cambio en MV8
u8_in  = nom_ini(8); u8_end  = nom_fin(8);
delta=u8_end-u8_in;
var_name='u8'; u_selected=8;

% simOut = sim('Red_problema7');
sim('Red_problema7');

% build_tfs; % graph_ind
build_tfs;
u8_in  = nom_ini(8); u8_end  = nom_ini(8);
% simOut = sim('Red_problema7');

%Cambio en MV9
u9_in  = nom_ini(9); u9_end  = nom_fin(9);
delta=u9_end-u9_in;
var_name='u9'; u_selected=9;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u9_in  = nom_ini(9); u9_end  = nom_ini(9);
% simOut = sim('Red_problema7');

%Cambio en MV10
u10_in = nom_ini(10); u10_end = nom_fin(10);
delta=u10_end-u10_in;
var_name='u10'; u_selected=10;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u10_in = nom_ini(10); u10_end = nom_ini(10);
% simOut = sim('Red_problema7');

%Cambio en MV11
u11_in = nom_ini(11); u11_end = nom_fin(11);
delta=u11_end-u11_in;
var_name='u11'; u_selected=11;

% simOut = sim('Red_problema7');
sim('Red_problema7');

build_tfs; % graph_ind
u11_in = nom_ini(11); u11_end = nom_ini(11);
% simOut = sim('Red_problema7');

%% --- D ---
%Cambio en D1
d1_in=0; d1_end=0.01* (270+273); 
delta=d1_end-d1_in;
var_name='d1'; d_selected=1

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d1_in=0; d1_end=0; 

%Cambio en D2
d2_in=0; d2_end=0.01*18; 
delta=d2_end-d2_in;
var_name='d2';d_selected=2

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d2_in=0; d2_end=0; 

%Cambio en D3
d3_in=0; d3_end=0.01*(220+273); 
delta=d3_end-d3_in;
var_name='d3';d_selected=3

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d3_in=0; d3_end=0; 

%Cambio en D4
d4_in=0; d4_end=0.01*22; 
delta=d4_end-d4_in;
var_name='d4';d_selected=4

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d4_in=0; d4_end=0; 

%Cambio en D5
d5_in=0; d5_end=0.01*(50+273); 
delta=d5_end-d5_in;
var_name='d5';d_selected=5

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d5_in=0; d5_end=0; 


%Cambio en D6
d6_in=0; d6_end=0.01*20; 
delta=d6_end-d6_in;
var_name='d6';d_selected=6

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d6_in=0; d6_end=0; 


%Cambio en D7
d7_in=0; d7_end=0.01*(160+273); 
delta=d7_end-d7_in;
var_name='d7';d_selected=7

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d7_in=0; d7_end=0; 


%Cambio en D8
d8_in=0; d8_end=0.01*50; 
delta=d8_end-d8_in;
var_name='d8';d_selected=8

sim('Red_problema7_lazo_abierto_v2021');
build_tfs_d
d8_in=0; d8_end=0; 

%MV1: uh121 - MV2: uc121 
%MV3: uh112 - MV4: uc112 
%MV5: uh222 - MV6: uc222 
%MV7: uh213 - MV8: uc213 
%MV9: fcu1 - MV10: fcu2 - MV11: fhu2

%La G obtenida con el modelo YAN est� organizado seg�n: [MV3 MV4 MV1 MV2 MV7 MV8 MV5 MV6 MV9
%MV10 MV11] - Por eso reorganizo
%% Construccion de G y D 
G_alt=[g13 g14 g11 g12 g17 g18 g15 g16 g19 g110 g111;
   g23 g24 g21 g22 g27 g28 g25 g26 g29 g210 g211;
   g33 g34 g31 g32 g37 g38 g35 g36 g39 g310 g311;
   g43 g44 g41 g42 g47 g48 g45 g46 g49 g410 g411];

G_alt_redondeado= round(100*G_alt)/100

D_alt=[d11 d13 d15 d17 d12 d14 d16 d18;
   d21 d23 d25 d27 d22 d24 d26 d28;
   d31 d33 d35 d37 d32 d34 d36 d38;
   d41 d43 d45 d47 d42 d44 d46 d48];

D_alt_redondeado= round(100*D_alt)/100


save('G_D_modelo_lazo_abierto.mat','G','D','G_redondeado','D_redondeado');
% xlswrite('E6_G_red_modelo_lazo_abierto.xlsx',G_redondeado)
% xlswrite('E6_D_red_modelo_lazo_abierto.xlsx',D_redondeado)
% %load('G_D_modelo_lazo_abierto.mat','G','D','G_redondeado','D_redondeado');
