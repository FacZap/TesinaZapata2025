%% batch_indices.m
% Colocá este archivo en la misma carpeta donde están los data_*.mat y ejecutalo.

clear; clc;

dataDir = pwd;
outDir  = fullfile(dataDir, "indices_out");
if ~exist(outDir, "dir"), mkdir(outDir); end

% --- Detectar archivos disponibles ---
files = dir(fullfile(dataDir, "data_*_*.mat"));
names = string({files.name});

tok = regexp(names, "^data_([ds])_(\d{3})\.mat$", "tokens", "once");
ok  = ~cellfun(@isempty, tok);
tok = tok(ok);

if isempty(tok)
    error("No se encontraron archivos con patrón data_[d|s]_XXX.mat");
end

controllers = ["d","s"];
codes = string(cellfun(@(t) t{2}, tok, "UniformOutput", false));
codes = unique(codes);
codes = sort(codes);  % como son 3 dígitos, orden lexicográfico sirve

% Estructura resultados (evitamos fieldnames que empiecen con número)
results = struct();

% --- Loop principal: por perturbación, procesar d y luego s ---
for ci = 1:numel(codes)
    codeStr = codes(ci);
    key = "p" + codeStr; % ej: p005 (fieldname válido)

    for ctrl = controllers
        fname = fullfile(dataDir, sprintf("data_%s_%s.mat", ctrl, codeStr));

        if ~isfile(fname)
            warning("Falta %s (se saltea).", fname);
            continue;
        end

        load(fname);
        close all

        % === Procesado (PEGÁS tu lógica adentro de procesar_data) ===
        indices_universales
        IAE=IAE_trapz_abs
        Eu=Eu_trapz
        Offsets=offset

        % Validación mínima
        if ~isequal(size(IAE), [1 4]) || ~isequal(size(Eu), [1 4])|| ~isequal(size(Offsets), [1 4])
            error("IAE y Eu deben ser 1x4. Archivo: %s", fname);
        end

        % Guardar en struct
        results.(key).(ctrl).IAE = IAE;
        results.(key).(ctrl).Eu  = Eu;
        results.(key).(ctrl).Offsets  = Offsets;

        % Guardar por caso
        save(fullfile(outDir, sprintf("indices_%s_%s.mat", ctrl, codeStr)), "IAE", "Eu", "Offsets");
    end
end

% --- Armar tablas ---
n = numel(codes);

IAE_d = nan(n,4); Eu_d = nan(n,4);
IAE_s = nan(n,4); Eu_s = nan(n,4);
Offsets_s = nan(n,4); Offsets_s = nan(n,4);

for i = 1:n
    codeStr = codes(i);
    key = "p" + codeStr;

    if isfield(results, key)
        if isfield(results.(key), "d")
            IAE_d(i,:) = results.(key).d.IAE;
            Eu_d(i,:)  = results.(key).d.Eu;
            Offsets_d(i,:)  = results.(key).d.Offsets;
        end
        if isfield(results.(key), "s")
            IAE_s(i,:) = results.(key).s.IAE;
            Eu_s(i,:)  = results.(key).s.Eu;
            Offsets_s(i,:)  = results.(key).s.Offsets;
        end
    end
end

varIAE = "IAE_" + (1:4);
varOffsets = "Offsets_" + (1:4);
varEu  = "Eu_"  + (1:4);

T_d = array2table([IAE_d Eu_d Offsets_d], "VariableNames", [varIAE+"_d", varEu+"_d", varOffsets+"_d"]);
T_s = array2table([IAE_s Eu_s Offsets_s], "VariableNames", [varIAE+"_s", varEu+"_s", varOffsets+"_s"]);


% T_comp  = [table(codes, "VariableNames", {"Pert"}), T_d, T_s];

% T_delta = array2table([IAE_s-IAE_d, Eu_s-Eu_d], ...
%     "VariableNames", [varIAE+"_s_minus_d", varEu+"_s_minus_d"]);
% T_delta = [table(codes, "VariableNames", {"Pert"}), T_delta];

% Guardar resumen
save(fullfile(outDir, sprintf("resumen_indices_%s.mat",datestr(now,'yymmddHHMMSS'))), "results", "T_s", "T_d");

% Exportar Excel
xlsx = fullfile(outDir, "resumen_indices.xlsx");
writetable(T_d,  xlsx, "Sheet", "d");
writetable(T_s,  xlsx, "Sheet", "s");
% writetable(T_delta, xlsx, "Sheet", "delta");

disp("Listo. Tablas generadas:");


