% % Verificar si existen tout y yout como variables independientes
% if exist('tout', 'var') && exist('yout', 'var')
%     times = tout;
%     output = yout;
%     disp('sin out')
% elseif exist('out', 'var')
%     % Verificar que out tenga los campos necesarios
%         times = out.tout;
%         output = out.yout;
%         disp('con out')
% elseif exist('y', 'var')
%             disp('y existe');
% end
% 
% % Determinar el caso principal (1,2,3)
% if exist('RIC', 'var') || RIC~=1
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

S = univ_extract_simdata();

times      = S.times;
output     = S.output;
input      = S.input;
input_time = S.input_time;
caso       = S.caso;
RIC        = S.RIC;


% Validar select_area
if ~exist('select_area', 'var') && caso~=3
    error('La variable select_area no existe.');
else

    
switch select_area
    
    case 'd'
        % --- Código para área 'd' ---
        if caso == 1
            % Código caso 1 + d
            selected_inputs=[8,9,10,11];
        elseif caso==2
            % Código caso 2 + d
            selected_inputs=[2,9,10,11];
        elseif caso==3
            selected_inputs=[1 2 3 7]; %TERMINAR!
        end

    case 's'
        % --- Código para área 's' ---
        if caso == 1
            % Código caso 1 + s
            selected_inputs=[5,9,10,11];
        elseif caso==2
            % Código caso 2 + s
            selected_inputs=[3,8,9,10];
        elseif caso==3
            selected_inputs=[1 2 3 7]; %TERMINAR!
        end

    case 'f'
        % --- Código para área 'f' ---
        if caso == 1
            selected_inputs=[2,8,9,10];
        else
            selected_inputs=[2,8,9,10];
        end

    otherwise
        error('select_area debe ser ''d'', ''s'' o ''f''.');
end
end

% if exist('u_exc_new','var') && caso~=3 && RIC==6
%     input = u_exc_new.Data;
%     input_time = u_exc_new.Time;
% elseif exist('u_exc','var') && caso~=3 && RIC==7
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

% ====== DETECCIÓN ROBUSTA (case-aware) ======
% b1 = u1_end == u1_in;
% b2 = u2_end == u2_in;
% b3 = u3_end == u3_in;
% b4 = u4_end == u4_in;
% b5 = u5_end == u5_in;
% b6 = u6_end == u6_in;
% b7 = u7_end == u7_in;
% b8 = u8_end == u8_in;
% b9 = u9_end == u9_in;
% b10 = u10_end == u10_in;
% b11 = u11_end == u11_in;
% has_t_step = (exist('t_step','var') || exist('TSTEP','var')) && ~all([b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11]);
has_t_step = (exist('t_step','var') || exist('d_time','var'))
has_t_sp   = exist('t_sp_change','var') && (t_sp_change~=0);

% Normalizo nombres para trabajar siempre con t_step y t_sp_change
if ~exist('t_step','var') && exist('d_time','var')
    t_step = d_time;
end
if ~exist('t_sp_change','var') && exist('TSPCHANGE','var')
    t_sp_change = TSPCHANGE;
end
% ====== SELECCIÓN DE LÓGICA ======
if has_t_step && has_t_sp
    disp('Se detectaron ambas variables: t_step y t_sp_change.');
    disp('Elegí la lógica a usar:');
    disp('  1) Usar t_step (cortar métricas desde un tiempo fijo)');
    disp('  2) Usar t_sp_change (detectar/usar instante de cambio de setpoint)');
    opt = input('Opción (1/2): ');

    if isempty(opt) || ~ismember(opt,[1 2])
        error('Opción inválida. Elegí 1 o 2.');
    end

    if opt == 1
        use_logic = "t_step";
    else
        use_logic = "t_sp_change";
    end

elseif has_t_step
    use_logic = "t_step";

elseif has_t_sp
    use_logic = "t_sp_change";

