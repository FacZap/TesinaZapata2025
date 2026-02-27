load('G_candidata.mat')
% load('G_modelo.mat')
load('D_candidata.mat')

g_norm=dcgain(G);
g_norm(:,1:6)=g_norm(:,1:6)*(1/10);  % * 1 bypass /10 temp
g_norm(:,7)=g_norm(:,7)*(30/10)  % * 30 de fcu / 10 temp
g_norm=g_norm(:,[1 4 2 5 3 6 7])

% g_norm_m=dcgain(G_modelo);
% g_norm_m(:,1:6)=g_norm_m(:,1:6)/10;  % * 1 bypass /10 temp
% g_norm_m(:,7)=g_norm_m(:,7)/(30/10)  % * 30 de fcu / 10 temp

d_norm=dcgain(D);
d_norm(:,[1 3 5 7])=d_norm(:,[1 3 5 7])*(10/10) % * 10 pert temp / 10 temp
d_norm(:,[2 4 6 8])=d_norm(:,[2 4 6 8])/(10) % * 1 flujo/10 temp

writematrix(g_norm,'matrices_normalizadas.xlsx', 'Sheet', 'G');
writematrix(d_norm,'matrices_normalizadas.xlsx', 'Sheet', 'D');
