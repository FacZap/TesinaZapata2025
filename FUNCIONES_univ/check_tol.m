
if exist('out', 'var')
    % Verificar que out tenga los campos necesarios
    if isfield(out, 'tout') && isfield(out, 'yout')
        times = out.tout;
        output = out.yout;
        disp('con out')
    else
        disp('La variable out existe, pero no contiene los campos tout y yout');
    end

else
    % Verificar si existen tout y yout como variables independientes
    if exist('tout', 'var') && exist('yout', 'var')
        times = tout;
        output = yout;
                disp('sin out')

    else
        % Verificar si existe y
        if exist('y', 'var')
            disp('y existe');
        else
            disp('Error');
        end
    end
end

% Determinar el caso principal (1 o 2)
if exist('RIC', 'var')
    if RIC == 7
        caso = 1;
    end
    if RIC == 6
        caso = 2;
    end
else
    disp('No existe var RIC')
end

% Validar select_area
if ~exist('select_area', 'var')
    error('La variable select_area no existe.');
end

%%
tol_1=1e-1;
tol_2=1e-2;
tol_3=1e-3;
% disp(tol)

% Error absoluto
error = abs(output(end,:) - setpoints);

% Índices dentro de tolerancia
dentro_1 = error <= tol_1;
dentro_2 = error <= tol_2;
dentro_3 = error <= tol_3;
disp('- - -');
disp(dentro_1), disp(dentro_2), disp(dentro_3)
