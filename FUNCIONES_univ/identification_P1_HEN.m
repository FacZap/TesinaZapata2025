function [Kp,Tp1,Td,Fit]=identification_P1_HEN(t,salida,entrada,t0,P1form)
%% Help
% t= vector de tiempos
% salida= salidas como structura (salida.data y salida.time)
% entrada= entrada como structura (entrada.data y entrada.time)
% t0 tiempo en que se excita la var. manipulada
% P1form= 1 se aproxiama a un P1 + tiempo muerto / 0 se aproxima a un P1

%Programa que calcula los parametros de la funcion de transferencia 
%a partir del algoritmo PEM de Matlab.
% clc
% close all
% clear
% load data_id

% disp('Programa que calcula los parametros de la funcion de transferencia a partir del algoritmo PEM de Matlab')
% disp(' ')
% j=input('Ingresar el porcentaje correspondiente al juego de datos utilizados');
% t=input('Ingresar el vector de tiempos de la simulacion ');
% salida=input('Ingresar el vector de la var. controlada ');
% entrada=input('Ingresar el vector de la var. manipulada ');
% t0=input('Ingresar el tiempo en que se excita la var. manipulada ');
% disp(' ')

% Recorto Datos
% y_e_r=salida(t0:end);   %porque meto escalon en t0
% u_e_r=entrada(t0:end);  %porque meto escalon en t0


y_e_r_1=buscar_time(t0,inf,salida);
u_e_r_1=buscar_time(t0,inf,entrada);

y_e_r=y_e_r_1.data;u_e_r=u_e_r_1.data; 

s = length(y_e_r);
figure()
% Acomodo Datos para que comiencen en valor nulo
u_e_aux1 = ones(s,1);
u_e_aux2 = u_e_aux1 * u_e_r(1);
u_e = u_e_r - u_e_aux2;
tmp=[0:1:s-1]';
figure(1)
plot(tmp,u_e)
title('u (MV)')
figure()
y_e_aux1 = ones(s,1);
y_e_aux2 = y_e_aux1 * y_e_r(1);
y_e = y_e_r - y_e_aux2;
tmp=[0:1:s-1]';
figure(2)
plot(tmp,y_e)
title('y (PV)')

% Identifico FT
iddata_e=iddata(y_e,u_e,1); % ts en seg.
    
if P1form==1
%% Identifica un Primer orden mas tiempo muerto
m=pem(iddata_e,'P1D','Td',{'min',0},'Td',{'max',inf},'InitialState','Zero');
else
%% Identifica un Primer orden
m=pem(iddata_e,'P1','InitialState','Zero');
end

% Name Model
nro=num2str(5);

name_model=strcat('Gpm_',nro);
eval([name_model ' = m']);   
    
% Validacion Primaria de las FTs
iddata_v=iddata(y_e,u_e,1);
figure();
compare(iddata_v,m,'InitialState','M');
[~, fit, ~] = compare(iddata_e, m, 'InitialState','M');

Kp=m.Kp;
Tp1=m.Tp1;
Td=m.Td;
Fit=fit;




               









