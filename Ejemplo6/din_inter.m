% Intercambiador de calor. Modelo ideal 

%Utilizamos las ecuaciones diferenciales en funcion de los balances de
%energía

function [dfdt]=din_inter(t,x,u,p1,p2,p3,p4)

global nr

%------------------------------------------------------ 
% Reasignacion de variables 
%------------------------------------------------------ 

Thout=[x(1:nr)'];Tcout=[x(nr+1:2*nr)'];

%------------------------------------------------------ 
% Condiciones de entrada reactor
%------------------------------------------------------

Thin  = u(1);%Temperatura de entrada corriente caliente K 
fh = u(2);%flujo de entrada temperatura caliente Kmol/seg
hh = u(3);%coeficiente pelicular de transferecia de calor
Tcin = u(4);%Temperatura de entrada de la corriente fria K 
fc = u(5);%flujo de entrada de la corriente fria Kmol/seg
hc = u(6);%coeficiente pelicular de transferecia de calor
Rd = u(7);%ensuciamiento
Area = u(8);%ensuciamiento

aef=Area/nr;

%--------------------------------------------------------------------------     
% Fefinicion de matrices de corrientes frï¿½as y calientes
%--------------------------------------------------------------------------

Th(1)=Thin;%K
Th(2:nr+1)=Thout;%K
Tc(nr+1)=Tcin;%K
Tc(1:nr)=Tcout;%K

%--------------------------------------------------------------------------     
% Calculo de la temperatua media
%--------------------------------------------------------------------------
% Tcmedio=(Tc(2:npesr+1)+Tc(1:(npesr)))/2;%K
% Thmedio=(Th(2:npesr+1)+Tc(1:(npesr)))/2;%K


U=(1/((1/hh)+(1/hc)));
Uf(1:nr)=1/(((1/U))+Rd);%[W/m2-K]


for m=2:nr+1
    dth(m-1)=(Th(m-1)-Tc(m-1));
    dtc(m)=(Th(m)-Tc(m));
%     delTref(m-1)=(dth(m-1)+dtc(m))/2;
%     delTref(m-1)=(dth(m-1)-dtc(m))/log(dth(m-1)/dtc(m));
    delTref(m-1)= (2/3)* (dth(m-1)^0.5) * (dtc(m)^0.5) + (1/6) * dth(m-1) +(1/6) * dtc(m); 
%     delTref(m-1)= (2/3)* (max(dth(m-1),0)^0.5) * (max(dtc(m),0)^0.5) + (1/6) * dth(m-1) +(1/6) * dtc(m); 
end

% 
% for m=2:nr+1
%     if Th(m-1) > Tc(m)
%         dth(m-1)=abs(Th(m-1)-Tc(m-1));
%         dtc(m)=abs(Th(m)-Tc(m));
% %         delTref(m-1)=( (2/3)*(dth(m-1)*dtc(m)).^(0.5) + (1/6)*dth(m-1) + (1/6)*dtc(m) );%[ï¿½K]   
% %         delTref(m-1)=(dth(m-1)-dtc(m))/( log(dth(m-1)/dtc(m)) );%[ï¿½K]
% %         delTref(m-1)=(dth(m-1)+dtc(m))/2;
%         delTref(m-1)= (2/3)* (dth(m-1)^0.5) * (dtc(m)^0.5) + (1/6) * dth(m-1) +(1/6) * dtc(m); 
%     elseif Th(m-1) < Tc(m)
%         dth(m-1)=abs(Tc(m-1)-Th(m-1));
%         dtc(m)=abs(Tc(m)-Th(m));
%         delTref(m-1)=( (2/3)*(dth(m-1)*dtc(m)).^(0.5) + (1/6)*dth(m-1) + (1/6)*dtc(m) );%[ï¿½K]   
% %         delTref(m-1)=(dth(m-1)-dtc(m))/( log(dth(m-1)/dtc(m)) );%[ï¿½K]
% %         delTref(m-1)=(dth(m-1)+dtc(m))/2;  
%     elseif Th(m-1) == Tc(m)
%         dth(m-1)=0;
%         dtc(m)=0;
% %         delTref(m-1)=( (2/3)*(dth(m-1)*dtc(m)).^(0.5) + (1/6)*dth(m-1) + (1/6)*dtc(m) );%[ï¿½K]   
% %         delTref(m-1)=(dth(m-1)-dtc(m))/( log(dth(m-1)/dtc(m)) );%[ï¿½K]
%         delTref(m-1)=0;  
%     end
% end  

