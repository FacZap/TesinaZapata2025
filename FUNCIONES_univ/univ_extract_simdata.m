function S = univ_extract_simdata()
%UNIV_EXTRACT_SIMDATA  Extrae (robusto) times/output/input/input_time/caso/RIC
% desde el workspace base, unificando nombres:
%   - times, output
%   - input, input_time
%   - caso: 1(Ej7), 2(Ej6), 3(Ej1)
%   - RIC (si aplica)
%
% Reglas:
% 1) Para output: prioriza 'out' si existe y tiene tout/yout; si no, usa tout/yout.
% 2) Para caso: usa RIC si existe; si no, cae a caso 3 si existe d_time.
% 3) Para input:
%    - caso~=3: usa u_exc_new si existe y no está vacío; si no u_exc.
%    - caso==3: usa out.test_planta; si vacío usa out.entradas.

    S = struct();
    wb = 'base';

    % ---------- helpers ----------
    has = @(v) evalin(wb, sprintf("exist('%s','var')", v)) == 1;

    % ---------- 1) times/output ----------
    S.source_output = "";

    if has('out')
        out = evalin(wb,'out');
        % Intento tomar out.tout/out.yout
        try
            t = out.tout;
            y = out.yout;
            if ~isempty(t) && ~isempty(y)
                S.times  = t;
                S.output = y;
                S.source_output = "out";
            end
        catch
            % no-op
        end
    end

    if ~isfield(S,'times') || ~isfield(S,'output')
        if has('tout') && has('yout')
            S.times  = evalin(wb,'tout');
            S.output = evalin(wb,'yout');
            S.source_output = "tout/yout";
        else
            error('No se encontraron datos de salida: ni out.tout/out.yout ni tout/yout.');
        end
    end

    % ---------- 2) caso / RIC ----------
    S.caso = NaN;
    S.RIC  = NaN;

    if has('RIC')
        RIC = evalin(wb,'RIC');
        S.RIC = RIC;

        if RIC == 7
            S.caso = 1; % Ejemplo 7
        elseif RIC == 6
            S.caso = 2; % Ejemplo 6
        elseif RIC == 1
            % si querés tratarlo como caso 3, lo forzamos abajo
            % lo dejo sin setear acá
        end
    end

    % Si todavía no se determinó, caer a caso 3 si existe d_time
    if isnan(S.caso)
        if has('d_time')
            S.caso = 3; % Ejemplo 1
            if ~has('RIC')
                S.RIC = 1;
            end
        else
            % último fallback: si había RIC pero no era 6/7/1, avisar
            if has('RIC')
                error('RIC=%g no está contemplado en la lógica (esperado 6,7 o caso 3 con d_time).', S.RIC);
            else
                error('No se pudo determinar "caso": falta RIC y falta d_time.');
            end
        end
    end

    % ---------- 3) input / input_time ----------
    S.source_input = "";
    S.input = [];
    S.input_time = [];

    if S.caso ~= 3
        % Preferir u_exc_new si existe y tiene Data/Time válidos
        if has('u_exc_new')
            u = evalin(wb,'u_exc_new');
            try
                if ~isempty(u) && ~isempty(u.Data)
                    S.input = u.Data;
                    S.input_time = u.Time;
                    S.source_input = "u_exc_new";
                end
            catch
                % no-op
            end
        end

        if isempty(S.input) && has('u_exc')
            u = evalin(wb,'u_exc');
            try
                if ~isempty(u) && ~isempty(u.Data)
                    S.input = u.Data;
                    S.input_time = u.Time;
                    S.source_input = "u_exc";
                end
            catch
                % no-op
            end
        end

        if isempty(S.input)
            error('caso~=3 pero no se encontró u_exc_new ni u_exc con Data.');
        end

    else
        % Caso 3: input vive en out.*
        if ~has('out')
            try %caso "lazo abierto"
                u_exc = evalin(wb,'u_exc');
                S.input = u_exc;
            catch
                error('caso==3 pero no existe variable out en workspace.');
            end
        else
        out = evalin(wb,'out');

        % test_planta -> si vacío, entradas
        try
            S.input = out.test_planta;
            S.input_time = out.tout;
        catch
            % si no existe test_planta, forzar vacío
            S.input = [];
            S.input_time = [];
        end
        end

        if isempty(S.input)
            try
                S.input = out.entradas;
                S.input_time = out.tout;
            catch
                error('caso==3: no se encontraron out.test_planta ni out.entradas.');
            end
        end

        S.source_input = "out.(test_planta/entradas)";
    end

    % ---------- 4) normalizaciones mínimas ----------
    % asegurar que times sea columna
    if isrow(S.times), S.times = S.times(:); end

    % ---------- 5) resumen útil ----------
    S.ny = size(S.output,2);
    S.nu = size(S.input,2);
    
        % ---------- 6) post-procesado: saturación bypass + offsets utilidades ----------
    % Objetivo:
    % - No permitir bypass <0 o >1 (evitar saturación física fuera de rango)
    % - Para caso 1/2: sumar punto de operación nominal a utilidades (cols 9:11)

    if S.caso == 3
        cols_bypass = 1:6;

        % Clamp bypasses a [0, 1]
        cols_bypass = cols_bypass(cols_bypass <= size(S.input,2));
        if ~isempty(cols_bypass)
            S.input(:, cols_bypass) = min(max(S.input(:, cols_bypass), 0), 1);
        end

    elseif S.caso == 1 || S.caso == 2
        cols_bypass = 1:8;

        % Clamp bypasses a [0, 1]
        cols_bypass = cols_bypass(cols_bypass <= size(S.input,2));
        if ~isempty(cols_bypass)
            S.input(:, cols_bypass) = min(max(S.input(:, cols_bypass), 0), 1);
        end

        % Offsets utilidades (cols 9:11) - completar manualmente
        cols_utils = 9:11;
        cols_utils = cols_utils(cols_utils <= size(S.input,2));
        if ~isempty(cols_utils)
            % >>> COMPLETAR ESTOS 3 OFFSETS MANUALMENTE <<<
            offset_u9  = 0;   % e.g. fcu1_nominal
            offset_u10 = 0;   % e.g. fcu2_nominal
            offset_u11 = 0;   % e.g. fhu2_nominal

            offsets = [offset_u9, offset_u10, offset_u11];

            % Sumar offsets solo a las columnas que existan
            for k = 1:numel(cols_utils)
                S.input(:, cols_utils(k)) = S.input(:, cols_utils(k)) + offsets(k);
            end

            % Clamp mínimo: utilidades no pueden ser < 0
            S.input(:, cols_utils) = max(S.input(:, cols_utils), 0);
        end
    end



end
