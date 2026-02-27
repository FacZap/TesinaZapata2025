function [Kc,Taoi,Taod]=IMC_Controladores_HEN(Kp,Tp1,Td,Kc_per,Tp1_per,L_filtro,use_PI_PID)
%Help
% -Kp es el valor de Kp identificado con identification_P1_HEN
% -Tp1 es el valor de Tp1 identificado con identification_P1_HEN 
% -Td es el valor de Td identificado con identification_P1_HEN
% -Kc_per es para dar un porcentaja del Kc obtenido por
% el metodo del IMC para que no sea tan agresivo (generalmente es un 0.1
% pero se tiene que ir tocando hasta obtener la respuesta que se quiere) 
% -Tp1_per es para dar un porcentaja del Tp1 obtenido por
% el metodo del IMC para que no sea tan agresivo (al ir aumentando generaria una respuesta mas rapida) 
% -use_PI_PID= 1 se usa Controlador PI / 2 se usa Controlador PI-"Mejorado / 
% 3 se usa Controlador PID
% %Programa para el calculo de los parametros de los controladores por el metodo de IMC
% disp('Programa para el calculo de los parametros de los controladores por el metodo de IMC')
% disp(' ')
% Kp=input('Ingresar la ganancia estatica del sistema ');
% tao=input('Ingresar la constante de tiempo del sistema ');
% tita=input('Ingresar el tiempo muerto del sistema ');
% L=input('Ingresar el valor del parametro ajustable del fltro ');
% L_filtro: permite definir que relacion del Tp1 tiene el filtro
% (generalmente para un modelo sin retardo L=0.5*Tp1)
% disp(' ')
% disp('Controlador PI')

tao= Tp1;
tita= Td; 
L=L_filtro*Tp1; 

KcPI=tao/(L*Kp);
TaoiPI=tao;

% disp('Controlador PI-"Mejorado"')
KcPI_M=(2*tao+tita)/(2*L*Kp);
TaoiPI_M=tao+tita/2;

% disp('Controlador PID')
KcPID=(2*tao+tita)/(Kp*(2*L+tita));
TaoiPID=tao+tita/2;
TaodPID=tao*tita/(2*tao+tita);

if use_PI_PID==1
    Kc= KcPI*Kc_per;
    Taoi=(KcPI*Kc_per*Tp1_per)/TaoiPI;
    Taod=0;
elseif use_PI_PID==2
    Kc= KcPI_M*Kc_per;
    Taoi=(KcPI_M*Kc_per*Tp1_per)/TaoiPI_M;
    Taod=0;
elseif use_PI_PID==3
    Kc= KcPID*Kc_per;
    Taoi=(KcPID*Kc_per*Tp1_per)/TaoiPID;
    Taod=TaodPID*KcPID;
end

end

%%  El filtro tiene que ser mayor a 0.2* Tp1
%% El resultado final es (generalmente) :
%     - Controlador PI
%     - Mantener el TaoiPI
%     - Utilizar inicialmente un 10% del KcPI e ir aumentando de ser
%     necesario hasta obtener la dinámica necesaria

%% PARA EL PID DEL SIMULINK tiene otra formula respecto a la que da la el IMC_Controlador
% EL IMC_Controlador da KcPID( 1 + 1/TaoiPID + TaodPID)
% Mientras que el PID del Simulin KcPID' + TaoiPID' + TaodPID'
% Por lo tanto por ejemplo para un PI:
% - El KcPI'=KcPI
% - El TaoiPI'=  KcPI / TaoiPI