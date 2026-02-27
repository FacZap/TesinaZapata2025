%%
% Script genérico para extraer PI a partir del modelo Simplificar_Controlador.slx
% No asume ceros estructurales: intenta calcular todos los Kc(i,j), Ti(i,j).
% Si no se detecta respuesta (idx vacío), se asigna Kc = 0 y Ti = 0.

clearvars -except Gc1 Kimc1
close all
clc

% Nombre del modelo de Simulink (ajustar si hace falta)
modelo = 'Simplificar_Controlador';

% Asegurarse de tener la toolbox de control
% (tf usado para armar la matriz de controladores)
for i = 1:4
    for j = 1:4
        Gc1_n(i,j) = tf(0);
    end
end

% Prealocación de matrices de parámetros
Kc = zeros(4,4);
Ti = zeros(4,4);

%% Bucle sobre cada canal de entrada (error) j = 1..4
for j_in = 1:4
    
    % Vector de excitación (unidad en el canal j_in)
    in = zeros(1,4);
    in(j_in) = 1;
    
    % Correr la simulación (usa 'in' desde el workspace actual)
    % Se asume que el modelo escribe en la variable 'out' con campos:
    %   out.salidas_controlador (N x 4)
    %   out.tout                (N x 1)
    out=sim(modelo);
    
    time = out.tout;
    
    % Para cada salida de controlador (columna i = 1..4)
    for i_out = 1:4
        
        salida = out.salidas_controlador(:, i_out);
        
        % Primer índice donde la señal deja de ser estrictamente cero
        idx = find(abs(salida) > 0, 1, 'first');
        
        if isempty(idx)
            % No hay respuesta: asumimos controlador nulo en ese lazo
            Kc(i_out, j_in) = 0;
            Ti(i_out, j_in) = 0;
        else
            % Ganancia proporcional dinámica
            Kc(i_out, j_in) = salida(idx);
            
            % Recortamos para quedarnos con el tramo "recta"
            salida_trim = salida(idx:end);
            time_trim   = time(idx:end);
            
            % Por robustez, chequear que haya al menos 2 puntos
            if numel(time_trim) < 2
                % No se puede ajustar recta
                Kc(i_out, j_in) = 0;
                Ti(i_out, j_in) = 0;
            else
                % Ajuste lineal: salida ~ m * t + b
                p = polyfit(time_trim, salida_trim, 1);
                pendiente = p(1);
                
                % Si la pendiente es ~0, Ti se va al infinito: tomar Ti = 0
                if abs(pendiente) < eps
                    Ti(i_out, j_in) = 0;
                else
                    Ti(i_out, j_in) = Kc(i_out, j_in) / pendiente;
                end
            end
        end
        
    end % i_out
end % j_in

%% Construcción de la matriz de controladores PI Gc1_n a partir de Kc y Ti
for i = 1:4
    for j = 1:4
        if (Kc(i,j) == 0) || (Ti(i,j) == 0)
            % Sin acción de control en ese lazo
            Gc1_n(i,j) = tf(0);
        else
            % PI: Kc (1 + 1/(Ti s)) = Kc * (Ti s + 1) / (Ti s)
            % Forma equivalente usada en tu script original:
            % Gc(s) = Kc + Kc/(Ti s) = (Kc*s + Kc/Ti) / s
            num = [Kc(i,j), Kc(i,j)/Ti(i,j)];
            den = [1, 0];
            Gc1_n(i,j) = tf(num, den)
        end
    end
end

%% Guardar resultado
% save('Gc1_PI_simplificado', 'Gc1_n', 'Kc', 'Ti');
save('Gc1_spar_simplificado', 'Gc1_n', 'Kc', 'Ti');
save('Gc1_full_simplificado', 'Gc1_n', 'Kc', 'Ti');
