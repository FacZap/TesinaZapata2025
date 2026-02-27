function [ y ] = buscar_time(t0,tf,timeseries)
%% esta funcion busca los valores de una timeserie entre los tiempos t0 y tf
%% devolviendo una timeserie con los valores en ese intervalo

[row,col]=size(timeseries.time);

if tf==inf
    tf=row;
end
flag=0;
i=0;
while flag==0
    i=i+1;
    t_ = round(timeseries.time(i,1) * 1000) /1000;
    if t_ == t0
        ifind=i; 
        flag=1;
    end
    if i==length(timeseries.time)
        error('No lo encontro')
    end
    
end
        y.time(1:tf-ifind+1,1) =timeseries.time(ifind:tf,1)-t0;
        y.data(1:tf-ifind+1,1) =timeseries.data(ifind:tf,1);
end

