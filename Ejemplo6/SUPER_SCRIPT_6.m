% red 6
clear
currentFolder = pwd;
targetFolder  = 'D:\Facultad\!PROYECTO\Tesina - Zapata 2025\Diseno\Ejemplo 6';

isInX = strcmpi( ...
    char(java.io.File(currentFolder).getCanonicalPath()), ...
    char(java.io.File(targetFolder).getCanonicalPath()) )

if ~isInX
    error('No estas en la carpeta correcta')
end
k_table=0
%% desc a
k_table = 0, omitted=0;
close all
clearvars -except k_table X Y Z omitted tiempos X_new Y_new Z_new

script_desc;
filt=300;
imc_d;
d_temp=0.65;
d_flow=0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc

%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
sound(rand(1, 6000))
disp('LISTO desc a')

%% desc b
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_desc
filt=300;
imc_d;
d_temp=0.65;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO desc b')

%% desc c
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_desc
filt=300;
imc_d;
d_temp=-0.35;
d_flow=-0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO desc c')

%% desc d
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_desc
filt=300;
imc_d;
d_temp=-0.35;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO desc d')

% - - - - - - SPAR
%% spar a
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_spar;
filt=300;
imc_s;
d_temp=0.65;
d_flow=0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO spar a')

%% spar b
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_spar
filt=300;
imc_s;
d_temp=0.65;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO spar b')

%% spar c
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_spar
filt=300;
imc_s;
d_temp=-0.35;
d_flow=-0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO spar c')

%% spar d
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_spar
filt=300;
imc_s;
d_temp=-0.35;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO spar d')

% - - - - - full
% red 6
%% full a
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_full;
filt=300;
imc_f;
d_temp=0.65;
d_flow=0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO full a')

%% full b
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_full
filt=300;
imc_f;
d_temp=0.65;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO full b')

%% full c
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_full
filt=300;
imc_f;
d_temp=-0.35;
d_flow=-0.15;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO full c')

%% full d
close all
clearvars -except k_table X Y Z omitted tiempos  X_new Y_new Z_new

script_full
filt=300;
imc_f;
d_temp=-0.35;
d_flow=0;
set_d;

%
tic
sim('Red_problema6_imc.slx')
clc
disp('Ejecutando simulación para RIC = 6');
tiempos(k_table+1) = toc
%
univ_plotter
%
save_univ_plotter
%
indices_universales
%
k_table = k_table + 1; indices_to_table

clc
disp('LISTO full d')

% omitted

%%
dt = datetime('now');
dt.Format = 'yyMMdd_HHmmss';
s = string(dt)
% save(sprintf(strcat('SUPER_SCRIPT_DATA_short',s,'.mat')))
% COMPARISION_X_Y