else
    disp('No hay ingreso de perturbacion ni cambio de setpoint.');
end
% ====== EJECUCIÓN DE LÓGICA ======
switch use_logic
    case "t_step"
        % --- LÓGICA t_step ---
        disp(sprintf('Usando t_step = %.6g s', t_step));

        % times: vector tiempo (mismo largo que señales)
        idx_t = find(times >= t_step, 1, 'first');
        if isempty(idx_t)
            error('t_step = %.3f s fuera del rango [%.3f, %.3f] s', ...
                  t_step, times(1), times(end));
        end
        
        idx_u0 = find(input_time >= t_step, 1, 'first');
        if isempty(idx_u0)
            error('t_step fuera del rango de u_ts.Time');
        end

    case "t_sp_change"
        % --- LÓGICA t_sp_change ---
        disp(sprintf('Usando t_sp_change = %.6g s', t_sp_change));

        idx_t = find(times >= t_sp_change, 1, 'first');
        if isempty(idx_t)
            error('t_sp_change = %.3f s fuera del rango [%.3f, %.3f] s', ...
                  t_sp_change, times(1), times(end));
        end
        
        idx_u0 = find(t_u >= t_sp_change, 1, 'first');
        if isempty(idx_u0)
            error('t_step fuera del rango de u_ts.Time');
        end

    otherwise
        error('Estado inesperado en selección de lógica.');
end

% --- Cálculo de IAE y Eu por lazos (4 en total) ---

IAE_trapz_abs = zeros(1,4);   % IAE(i): índice para la salida i
Eu_trapz  = zeros(1,4);   % Eu(i): energía de control para la VM asociada al lazo i
% IAE_trapz = zeros(1,4); 
% IAE_trapz_abs = zeros(1,4); 
% IAE_abs_trapz = zeros(1,4); 
% IAE_long = zeros(1,4);
% Eu_long  = zeros(1,4);
% IAE_trapz_long = zeros(1,4); 
% IAE_trapz_abs_long = zeros(1,4);

tol=5e-3;

% NOTA 25/12/25 17:50: ME ACABO DE DAR CUENTA QUE TENGO QUE HACER OTRA
% LÓGICA PARA EL EJEMPLO 1, porque por su naturaleza, las salidas pueden no
% llegar a los setpoints. CHEQUEAR

% Normalizacion de Eu
% ELEMENTO DE MATRIZ NORMALIZADA: (delta_y*delta_u)/(range_u/range_y)
% Eu normalizada implica Entrada normalizada: ¿Cuanto se movió U con
% respecto a su rango admisible?
% delta_u / range_u 
% delta_u = (u_real - u_nominal)

rango_bypass=1
rango_utilidad=1
rango=1; %generico, despues borrar

if caso < 3
for i = 1:4
    
    % Índice de la VM asociada a este lazo (según selected_inputs)
    idx_u = selected_inputs(i);

    % Energía de control de la VM correspondiente a este lazo
    % Eu(i) = ∫ |(u - u_nominal)^2| dt
%     % IAE de la salida i
%     % IAE(i) = ∫ |r - y| dt  ≈ norma-1 de (r - y)