%-------------------------
% Calor Entregado 
%-------------------------

% 
% if fh <= 1e-6
%     Q(1:nr)=0;
% elseif fc <= 1e-6
%     Q(1:nr)=0;
% else
    Q(1:nr)=(Uf(1:nr).*aef.*delTref(1:nr)); %[Kw]
% end 

% Q
% sum(Q)

%------------------------------------------------------ 
% Ecuaciones diferenciales del modelo 
%------------------------------------------------------ 

  % BALANCE DE ENERGIA 
%cp,denc son las propiedades en la temperatura media de la rodaja 
L = 2/nr; % m
rint = aef / (2*L*pi()); % suponiendo que los intercambiadores tienen una longitud de 2 M (aef = 2 Pi D L)
Vrod= pi() * rint^2 * L ; 

for m=1:nr
%      if Th(m)>Tc(m+1)    
%          dThoutdt(m) = ((fh.*(Th(m)-Th(m+1)))-Q(m))/Vrod; %./(denh(1:npesr).*Vhrod.*cph(1:npesr)) ;%[K/seg]
%          dTcoutdt(m) = ((fc.*(Tc(m+1)-Tc(m)))+Q(m))/Vrod; %./(denc(1:npesr).*Vcrod.*cpc(1:npesr)) ;%[K/seg]
% %      else Th(m)==Tc(m+1) 
% %       dThoutdt(m) = 0; %./(denh(1:npesr).*Vhrod.*cph(1:npesr)) ;%[K/seg]
% %       dTcoutdt(m) = 0; %./(denc(1:npesr).*Vcrod.*cpc(1:npesr)) ;%[K/seg]
%      elseif Th(m)<Tc(m+1)
%          dThoutdt(m) = ((fh.*(Th(m)-Th(m+1)))+Q(m))/Vrod; %./(denh(1:npesr).*Vhrod.*cph(1:npesr)) ;%[K/seg]
%          dTcoutdt(m) = ((fc.*(Tc(m+1)-Tc(m)))-Q(m))/Vrod; %./(denc(1:npesr).*Vcrod.*cpc(1:npesr)) ;%[K/seg]
%      elseif fh <= 1e-7 || fh <= 1e-7 
%          dThoutdt(m) = 0;
%          dTcoutdt(m) = 0;
%      end
         dThoutdt(m) = ((fh.*(Th(m)-Th(m+1)))-Q(m))/(Vrod); %./(denh(1:npesr).*Vhrod.*cph(1:npesr)) ;%[K/seg]
         dTcoutdt(m) = ((fc.*(Tc(m+1)-Tc(m)))+Q(m))/(Vrod); %./(denc(1:npesr).*Vcrod.*cpc(1:npesr)) ;%[K/seg]


end
Qtot = sum(Q);
% save('temperature_inter.mat','Th','Tc','dth','dtc','delTref','Q','Qtot','Uf','fh','fc','Vrod','aef')
% calor totoal intercambiado
% sum(Q)

%----------------------------------------------------------- 
% Vector resultante de ecuaciones diferenciales
%-----------------------------------------------------------

dfdt=[dThoutdt dTcoutdt]';

%----------------------------------------------------------- 
% Unidades
%-----------------------------------------------------------
%u [Kmol/m-seg]
%cp[KJ/Kmol*ï¿½K]
%den [Kmol/m3]
%k [W/m-K] 
%f [Kmol/seg]
%hs [W/m2-K]
%U [W/m2-K]
%Arod[m2]
%Vrod[m3]  
%Q[Kw]
