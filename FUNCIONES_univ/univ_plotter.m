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

fig_1=figure,
ax1=subplot(4,1,1); plot(times,output(:,1),'r'), hold on, plot(times, ones(length(times),1)*sp1, 'g.'), title(sprintf('Controlador: %c _ Th_o 1 [K] vs Tiempo[s]',select_area)), grid on, legend({'Th1_o','Setpoint'})
ax2=subplot(4,1,2); plot(times,output(:,2),'r'), hold on, plot(times, ones(length(times),1)*sp2, 'g.'), title(sprintf('Controlador: %c _ Th_o 2 [K] vs Tiempo[s]',select_area)), grid on, legend({'Th2_o','Setpoint'})
ax3=subplot(4,1,3); plot(times,output(:,3),'b'), hold on, plot(times, ones(length(times),1)*sp3, 'g.'), title(sprintf('Controlador: %c _ Tc_o 1 [K] vs Tiempo[s]',select_area)), grid on, legend({'Tc1_o','Setpoint'})
ax4=subplot(4,1,4); plot(times,output(:,4),'b'), hold on, plot(times, ones(length(times),1)*sp4, 'g.'), title(sprintf('Controlador: %c _ Tc_o 2 [K] vs Tiempo[s]',select_area)), grid on, legend({'Tc2_o','Setpoint'})

try
  switch select_area
    
    case 'd'
        % --- Código para área 'd' ---
        if caso == 1
            % Código caso 1 + d
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,8),'r'), grid on, title('Desc: VM 8')
            ax2=subplot(4,1,2); plot(input_time,input(:,9),'c'), grid on, title('Desc: VM 9')
            ax3=subplot(4,1,3); plot(input_time,input(:,10),'b'), grid on, title('Desc: VM 10')
            ax4=subplot(4,1,4); plot(input_time,input(:,11),'g'), grid on, title('Desc: VM 11')
        elseif caso == 2
            % Código caso 2 + d
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,2),'r'), grid on, title('Desc: VM 2')
            ax2=subplot(4,1,2); plot(input_time,input(:,9),'c'), grid on, title('Desc: VM 9')
            ax3=subplot(4,1,3); plot(input_time,input(:,10),'b'), grid on, title('Desc: VM 10') 
            ax4=subplot(4,1,4); plot(input_time,input(:,11),'g'), grid on, title('Desc: VM 11')
        elseif caso == 3
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,1),'r'), grid on, title('Desc: VM 1')
            ax2=subplot(4,1,2); plot(input_time,input(:,2),'c'), grid on, title('Desc: VM 2')
            ax3=subplot(4,1,3); plot(input_time,input(:,3),'b'), grid on, title('Desc: VM 3')
            ax4=subplot(4,1,4); plot(input_time,input(:,7),'g'), grid on, title('Desc: VM 7')
        end

    case 's'
        % --- Código para área 's' ---
        if caso == 1
            % Código caso 1 + s
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,5),'r'), grid on, title('Spar: VM 5')
            ax2=subplot(4,1,2); plot(input_time,input(:,9),'c'), grid on, title('Spar: VM 9')
            ax3=subplot(4,1,3); plot(input_time,input(:,10),'b'), grid on, title('Spar: VM 10') 
            ax4=subplot(4,1,4); plot(input_time,input(:,11),'g'), grid on, title('Spar: VM 11')
        elseif caso == 2
            % Código caso 2 + s
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,3),'r'), grid on, title('Spar: VM 3')
            ax2=subplot(4,1,2); plot(input_time,input(:,8),'c'), grid on, title('Spar: VM 8')
            ax3=subplot(4,1,3); plot(input_time,input(:,9),'b'), grid on, title('Spar: VM 9')
            ax4=subplot(4,1,4); plot(input_time,input(:,10),'g'), grid on, title('Spar: VM 10')
        elseif caso == 3
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,1),'r'), grid on, title('Spar: VM 1')
            ax2=subplot(4,1,2); plot(input_time,input(:,2),'c'), grid on, title('Spar: VM 2')
            ax3=subplot(4,1,3); plot(input_time,input(:,3),'b'), grid on, title('Spar: VM 3')
            ax4=subplot(4,1,4); plot(input_time,input(:,7),'g'), grid on, title('Spar: VM 7')
        end

    case 'f'
        % --- Código para área 'f' ---
        if caso == 1
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,2),'r'), grid on, title('Full: VM 2')
            ax2=subplot(4,1,2); plot(input_time,input(:,8),'c'), grid on, title('Full: VM 8')
            ax3=subplot(4,1,3); plot(input_time,input(:,9),'b'), grid on, title('Full: VM 9') 
            ax4=subplot(4,1,4); plot(input_time,input(:,10),'g'), grid on, title('Full: VM 10')
        elseif caso == 2
            fig_2=figure,
            ax1=subplot(4,1,1); plot(input_time,input(:,2),'r'), grid on, title('Full: VM 2')
            ax2=subplot(4,1,2); plot(input_time,input(:,8),'c'), grid on, title('Full: VM 8')
            ax3=subplot(4,1,3); plot(input_time,input(:,9),'b'), grid on, title('Full: VM 9') 
            ax4=subplot(4,1,4); plot(input_time,input(:,10),'g'), grid on, title('Full: VM 10')
        end

    otherwise
        error('select_area debe ser ''d'', ''s'' o ''f''.');
  end
catch
    disp('Se omitio la segunda grafica de la simulacion:')
    disp(sprintf('RIC %d _ %c _ %.2f _ %.2f',RIC,select_area,d_temp,d_flow))
    omitted=omitted+1;
end


