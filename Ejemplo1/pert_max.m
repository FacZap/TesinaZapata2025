%pert_max
thin1=5;
tcin1=-5;
tcin2=-5;
disp('Listo: 5, 0, -5, -5')

% RANGO MAXIMO
disp('OFFSET TOLERABLE: 0, 5.5, 0, 4')
% Lautaro Braccia <lautaro.braccia.lb@gmail.com>
% 	
% mar, 3 jun, 3:24 p.m.
% 	
% 	
% para Pato, mí
% Hola Facu, 
% Datos importantes que se me pasó por alto decirte: 
% 
% 1- el control y el diseño de la red fueron hechos para soportar (como peor condición) las siguientes perturbaciones a la entrada:
% 
% #variación a la entrada [límite inferior, límite superior] 
% Thin_1 = [0, 5]
% Thin_2 = [0, 0]
% Tcin_1 = [-5, 0]
% Tcin_2 = [-5, 0]
% # No se consideran variaciones del flujo 
% 
% 2- Y considerando que la red controlada puede tener los siguientes offset en la salida de :
% 
% #offset tolerado [límite inferior, límite superior] 
% Thin_1 = [0, 0]
% Thin_2 = [-5.5, 5.5]
% Tcin_1 = [0, 0]
% Tcin_2 = [4, 4]
