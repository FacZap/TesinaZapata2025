clc

d_temp = input('Ingrese valor de temperatura de las perturbaciones: ');
if (isempty(d_temp) || abs(d_temp)>1), error('Error de input'); end

d_flow = input('Ingrese valor de flujo de las perturbaciones: ');
if (isempty(d_flow) || abs(d_flow)>0.15 || (d_flow*d_temp)<0), error('Error de input'); end

for k = [1 3 5 7]
    assignin('base', sprintf('d%d_end', k), d_temp);
end
for k = [2 4 6 8]
    assignin('base', sprintf('d%d_end', k), d_flow);
end

clear d_temp d_flow k




% clc
% d_temp=input('Ingrese valor de temperatura de las perturbaciones:')
% if isempty(d_temp)
%     error('Ingresa algo')
% end
% for d = {'d1_end','d3_end', 'd5_end', 'd7_end'}
%     d_name=d{1};
%     eval(strcat(d_name,'=d_temp'))
% end
% clear d_temp d_name d
% 
% d_flow=input('Ingrese valor de flujo de las perturbaciones:')
% if isempty(d_flow)
%     error('Ingresa algo')
% end
% for d = {'d2_end','d4_end', 'd6_end', 'd8_end'}
%     d_name=d{1};
%     eval(strcat(d_name,'=d_flow'))
% end
% clear d_flow d_name d