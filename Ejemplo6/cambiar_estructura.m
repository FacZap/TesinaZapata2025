%% cambiar a Desc
nominales_u_desc=[zeros(1,1),0.05454159133452416,zeros(1,9)];
initials=nominales_u_desc;
inicializar_entradas;

select_area='d';
inicializar_areas;

load('G_modelo_desc_v1','G_modelo')
load('G_modelo_desc_v3','G_modelo')
load('salida_pt_op_desc.mat','salida_pto_op')

%% cambiar a Spar
nominales_u_spar=[zeros(1,2),0.1218689600950269,zeros(1,4),0.2593056269126446,zeros(1,3)];
initials=nominales_u_spar;
inicializar_entradas;

select_area='s';
inicializar_areas;
        
load('G_modelo_spar_v1','G_modelo')
load('G_modelo_spar_v3','G_modelo')
load('salida_pt_op_spar.mat','salida_pto_op')

%% cambiar a Full
nominales_u_full=[zeros(1,1),0.059640541275225376,zeros(1,5),0.1844696794738052,zeros(1,3)];
initials=nominales_u_full;
inicializar_entradas;

select_area='f';
inicializar_areas;

load('G_modelo_full_v1','G_modelo')
load('G_modelo_full_v3','G_modelo')
load('salida_pt_op_full.mat','salida_pto_op')