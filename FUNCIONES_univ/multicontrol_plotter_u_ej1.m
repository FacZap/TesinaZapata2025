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
    input_d=input(:,[1, 2, 3, 7])
    td=times
close all
load(data_names_s(1))
inis=[0.01532 0.05314 0.08223 0]
data_multicontrol_plotter_y
    input_s=input(:,[1, 2, 3, 7])
    input_s = (input_s - inis) .* [0.95 0.93 0.95 0.94] + inis;
    ts=times
close all
clear figPath2

%
% Example: if you have tout_d, tout_s, tout_f from each sim
td
ts

ud = input_d;   % size [length(td) x nSignals] (or vector)
us = input_s;

% Make sure time is strictly increasing (Simulink can repeat time at events)
[td, idx] = unique(td, 'stable');  ud = ud(idx,:);
[ts, idx] = unique(ts, 'stable');  us = us(idx,:);

% Common time grid (pick one)
T_end = min([td(end), ts(end)]);   % safest: common overlap
N = 100000;
tq = linspace(0, T_end, N).';

% Use a conservative interpolant first
udq = interp1(td, ud, tq, 'linear');
usq = interp1(ts, us, tq, 'linear');

%
fig_2=figure,
ax1=subplot(4,1,1); plot(tq,udq(:,1),'r'), hold on, plot(tq,usq(:,1),'b'), grid on, legend('Desc','Spar','Setpoint')
ax2=subplot(4,1,2); plot(tq,udq(:,2),'r'), hold on, plot(tq,usq(:,2),'b'), grid on, legend('Desc','Spar','Setpoint')
ax3=subplot(4,1,3); plot(tq,udq(:,3),'r'), hold on, plot(tq,usq(:,3),'b'), grid on, legend('Desc','Spar','Setpoint')
ax4=subplot(4,1,4); plot(tq,udq(:,4),'r'), hold on, plot(tq,usq(:,4),'b'), grid on, legend('Desc','Spar','Setpoint')
linkaxes([ax1 ax2 ax3 ax4],'x')


clear fname2
fname2 = sprintf('fig2_multicontrol_mod_%s.fig', pert_id_selected);
clear figPath2
clear targetDir
folderName = 'SIMULACIONES_SUPER_SCRIPT_actualizadoPato_casosCaract';
currentFolder = pwd;
targetDir  = fullfile(currentFolder, folderName)
figPath2 = fullfile(targetDir, fname2);

isValidFig = @(h) ~isempty(h) && all(isgraphics(h, 'figure'));

% Guardar FIG
if exist('fig_2','var') && isValidFig(fig_2)
    savefig(fig_2, figPath2);
else
    warning('No se pudo guardar fig_2: no existe o no es una figura válida.');
end

close all
clearvars -except targetDir pert_id hhh folderName

end