% Nombre de la carpeta destino
if ~exist('folderName', 'var')
    folderName = 'SIMULACIONES_SUPER_SCRIPT';
end

currentDir = pwd;
targetDir  = fullfile(currentDir, folderName);

if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

if caso == 3
    data_path = fullfile(targetDir,sprintf('data_%c_%d%d%d.mat',select_area,abs(thin1),abs(tcin1),abs(tcin2)))
    
    fname1 = sprintf('fig1_%c_%d%d%d.fig',select_area,abs(thin1),abs(tcin1),abs(tcin2));
    fname2 = sprintf('fig2_%c_%d%d%d.fig',select_area,abs(thin1),abs(tcin1),abs(tcin2));

    figPath1 = fullfile(targetDir, fname1);
    figPath2 = fullfile(targetDir, fname2);
    pngPath1 = fullfile(targetDir, sprintf('fig1_%c_%d%d%d.png',select_area,abs(thin1),abs(tcin1),abs(tcin2)));
    pngPath2 = fullfile(targetDir, sprintf('fig2_%c_%d%d%d.png',select_area,abs(thin1),abs(tcin1),abs(tcin2)));
elseif caso < 3
    try
        data_path = fullfile(targetDir,sprintf('data_%c_%.2f_%.2f.mat',select_area,abs(d_temp),abs(d_flow)))
    catch
        data_path = fullfile(targetDir,sprintf('\data_unsorted_%d.mat',k_table))
    end
    tag1 = sprintf('%.6g', d1_end);
    tag2 = sprintf('%.6g', d2_end);
    fname1 = sprintf('fig1_%c_%s_%s.fig', select_area, tag1, tag2);
    fname2 = sprintf('fig2_%c_%s_%s.fig', select_area, tag1, tag2);

    figPath1 = fullfile(targetDir, fname1);
    figPath2 = fullfile(targetDir, fname2);
    pngPath1 = fullfile(targetDir, sprintf('fig1_%c_%s_%s.png', select_area, tag1, tag2));
    pngPath2 = fullfile(targetDir, sprintf('fig2_%c_%s_%s.png', select_area, tag1, tag2));
end
save(data_path)

isValidFig = @(h) ~isempty(h) && all(isgraphics(h, 'figure'));

% Guardar FIG
if exist('fig_1','var') && isValidFig(fig_1)
    savefig(fig_1, figPath1);
else
    warning('No se pudo guardar fig_1: no existe o no es una figura válida.');
end

if exist('fig_2','var') && isValidFig(fig_2)   % <-- acá está la corrección clave
    savefig(fig_2, figPath2);
else
    warning('No se pudo guardar fig_2: no existe o no es una figura válida.');
end

% Guardar PNG
if exist('fig_1','var') && isValidFig(fig_1)
    exportgraphics(fig_1, pngPath1, 'Resolution', 300);
end

if exist('fig_2','var') && isValidFig(fig_2)
    exportgraphics(fig_2, pngPath2, 'Resolution', 300);
end

% Cerrar y limpiar
close all
clear fig_1 fig_2
