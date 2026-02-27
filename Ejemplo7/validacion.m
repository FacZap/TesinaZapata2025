sim_time=3000;
t_step=500;

%Cambio en MV1
u1_in  = nom_ini(1); u1_end  = nom_fin(1);
delta=u1_end-u1_in;
var_name='u1'; u_selected=1;

sim('Red_problema6');

save_plot_validacion;
% t_vect(find((y.data(:,1) - (Thout_1_ini + 0.63*(Thout_1_end-Thout_1_ini))) .* (Thout_1_end-Thout_1_ini) > 0, 1, 'last')) - t_vect(1);

u1_in  = nom_ini(1); u1_end  = nom_ini(1);

%Cambio en MV2
u2_in  = nom_ini(2); u2_end  = nom_fin(2);
delta=u2_end-u2_in;
var_name='u2'; u_selected=2;

sim('Red_problema6');

save_plot_validacion;
u2_in  = nom_ini(2); u2_end  = nom_ini(2);

% sim('Red_problema6');

%Cambio en MV3
u3_in  = nom_ini(3); u3_end  = nom_fin(3);
delta=u3_end-u3_in;
var_name='u3'; u_selected=3;

sim('Red_problema6');

save_plot_validacion;
u3_in  = nom_ini(3); u3_end  = nom_ini(3);
% sim('Red_problema6');

%Cambio en MV4
u4_in  = nom_ini(4); u4_end  = nom_fin(4);
delta=u4_end-u4_in;
var_name='u4'; u_selected=4;

sim('Red_problema6');

save_plot_validacion;
u4_in  = nom_ini(4); u4_end  = nom_ini(4);
% sim('Red_problema6');

%Cambio en MV5
u5_in  = nom_ini(5); u5_end  = nom_fin(5);
delta=u5_end-u5_in;
var_name='u5'; u_selected=5;

sim('Red_problema6');

save_plot_validacion;
u5_in  = nom_ini(5); u5_end  = nom_ini(5);
% sim('Red_problema6');

%Cambio en MV6
u6_in  = nom_ini(6); u6_end  = nom_fin(6);
delta=u6_end-u6_in;
var_name='u6'; u_selected=6;

sim('Red_problema6');

save_plot_validacion;
u6_in  = nom_ini(6); u6_end  = nom_ini(6);
% sim('Red_problema6');

%Cambio en MV7
u7_in  = nom_ini(7); u7_end  = nom_fin(7);
delta=u7_end-u7_in;
var_name='u7'; u_selected=7;

sim('Red_problema6');

save_plot_validacion;
u7_in  = nom_ini(7); u7_end  = nom_ini(7);
% sim('Red_problema6');

%Cambio en MV8
u8_in  = nom_ini(8); u8_end  = nom_fin(8);
delta=u8_end-u8_in;
var_name='u8'; u_selected=8;

sim('Red_problema6');

save_plot_validacion;
u8_in  = nom_ini(8); u8_end  = nom_ini(8);
% sim('Red_problema6');

%Cambio en MV9
u9_in  = nom_ini(9); u9_end  = nom_fin(9);
delta=u9_end-u9_in;
var_name='u9'; u_selected=9;

sim('Red_problema6');

save_plot_validacion;
u9_in  = nom_ini(9); u9_end  = nom_ini(9);
% sim('Red_problema6');

%Cambio en MV10
u10_in = nom_ini(10); u10_end = nom_fin(10);
delta=u10_end-u10_in;
var_name='u10'; u_selected=10;

sim('Red_problema6');

save_plot_validacion;
u10_in = nom_ini(10); u10_end = nom_ini(10);
% sim('Red_problema6');

%Cambio en MV11
u11_in = nom_ini(11); u11_end = nom_fin(11);
delta=u11_end-u11_in;
var_name='u11'; u_selected=11;

sim('Red_problema6');

save_plot_validacion;
u11_in = nom_ini(11); u11_end = nom_ini(11);
% sim('Red_problema6');