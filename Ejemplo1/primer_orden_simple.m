 %% con 2
for q=selected_outputs
y1.data=yout(:,q);
y1.time=tout;
u.data=u_exc;
% u.data=u_exc(:,2);
u.time=tout;
y_f=timeseries(y1.data,y1.time);
u=timeseries(u.data,u.time);
time=tout(find(tout==50,1)+1);
% eval(sprintf('[Kp%d,Tp%d,Td%d,Fit%d]=identification_P1_HEN(tout,y_f,u,50,0)',q,q,q,q));
eval(sprintf('[Kp%d,Tp%d]=identification_P1_HEN(tout,y_f,u,50,0)',q,q));
%eval(sprintf("tfs_array(i)=tf(Kp%d,[Tp%d 1])",q,q))
end
not_selected_outputs=setdiff([1:1:4],selected_outputs)
for q=not_selected_outputs
%     eval(sprintf('[Kp%d,Tp%d,Td%d,Fit%d] = struct("x", num2cell([0,0,0,0])).x',q,q,q,q))
    eval(sprintf('[Kp%d,Tp%d] = struct("x", num2cell([0,0,0,0])).x',q,q))
end
%%
%figure, step(tfs_array(1)*0.01)
%figure, step(tfs_array(2)*0.01)
%figure, step(tfs_array(3)*0.01)