% Directorio raíz donde están las subcarpetas
rootDir = pwd; % o reemplazar con ruta específica: 'C:\ruta\a\carpeta'

% Listar subcarpetas
subfolders = dir(rootDir);
subfolders = subfolders([subfolders.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

% Inicializar
tabla_final = table();
nombres_columnas = {'Subcarpeta'};

% Recorremos cada subcarpeta
for k = 1:length(subfolders)
    folderName = subfolders(k).name;
    fullPath = fullfile(rootDir, folderName);
    matFile = fullfile(fullPath, 'data_metricas.mat');

    if isfile(matFile)
        try
            data = load(matFile);
            vars = fieldnames(data);
            fila = table({folderName}, 'VariableNames', {'Subcarpeta'});

            for v = 1:length(vars)
                valor = data.(vars{v});

                if isnumeric(valor)
                    if isscalar(valor)
                        colName = vars{v};
                        fila.(colName) = valor;
                        if ~ismember(colName, nombres_columnas)
                            nombres_columnas{end+1} = colName;
                        end
                    elseif isvector(valor)
                        for i = 1:length(valor)
                            colName = sprintf('%s_%d', vars{v}, i);
                            fila.(colName) = valor(i);
                            if ~ismember(colName, nombres_columnas)
                                nombres_columnas{end+1} = colName;
                            end
                        end
                    end
                end
            end

            % Agregar fila a la tabla final
            tabla_final = [tabla_final; fila];

        catch ME
            warning("Error en %s: %s", folderName, ME.message);
        end
    else
        warning('No se encontró %s', matFile);
    end
end

% Reordenar columnas para mantener consistencia
tabla_final = movevars(tabla_final, nombres_columnas, 'Before', 1);

% Exportar
writetable(tabla_final, 'metricas_comparadas.csv');
disp('✅ Archivo exportado: metricas_comparadas.csv');
