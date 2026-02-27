fd1 = tf([0 1],[(filt) 1]);
fd2 = tf([0 1],[(filt) 1]);
fd3 = tf([0 1],[(filt) 1]);
fd4 = tf([0 1],[(filt) 1]);
F_d = [fd1 0 0 0;0 fd2 0 0; 0 0 fd3 0; 0 0 0 fd4];

%

Kimc_u_f = (Gf)^-1*F_d;

K_clasica_f = [eye(size(Kimc_u_f))-Kimc_u_f*Gf]^-1*Kimc_u_f;

% FULL
% Kimc_u=Kimc_u_d
% Kimc_u=Kimc_u_s
Kimc_u=Kimc_u_f

% Gimc=Gd
% Gimc=Gs
Gimc=Gf

% K_clasica = K_clasica_d
% K_clasica = K_clasica_s;
K_clasica = K_clasica_f;

switch_var=2;
try
    inicializar_areas
catch
    inicializar_areas_ej7
end