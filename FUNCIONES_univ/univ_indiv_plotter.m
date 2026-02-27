% if exist('out', 'var')
%     % Verificar que out tenga los campos necesarios
%         times = out.tout;
%         output = out.yout;
%         disp('con out')
% 
% else
%     % Verificar si existen tout y yout como variables independientes
%     if exist('tout', 'var') && exist('yout', 'var')
%         times = tout;
%         output = yout;
%                 disp('sin out')
% 
%     else
%         % Verificar si existe y
%         if exist('y', 'var')
%             disp('y existe');
%         else
%             disp('Error');
%         end
%     end
% end
% 
% % Determinar el caso principal (1,2,3)
% if exist('RIC', 'var')
%     if RIC==7
%         caso = 1; %Ejemplo 7
%     end
%     if RIC==6
%         caso = 2; %Ejemplo 6
%     end
% elseif exist('d_time', 'var')
%     caso = 3; %Ejemplo 1
%     disp('RIC Ejemplo 1');
%     detect_area_RIC1;
%     RIC=1;
% end
% 
% if exist('u_exc','var') && caso~=3
%     input = u_exc.Data;
%     input_time = u_exc.Time;
% elseif caso ==3 
% %     input = out.u_exc;
% %     input_time = out.tout;
% 
%         input=out.test_planta;
%         input_time = out.tout;
%     if isempty(input)
%         input=out.entradas;
%         input_time = out.tout;
%     end
% end

S = univ_extract_simdata();

times      = S.times;
output     = S.output;
input      = S.input;
input_time = S.input_time;
caso       = S.caso;
RIC        = S.RIC;


% Validar select_area
if ~exist('select_area', 'var')
    error('La variable select_area no existe.');
end

%% =======================
% 1) OUTPUTS vs SETPOINTS
% =======================

% --- Elegir de dónde salen los datos según el caso ---
if exist('caso','var') && caso == 3
    t_out = out.tout;
    y_out = out.yout;
else
    t_out = times;
    y_out = output;
end

labels_out = { ...
    'Th1_o', 'Setpoint Th1'; ...
    'Th2_o', 'Setpoint Th2'; ...
    'Tc1_o', 'Setpoint Tc1'; ...
    'Tc2_o', 'Setpoint Tc2'};

sp = [sp1 sp2 sp3 sp4];
colors_out = {'r','r','b','b'};

for i = 1:4
    figure
    plot(t_out, y_out(:,i), colors_out{i}, 'LineWidth', 1.5), hold on
    plot(t_out, ones(length(t_out),1)*sp(i), 'g--', 'LineWidth', 1.2)
    grid on
    xlabel('Tiempo [s]')
    ylabel('Temperatura')
    title(sprintf('%c | RIC %d | Output %d', select_area, RIC, i))
    legend(labels_out{i,1}, labels_out{i,2}, 'Location','best')
end


%% =========================================
% 1b) CASO 3: PERTURBACIONES (d_exc) INDIV.
% =========================================
if caso == 3
    dist_idx   = [1 5 7];
    dist_names = {'thin1\_pert','tcin1\_pert','tcin2\_pert'};
    dist_nom   = [620 300 280];
    dist_ylim  = [619.5 625.5; 294.5 300.5; 274.5 280.5];
    dist_col   = {'r','c','b'};

    for k = 1:numel(dist_idx)
        j = dist_idx(k);
        figure
        plot(out.tout, out.d_exc(:,j), dist_col{k}, 'LineWidth', 1.5), hold on
        plot(out.tout, ones(length(out.tout),1)*dist_nom(k), 'k--', 'LineWidth', 1.2)
        grid on
        ylim(dist_ylim(k,:))
        xlabel('Tiempo [s]')
        ylabel('Perturbación')
        title(sprintf('Caso 3 | %s (col %d)', dist_names{k}, j))
        legend(dist_names{k}, sprintf('Nominal = %.0f', dist_nom(k)), 'Location','best')
    end
end

%% ============================
% 2) VMs (SEGUN AREA Y CASO)
% ============================
try
    switch select_area

        case 'd'
            if caso == 1
                idx_vm = [8 9 10 11];  tag = 'Desc';
            elseif caso == 2
                idx_vm = [5 9 10 11];  tag = 'Desc';
            elseif caso == 3
                % (Si en tu caso 3 NO querés VMs, podés comentar este bloque)
                idx_vm = [1 2 3 7];  tag = 'Desc (Caso 3)';
            else
                error('caso inválido (esperado 1, 2 o 3).')
            end

        case 's'
            if caso == 1
                idx_vm = [5 9 10 11];  tag = 'Spar';
            elseif caso == 2
                idx_vm = [2 8 9 10];   tag = 'Spar';
            elseif caso == 3
                idx_vm = [1 2 3 7];  tag = 'Spar (Caso 3)';
            else
                error('caso inválido (esperado 1, 2 o 3).')
            end

        case 'f'
            if caso == 1
                idx_vm = [2 8 9 10];   tag = 'Full';
            elseif caso == 2
                idx_vm = [5 8 9 10];   tag = 'Full';
            elseif caso == 3
                idx_vm = [1 2 3 7];   tag = 'Full (Caso 3)';
            else
                error('caso inválido (esperado 1, 2 o 3).')
            end

        otherwise
            error('select_area debe ser ''d'', ''s'' o ''f''.');
    end

    colors_vm = {'r','c','b','g'};

    for k = 1:length(idx_vm)
        vm = idx_vm(k);

        figure
        plot(input_time, input(:,vm), colors_vm{min(k,numel(colors_vm))}, 'LineWidth', 1.5)
        grid on
        xlabel('Tiempo [s]')
        ylabel('Valor de VM')
        title(sprintf('%s | VM %d', tag, vm))
        legend(sprintf('VM %d', vm), 'Location','best')
    end

catch
    disp('Se omitió la segunda gráfica de la simulación (VMs):')
%     disp(sprintf('RIC %d | %c | %.2f | %.2f', RIC, select_area, d_temp, d_flow))
    omitted = omitted + 1;
end
