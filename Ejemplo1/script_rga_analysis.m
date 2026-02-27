% scr7_5_rga_analisis
load('G_candidata')
Gval=dcgain(G)

% Define the set of numbers
set = [1 2 3 4 5 6 7];
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

%%
G_EE=dcgain(G);
RGA(G_EE)

Lambda_nc=G_EE.*(pinv(G_EE))'
sf=sum(Lambda_nc,2)
sc=sum(Lambda_nc,1)
matrix_rga=zeros(4,4,length(all_combinations));
for i=1:length(all_combinations)
    Gred = Gval(:,all_combinations{i});
    matrix_cond(i)=cond(Gred);
    matrix_rga(:,:,i)=Gred.*inv(Gred)'; 
%     sqd_rga(:,:,i)=RGA(RGA(RGA(matrix_rga(:,:,i))));
end
format bank
matrix_cond'
format
% III=find(matrix_cond==min(matrix_cond'))
% matrix_cond(31)
% all_combinations(31)
% matrix_rga(:,:,31)
%% ELEGIDAS A OJO (viendo la RGA de cada combinación)
length([4,10,15,20,23,29,32,35])
all_combinations{[4,10,15,20,23,29,32,35]}
matrix_cond([4,10,15,20,23,29,32,35])

% las combinaciones con RGA adecuadas tienen numero de condición muy elevados?