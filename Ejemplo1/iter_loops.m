INI
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

        % Run the simulation
        disp(['Running simulation with ' var_name ' = ' num2str(new_value)]);
        sim('Red_problema1_original.slx');

        % Plot the outputs (you could also save or store results here if needed)
        plot_salidas;
        if exist('save_plots_to_fig','var') && save_plots_to_fig==1 
         eval(sprintf("savefig('ComparePlot_%s_%0.4f.fig')",var_name,val))
         close all
        end

        % Optionally pause or separate runs
        % pause;  % Uncomment to step through each simulation
        INI
    end
end

% msgbox("Listo")
