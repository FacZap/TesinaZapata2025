
clear
currentFolder = pwd;
targetFolder_6  = 'D:\Facultad\!PROYECTO\Tesina - Zapata 2025\Diseno\Ejemplo 6';
targetFolder_7  = 'D:\Facultad\!PROYECTO\Tesina - Zapata 2025\Diseno\Ejemplo 7';

isInX_6 = strcmpi( ...
    char(java.io.File(currentFolder).getCanonicalPath()), ...
    char(java.io.File(targetFolder_6).getCanonicalPath()) )

isInX_7 = strcmpi( ...
    char(java.io.File(currentFolder).getCanonicalPath()), ...
    char(java.io.File(targetFolder_7).getCanonicalPath()) )

if and(~isInX_6,~isInX_7)
    error('No estas en la carpeta correcta')
end
%%

folderPath = fullfile(pwd,'SIMULACIONES_SUPER_SCRIPT');   % ruta a la carpeta
files = dir(fullfile(folderPath, "*.mat"));

data_names = {files.name};   % cell array con los nombres
data_names = fullfile({files.folder}, {files.name});
data_names = string(fullfile({files.folder}, {files.name}));

%re-ordeno para que este como en el script
data_names = data_names([1:4,9:12,5:8]) 
data_names = data_names([4 3 2 1 8 7 6 5 12 11 10 9])
%% 
k_table = 0, omitted=0;
close all

for i_data=1:numel(data_names)
    clearvars -except k_table X_new Y_new Z_new i_data data_names
    load(data_names(i_data))

    close all
    %
    univ_plotter
    %
    save_univ_plotter
    %
    indices_universales
    %
    k_table = k_table + 1; indices_to_table_new
    
end
clear X Y Z
X = X_new(1:k_table,:);
Y = Y_new(1:k_table,:)
Z = Z_new(1:k_table,:);
sound(rand(1, 4000))

%%
dt = datetime('now');
dt.Format = 'yyMMdd_HHmmss';
s = string(dt)
save(sprintf(strcat('SUPER_SCRIPT_DATA_',s,'.mat')))
clear T_Eu_a T_Eu_b T_Eu_c T_Eu_d Eu_pert_a Eu_pert_b Eu_pert_c Eu_pert_d T_IAE_a IAE_pert_a T_IAE_b IAE_pert_b T_IAE_c IAE_pert_c T_IAE_d IAE_pert_d
COMPARISION_X_Y