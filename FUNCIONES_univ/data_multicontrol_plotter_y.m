S = univ_extract_simdata();

times      = S.times;
output     = S.output;
input      = S.input;
input_time = S.input_time;
caso       = S.caso;
RIC        = S.RIC;
% -----------

% Validar select_area
if ~exist('select_area', 'var')
    error('La variable select_area no existe.');
end


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
% if exist('RIC', 'var') && RIC~=1
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