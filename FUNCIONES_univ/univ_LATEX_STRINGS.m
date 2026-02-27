%%
G_ltx=g_est;
%%
G_ltx=G_modelo;
%%
G_ltx=ans;
%% matriz FUNCION TRANSFERENCIA
clc
for i=1:4
    for j=1:4
        if ~isequal(G_ltx(i,j),tf(0))
            LTX_STR{i,j}=tf2text(G_ltx,'s',j,i);
        else
            LTX_STR{i,j}='0';
        end
        LTX_STR{i,j} = strrep(LTX_STR{i,j}, '--', '-');
        disp(strcat(LTX_STR{i,j},' & '))
    end
    disp('\\')
end

%% matriz NÚMERICA --> strings latex
rows_ltx = cell(size(G_ltx,1),1);

for i = 1:size(G_ltx,1)
    fila = '';
    for j = 1:size(G_ltx,2)
        if abs(G_ltx(i,j))>(1e-5)
            elem = num2str(G_ltx(i,j),'%.2f');
        else
            elem = num2str(0);
        end
        if j < size(G_ltx,2)
            fila = [fila elem ' & '];
        else
            fila = [fila elem ' \\'];
        end
    end
    rows_ltx{i} = fila;
    disp(rows_ltx{i})
end
fprintf('\n')

%% FORMATO NUMERICO

for i = 1:size(G_ltx,1)
    for j = 1:size(G_ltx,2)
        if abs(G_ltx(i,j))>(1e-5)
            G_ltx_mod(i,j) = round(G_ltx(i,j),2);
        else
            G_ltx_mod(i,j) = 0;
        end
    end
end
fprintf('\n')


%%
 
% \begin{align*}
% \renewcommand*{\arraystretch}{1.5}
% \[
% \begin{bmatrix}
% \frac{117.9852}{2.4401e^{-06}s+1} & \frac{32.2261}{2.1083s+1} & 0 & 0 & 0 & 0 & 0 \\
% \frac{-17.4402}{4.3926s+1} & \frac{-5.0215}{6.0059s+1} & \frac{37.3741}{3.5406s+1} & \frac{19.3373}{3.7221s+1} & \frac{40.0978}{2.6414s+1} & \frac{11.8435}{1.0896s+1} & \frac{-0.018906}{0.14456s+1} \\
% \frac{-30.6126}{3.7767s+1} & \frac{-8.9542}{4.9589s+1} & \frac{-58.6298}{3.256s+1} & \frac{-33.979}{1.9526s+1} & 0 & 0 & 0 \\
% \frac{-8.7301}{4.0337s+1} & \frac{-2.5361}{4.6545s+1} & \frac{18.8739}{2.2286s+1} & \frac{9.67}{3.426s+1} & \frac{-20.6431}{1.3248s+1} & \frac{-7.9434}{1.5949s+1} & 0 \\
% \end{bmatrix}
% \]
% \end{align*}