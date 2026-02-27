fprintf('\n');

vars = {'filt','Kc_per','Tp_per','d_time','t_step','sim_time','thin1','tcin1','tcin2'};
S = struct();   % estructura vacía

for k = 1:numel(vars)
    name = vars{k};

    if exist(name,'var')
        % guardo el valor en la estructura con campo dinámico
        S.(name) = eval(name);   % si estás en script; en función usa evalin si hace falta
        fprintf('%s = %.2f\n', name, S.(name));
    else
        fprintf('La variable %s NO existe\n', name);
    end
end
