% BUILD_TFs
Thout_1_end = yout(end,1); Thout_2_end= yout(end,2);
Tcout_1_end = yout(end,3); Tcout_2_end= yout(end,4);
aux1 = abs(Thout_1_end - Thout_1_ini)>5e-4;
aux2 = abs(Thout_2_end - Thout_2_ini)>5e-4;
aux3 = abs(Tcout_1_end - Tcout_1_ini)>5e-4;
aux4 = abs(Tcout_2_end - Tcout_2_ini)>5e-4;
selected_outputs = [aux1 aux2 aux3 aux4].*[1 2 3 4];
selected_outputs(selected_outputs == 0) = []
not_selected_outputs=setdiff([1:1:4],selected_outputs)
T_end(1) = Thout_1_end;
T_end(2) = Thout_2_end;
T_end(3) = Tcout_1_end;
T_end(4) = Tcout_2_end;
g_est_vector(1) = (Thout_1_end - Thout_1_ini)/delta; g_est_vector(2) = (Thout_2_end - Thout_2_ini)/delta;
g_est_vector(3) = (Tcout_1_end - Tcout_1_ini)/delta; g_est_vector(4) = (Tcout_2_end - Tcout_2_ini)/delta;
for i = 1:4
    g_est(i,u_selected) = g_est_vector(i)
end
t_vect=tout;

for j=selected_outputs
    t_aux1=(t_vect(find(abs(yout(:,j)-salida_pto_op(j))>abs(T_end(j)-salida_pto_op(j))*1.38,1,'last')) - t_step);
    t_aux2=(t_vect(find(abs(yout(:,j)-salida_pto_op(j))<abs(T_end(j)-salida_pto_op(j))*0.62,1,'last')) - t_step);
    if isempty(t_aux1)
        t_aux1=0;
    end
    if isempty(t_aux2) 
        t_aux2=0;
    end
    t_corte(j)=max(t_aux1,t_aux2)
end
for j=not_selected_outputs
    t_corte(j)=0
end
for k=selected_outputs
    G_modelo(k,u_selected)=tf(g_est(k,u_selected),[t_corte(k) 1])
end
for k=not_selected_outputs
    G_modelo(k,u_selected)=tf(0)
end
    
clear t_corte
