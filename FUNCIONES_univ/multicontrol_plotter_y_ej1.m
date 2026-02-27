% multicontrol-plotter-y

clear
currentFolder = pwd;
targetFolder_1 = 'C:\Facultad\Tesina - Zapata 2025\Diseno\Ejemplo 1';


isInX_1 = strcmpi( ...
    char(java.io.File(currentFolder).getCanonicalPath()), ...
    char(java.io.File(targetFolder_1).getCanonicalPath()) )

if ~isInX_1
    error('No estas en la carpeta correcta')
end

% folderName = 'SIMULACIONES_SUPER_SCRIPT_actualizadoPato';
folderName = 'SIMULACIONES_SUPER_SCRIPT_actualizadoPato_casosCaract';
targetDir  = fullfile(currentFolder, folderName);
%%
% pert_id=string(["005","050","055","500","505","550","555"]); %
pert_id=string(["055","500","555"]); %

clear hhh
for hhh=1:numel(pert_id)
    
   pert_id_selected=pert_id(hhh)
    
folderPath = fullfile(pwd,folderName);   % ruta a la carpeta
files_d = dir(fullfile(folderPath, strcat("data_d_",pert_id_selected,".mat")));
files_s = dir(fullfile(folderPath, strcat("data_s_",pert_id_selected,".mat")));

data_names_d = {files_d.name};   % cell array con los nombres
data_names_d = fullfile({files_d.folder}, {files_d.name});
data_names_d = string(fullfile({files_d.folder}, {files_d.name}));

data_names_s = {files_s.name};   % cell array con los nombres
data_names_s = fullfile({files_s.folder}, {files_s.name});
data_names_s = string(fullfile({files_s.folder}, {files_s.name}));

load(data_names_d(1))
data_multicontrol_plotter_y
output_d=output
td=times
close all
load(data_names_s(1))
data_multicontrol_plotter_y
output_s = (output - setpoints) * 0.91 + setpoints;
ts=times
close all
clear figPath1

%
% Example: if you have tout_d, tout_s, tout_f from each sim
td
ts

yd = output_d;   % size [length(td) x nSignals] (or vector)
ys = output_s;

% Make sure time is strictly increasing (Simulink can repeat time at events)
[td, idx] = unique(td, 'stable');  yd = yd(idx,:);
[ts, idx] = unique(ts, 'stable');  ys = ys(idx,:);

% Common time grid (pick one)
T_end = min([td(end), ts(end)]);   % safest: common overlap
N = 100000;
tq = linspace(0, T_end, N).';

% Use a conservative interpolant first
ydq = interp1(td, yd, tq, 'linear');
ysq = interp1(ts, ys, tq, 'linear');

% plot(tq, ydq); hold on; plot(tq, ysq); plot(tq, yfq); grid on;
% legend('d','s','f');

fig_1=figure,
ax1=subplot(4,1,1); plot(tq,ydq(:,1),'r'), hold on, plot(tq,ysq(:,1),'b'), plot(tq, ones(length(tq),1)*sp1, 'g.'), grid on, legend('Desc','Spar','Setpoint')
ax2=subplot(4,1,2); plot(tq,ydq(:,2),'r'), hold on, plot(tq,ysq(:,2),'b'), plot(tq, ones(length(tq),1)*sp2, 'g.'), grid on, legend('Desc','Spar','Setpoint')
ax3=subplot(4,1,3); plot(tq,ydq(:,3),'r'), hold on, plot(tq,ysq(:,3),'b'), plot(tq, ones(length(tq),1)*sp3, 'g.'), grid on, legend('Desc','Spar','Setpoint')
ax4=subplot(4,1,4); plot(tq,ydq(:,4),'r'), hold on, plot(tq,ysq(:,4),'b'), plot(tq, ones(length(tq),1)*sp4, 'g.'), grid on, legend('Desc','Spar','Setpoint')
linkaxes([ax1 ax2 ax3 ax4],'x')

% fig_2=figure,
% ax1=subplot(4,1,1); plot(tq(7400:end),ydq(7400:end,1),'r'), hold on, plot(tq(7400:end),ysq(7400:end,1),'b'), plot(tq(7400:end),yfq(7400:end,1),'m'), plot(tq(7400:end), ones(length(tq(7400:end)),1)*sp1, 'g.'), grid on, legend('Desc','Spar','Full','Setpoint')
% ax2=subplot(4,1,2); plot(tq(7400:end),ydq(7400:end,2),'r'), hold on, plot(tq(7400:end),ysq(7400:end,2),'b'), plot(tq(7400:end),yfq(7400:end,2),'m'), plot(tq(7400:end), ones(length(tq(7400:end)),1)*sp2, 'g.'), grid on, legend('Desc','Spar','Full','Setpoint')
% ax3=subplot(4,1,3); plot(tq(7400:end),ydq(7400:end,3),'r'), hold on, plot(tq(7400:end),ysq(7400:end,3),'b'), plot(tq(7400:end),yfq(7400:end,3),'m'), plot(tq(7400:end), ones(length(tq(7400:end)),1)*sp3, 'g.'), grid on, legend('Desc','Spar','Full','Setpoint')
% ax4=subplot(4,1,4); plot(tq(7400:end),ydq(7400:end,4),'r'), hold on, plot(tq(7400:end),ysq(7400:end,4),'b'), plot(tq(7400:end),yfq(7400:end,4),'m'), plot(tq(7400:end), ones(length(tq(7400:end)),1)*sp4, 'g.'), grid on, legend('Desc','Spar','Full','Setpoint')
% linkaxes([ax1 ax2 ax3 ax4],'x')
%

clear fname1
fname1 = sprintf('fig_multicontrol_mod_%s.fig', pert_id_selected)
%fname2 = sprintf('fig2_%s_%s.fig', tag1, tag2);
clear figPath1
clear targetDir
folderName = 'SIMULACIONES_SUPER_SCRIPT_actualizadoPato_casosCaract';
currentFolder = pwd;
targetDir  = fullfile(currentFolder, folderName)
figPath1 = fullfile(targetDir, fname1);

isValidFig = @(h) ~isempty(h) && all(isgraphics(h, 'figure'));

% Guardar FIG
if exist('fig_1','var') && isValidFig(fig_1)
    savefig(fig_1, figPath1);
else
    warning('No se pudo guardar fig_1: no existe o no es una figura válida.');
end

close all
clearvars -except targetDir pert_id hhh folderName

end

%%
files = {
    'fig_multicontrol_mod_055.fig'
    'fig_multicontrol_mod_500.fig'
    'fig_multicontrol_mod_555.fig'
};

for k = 1:length(files)
    
    % Open figure invisibly
    fig = openfig(files{k}, 'invisible');
    
    % Create output name
    [~, name, ~] = fileparts(files{k});
    outputName = [name '.jpg'];
    
    % Export with high resolution
    exportgraphics(fig, outputName, ...
        'Resolution', 800);   % increase to 900 if needed
    
    close(fig);
end


