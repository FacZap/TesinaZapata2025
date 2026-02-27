%% a)
load('G_modelo_v5.mat')
G_fcu_partial=G_modelo(:,9:11)
load('G_modelo_v1.mat')
G_modelo(:,9:11)=G_fcu_partial
dcgain(G_modelo)
RGA(dcgain(G_modelo))
G_modelo_red=G_modelo;
% RGA(RGA(dcgain(G_modelo)))
%% b) (correr la parte 'a' primero)
G_modelo_red=G_modelo;
G_modelo_red(:,[1,3:8])=[]
% RGA(RGA(dcgain(G_modelo)))
rga_red=RGA(dcgain(G_modelo_red))
%% c) (correr la parte 'a' primero)
G_modelo_red=G_modelo;

% Rearrange columns
G_modelo_red = G_modelo(:, [1 3 5 7 2 4 6 8 9 10 11]);

% Display result
disp('Original matrix:')
RGA(dcgain(G_modelo))
% disp(G_modelo)
% G_modelo

disp('Rearranged matrix:')
% disp(G_modelo_red)
% G_modelo_red

rga_red=RGA(dcgain(G_modelo_red))
%% ? ('a' alternativo)
G_modelo_red=G_modelo;
G_modelo_red(:,[1:3,5:8])=[]
% RGA(RGA(dcgain(G_modelo)))
rga_red=RGA(dcgain(G_modelo_red))
%% INICIALIZAR EL NUMERO DE COMBINACIONES
% scr7_5_rga_analisis
% load('G_modelo_v1')
% Gval=dcgain(G_modelo)

% Define the set of numbers
set = [1 2 3 4 5 6 7 8 9 10 11];
% Number of elements in the set
n = numel(set);
% Initialize a cell array to store all combinations
all_combinations = {};

% Iterate over lengths of combinations
for k = 4
    % Get combinations of length k
    comb_k = nchoosek(set, k);
    % Store each combination as a row in a cell array
    all_combinations = [all_combinations; num2cell(comb_k, 2)];
end
% 330
%% CALCULO DE MATRICES
 warning('OFF', 'all')
G_EE=dcgain(G_modelo_red);
Lambda_nc=G_EE.*(pinv(G_EE))'
sf=sum(Lambda_nc,2)
sc=sum(Lambda_nc,1)
matrix_rga=zeros(4,4,length(all_combinations));
for i=1:length(all_combinations)
    Gred = G_EE(:,all_combinations{i});
%     RGA(Gred)==rga_red
    matrix_cond(i)=cond(Gred);
    matrix_rga(:,:,i)=Gred.*inv(Gred)'; 
%     sqd_rga(:,:,i)=RGA(RGA(RGA(matrix_rga(:,:,i))));
end
 warning('ON', 'all')
%%
format bank
matrix_cond'
format
III=find(matrix_cond==min(matrix_cond'))
matrix_cond(III)
all_combinations(III)
matrix_rga(:,:,III)
%%
comb_array=cell2mat(all_combinations);
search_array=[2 9 10 11];

for i=1:height(comb_array)
    if (all(comb_array(i,:)==search_array))
        key=i
    end
end
matrix_cond(key)
all_combinations(key)
matrix_rga(:,:,key)
    
%% ELEGIDAS A OJO (viendo la RGA de cada combinación)
% length([4,10,15,20,23,29,32,35])
% all_combinations{[4,10,15,20,23,29,32,35]}
% matrix_cond([4,10,15,20,23,29,32,35])

% las combinaciones con RGA adecuadas tienen numero de condición muy elevados?