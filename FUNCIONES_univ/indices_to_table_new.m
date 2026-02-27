% guardar indices s
clear Eu IAE
IAE=IAE_trapz_abs
Eu=Eu_trapz
IAE_total
Eu_total
Eu_total_utilidades

folderName = 'SIMULACIONES_SUPER_SCRIPT';
% Directorio actual
currentDir = pwd;
% Ruta completa a la carpeta destino
targetDir = fullfile(currentDir, folderName);

% Verificar si la carpeta existe, si no, crearla
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

%% 28/12/25
% Define columns once
colNames_X = ["t","IAE1","IAE2","IAE3","IAE4","IAE_total"];
colNames_Y = ["t","Eu1","Eu2","Eu3","Eu4","Eu_total","Eu_total_u"];

% Preallocate if you know N rows (recommended)
if (k_table==1)
    N = 12;
    X_new = nan(N, numel(colNames_X));
    Y_new = nan(N, numel(colNames_Y))
    Z_new = nan(N, 5)
end

X_new(k_table,:) = [k_table, IAE(1), IAE(2), IAE(3), IAE(4), IAE_total];
Y_new(k_table,:) = [k_table, Eu(1), Eu(2), Eu(3), Eu(4), Eu_total, Eu_total_utilidades]
Z_new(k_table,:) = [k_table, T_est(1), T_est(2), T_est(3), T_est(4)];

% Trim unused rows
% X = X(1:k_table,:);
% Y = Y(1:k_table,:)
% Z = Z(1:k_table,:);


% T = array2table(X, "VariableNames", colNames);
% writetable(T, "results.csv");
