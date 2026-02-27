function [sys,x0,str,ts] = In_ter(t,x,u,flag,p1,p2,p3,p4,est)
%%  ----- PARAMETROS
% p1 numero de rodajas
% p2 temperatura de la corriente Caliente de entrada
% p3 temperatura de la corriente Fria de entrada
% p4 nombre del intercambiador
% est determina si se usa el estado estacionario o no (est=1 se usan los
% datos iniciales del estado estacionario / 0 no se utilizan y al final se guardan
%/ se usan los datos iniciales de estado estacionario y al final se guardan
% sirve para aproximar mejor el estado estacionario / 2 se cargan los ultimos datos
% guardados ) 
global nr th_st tc_st

switch flag

case 0


%------------------------------------------------------------ 
% Especificacion del numero de puntos de discretizacion  
%------------------------------------------------------------       
      
    nr = p1;% NUMERO DE PUNTOS DE DISCRETIZACION  
   
    
	sizes = simsizes;
    sizes.NumContStates= 2*nr;
    sizes.NumDiscStates= 0;
    sizes.NumOutputs= 2*nr;
    sizes.NumInputs= 8;
    sizes.DirFeedthrough=0;
    sizes.NumSampleTimes=1;
    sys = simsizes(sizes);  % Load the sys vector with the sizes information.
  
if est==1
%%  Se cargan los datos una vez que se conoce el estado estacionario
    filename=['dynamic_inter_' num2str(p4) '.mat'];
    load(filename,'th_st','tc_st'); 
    xH=th_st; xC=tc_st;
elseif est==2
%%  Se cargan los datos ultimos guardados(para continuar buscando el punto estacionari)
    filename=['dynamic_inter_' num2str(p4) '.mat'];
    load(filename,'th_st','tc_st'); 
    xH=th_st; xC=tc_st;
elseif est==0
%%  Si no se conoce el estado estacionario  
    xH=ones(1,nr)*p2-ones(1,nr).*(1:1:nr)/100;
    xC=ones(1,nr)*p3+ones(1,nr).*(1:1:nr)/100;
end

    x0=[xH xC];

    str = []; % No state ordering
    ts = [0 0]; % Inherited sample time

%--------------------------------------------------------------

%----------------------------------------------------------
% Caracteristicas del intercambiador
%----------------------------------------------------------
% Area=18.04;
% aef=Area/npesr;


case 1
    sys=din_inter(t,x,u,p1,p2,p3);

case 3
    if est==0 ||  est==2
        th_st(1:nr)=x(1:nr);tc_st(1:nr)=x(nr+1:2*nr);
        filename=['dynamic_inter_' num2str(p4) '.mat'];
        save(filename,'th_st','tc_st'); 
    end
	sys(1:2*nr)=x(1:2*nr);
%    sys(2*npesr+1:3*npesr)=T_pared(1:npesr);
%	sys(9*npesr+1)=F_esr;

    
case {2, 4, 9}
	
    sys=[]; % unused flags
    
end