%     if i==4
%         IAE_trapz_abs_long(i) = trapz( times, abs(setpoints(i) - output(:,i)))
%     else
%         IAE_trapz_abs_long(i) = trapz( times, abs(setpoints(i) - output(:,i)));
%     end
    
    % Energía de control de la VM correspondiente a este lazo
    % Solo desde t >= t_step
    if i == 4
        Eu_trapz(i) = trapz( input_time(idx_u0:end), ((input(idx_u0:end, idx_u) - initials(idx_u))/rango).^2 )
    else
        Eu_trapz(i) = trapz( input_time(idx_u0:end), ((input(idx_u0:end, idx_u) - initials(idx_u))/rango).^2 );
    end
    
    if i==4
        IAE_trapz_abs(i) = trapz( times(idx_t:end), abs(setpoints(i) - output((idx_t:end),i)))
    else
        IAE_trapz_abs(i) = trapz( times(idx_t:end), abs(setpoints(i) - output((idx_t:end),i)));
    end
    
        % error absoluto
    e = abs(output(idx_t:end,i) - setpoints(i));

    % condición dentro de tolerancia
    inside = e <= tol;

    % buscar primer índice tal que DESDE ahí en adelante todo cumpla
    idx_est_rel = find( ...
        arrayfun(@(k) all(inside(k:end)), 1:length(inside)), ...
        1, 'first');

    if isempty(idx_est_rel)
        T_est(i) = NaN;   % nunca se establece
    else
        t_est = times(idx_t + idx_est_rel - 1);
        T_est(i) = t_est - t_step
    end
    
end
else
    for i = 1:4
     % Índice de la VM asociada a este lazo (según selected_inputs)
    idx_u = selected_inputs(i);
    setpoints_alt(i)=output(end,i)
    
    offset(i)=setpoints_alt(i)-setpoints(i)
    
    % error absoluto
    e = abs(output(idx_t:end,i) - setpoints_alt(i));

    % condición dentro de tolerancia
    inside = e <= tol;

    % buscar primer índice tal que DESDE ahí en adelante todo cumpla
    idx_est_rel = find( ...
        arrayfun(@(k) all(inside(k:end)), 1:length(inside)), ...
        1, 'first');

%     if isempty(idx_est_rel)
%         T_est(i) = NaN;   % nunca se establece
%     else
%         t_est = times(idx_t + idx_est_rel - 1);
%         T_est(i) = t_est - t_step
%     end
%     
    if isempty(idx_est_rel)
        T_est(i) = NaN;   % nunca se establece
    else
        % convertir a índice absoluto en "times"
        idx_est_abs = idx_t + idx_est_rel - 1;
        t_est = times(idx_est_abs);
        T_est(i) = t_est - t_step
    end
    
    % Energía de control de la VM correspondiente a este lazo
    % Solo desde t >= t_step
    if i == 4
        Eu_trapz(i) = trapz( input_time(idx_u0:end), (input(idx_u0:end, idx_u) + initials(idx_u)) )
    else
        Eu_trapz(i) = trapz( input_time(idx_u0:end), (input(idx_u0:end, idx_u) + initials(idx_u)) );
    end
    
    if i==4
%         IAE_trapz_abs(i) = trapz( times(idx_t:idx_est_abs), abs(setpoints(i) - output((idx_t:idx_est_abs),i)))
        IAE_trapz_abs(i) = trapz( times(idx_t:end), abs(setpoints(i) - output((idx_t:end),i)))
    else
%         IAE_trapz_abs(i) = trapz( times(idx_t:idx_est_abs), abs(setpoints(i) - output((idx_t:idx_est_abs),i)));
        IAE_trapz_abs(i) = trapz( times(idx_t:end), abs(setpoints(i) - output((idx_t:end),i)));
    end
    end
    
end

% (Opcional) Si querés un único escalar total:
% IAE_total = sum(IAE);
IAE_total = sum(IAE_trapz_abs);
Eu_total  = sum(Eu_trapz);

if caso < 3
    utilidades=[9,10,11];
%     Eu_total_utilidades = sum(Eu_trapz( intersect(idx_u,utilidades)-8 ));
Eu_total_utilidades=0;
else
%     utilidades=[7];
%     Eu_total_utilidades = sum(Eu_trapz()); %TERMINAR
Eu_total_utilidades=0;
end


% IAE = norm(setpoints()-output(),1); %donde r=vector de setpoint, y=vector de salida
% Eu = norm((input()-initials()).^2,1); %energía de control asoc a una VM, donde r=vector de valor nominal, u=vector de la VM
% EIP = 100*(IAE_base-IAE_new)/IAE_base;

