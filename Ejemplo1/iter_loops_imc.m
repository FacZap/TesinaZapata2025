INI
load('IMC_matrices')
% Loop through all variable names
for i = 1:length(var_names)
    var_name = var_names{i};
    initial_var_name = [var_name '_initial'];

    % Check if the initial variable exists
    if evalin('base', ['exist(''' initial_var_name ''', ''var'')']) ~= 1
        warning(['Skipping: Variable ' initial_var_name ' does not exist in the workspace.']);
        continue;
    end

    initial_value = evalin('base', initial_var_name);

    % Loop through all values
    for j = 1:length(values)
        val = values(j);

        % Apply the operation
        switch lower(operation)
            case 'multiply'
                new_value = initial_value * val;
            case 'add'
                new_value = initial_value + val;
            otherwise
                error('Unsupported operation. Use ''add'' or ''multiply''.');
        end

        % Assign the new value to the variable in the base workspace
        assignin('base', var_name, new_value);

        % Crear objeto de simulación con parámetros personalizados (si los hay)
        simIn = Simulink.SimulationInput('Red_problema1_imc.slx');
        
        % Run the simulation
        disp(['Running simulation with ' var_name ' = ' num2str(new_value)]);
        
        % Ejecutar simulación sincrónicamente
        out = sim('Red_problema1_imc.slx', 'SimulationMode', 'normal', 'Timeout', timeout); % Timeout opcional

        % Plot the outputs (you could also save or store results here if needed)
        plot_salidas_imc;
        if exist('save_plots_to_fig','var') && save_plots_to_fig==1 
         eval(sprintf("savefig('imcResponse_%s_%0.4f_filt_%d.fig')",var_name,val,filt))
         eval(sprintf("save('imcResponse_%s_%0.4f_filt_%d.mat')",var_name,val,filt))
         close all
        end

        % Optionally pause or separate runs
        % pause;  % Uncomment to step through each simulation
        INI
        for num_inter = [2, 112, 211, 222]
            try
%                 eval(sprintf("dynamic_inter_%d = og_dynamic_inter_%d",num_inter,num_inter));
%                   eval(sprintf("temp_struct = load('og_dynamic_inter_%d.mat', 'th_st', 'tc_st');",num_inter));
%                   th_st = temp_struct.th_st;
%                   tc_st  = temp_struct.tc_st;
%                   eval(sprintf("save('dynamic_inter_%d.mat', 'th_st_temp','tc_st_temp', '-append');",num_inter));
                    reset_succ=dos('copy_dyn.bat')
            catch
                disp("No se pueden resetear los dynamic_inter.")
            end
        end
    end
end

% msgbox("Listo")
