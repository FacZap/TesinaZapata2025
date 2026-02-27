uh112=uh112_initial+0.02;
%uh112=0.92;
uh211=0;
uh222=0;
uc112=0;
uc211=0;
uc222=0;
fcu=0;
%% INI
thin1=0;
fhin1=0;
thin2=0;
fhin2=0;
tcin1=0;
fcin1=0;
tcin2=0;
fcin2=0;
sp1=385;
sp2=400;
sp3=560;
sp4=340;
sim('Red_problema1_original.slx')
% sim('Red_problema1_COPIA.slx')

%% VALORES DE BYPASSES OPTIMOS
uh112=0.014935258720777856;
uh211=0.05299733469368127;
uh222=0.08194236649754925;
uc112=0.0;
uc211=0.0;
uc222=0.0;
fcu=0;

%% PLOT
show_graphs=1;
if show_graphs == 1
    figure,
    ax1=subplot(4,1,1); plot(tout,yout(:,1),'r'), hold on, plot(tout, ones(length(tout),1)*sp1, 'g'), title('Th_o 1')
    ax2=subplot(4,1,2); plot(tout,yout(:,2),'r'), hold on, plot(tout, ones(length(tout),1)*sp2, 'g'), title('Th_o 2')
    ax3=subplot(4,1,3); plot(tout,yout(:,3),'b'), hold on, plot(tout, ones(length(tout),1)*sp3, 'g'), title('Tc_o 1')
    ax4=subplot(4,1,4); plot(tout,yout(:,4),'b'), hold on, plot(tout, ones(length(tout),1)*sp4, 'g'), title('Tc_o 2')
    linkaxes([ax1,ax2,ax3,ax4],'x');
end
%% ERROR: diferencia entre setpoints y valor final de las salidas
final_value=[0 0 0 0];
for k = 1:4
    final_value(k) = (yout(length(tout), k));
    eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
    eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
end
err_sgnd
clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));

%% VARIAR BYPASSES
final_value=[0 0 0 0];
incremental=[0.0025,0.005,0.0075,0.01,0.0125,0.015,0.0175,0.02];
clear err_sgnd_matriz
n=1;
for c = ['h' 'c']
    for i = [112, 211, 222]
        for j = [incremental+0.04,incremental+0.06,incremental+0.08,incremental+0.1,0]
            eval(sprintf('u%c%d = %0.4f;', c, i, j));
            if j~=0
             sim('Red_problema1_original.slx')
             for k = 1:4
                 final_value(k) = (yout(length(tout), k));
                 eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
                 eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
             end
             %clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
             string_display=sprintf('u%c%d = %0.1f', c, i, j)
             err_sgnd; % breakpoint
             err_sgnd_matriz(n,:)=err_sgnd % breakpoint
             n=n+1;
            end
        end
    end
end
%% VARIAR TEMPS ENTRADA
final_value=[0 0 0 0];
n=1;
for c1 = ['t']
 for i = [1, 2]
     for c2 = ['h' 'c']
        for j = [50 100 150 0]
            eval(sprintf('%c%cin%d = %0.1f;', c1, c2, i, j));
            if j~=0
                sim('Red_problema1_original.slx')
                for k = 1:4
                   final_value(k) = (yout(length(tout), k));
                   eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
                   eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
                end
                % clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
                string_display=sprintf('%c%cin%d = %0.1f;', c1, c2, i, j)
                err_sgnd_matriz(n,:)=err_sgnd % breakpoint
                n=n+1;
            end
        end
    end
 end
end
%% VARIAR FCU
final_value=[0 0 0 0];
clear err_sgnd_matriz
n=1;
for j = [10,100,200,1000,-5,0]
    eval(sprintf('fcu = %d;', j));
    if j~=0
        sim('Red_problema1_original.slx')
        for k = 1:4
            final_value(k) = (yout(length(tout), k));
            eval(sprintf('err_rel(%d) = abs((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
            eval(sprintf('err_sgnd(%d)=((final_value(%d) - sp%d) / sp%d) * 100;', k, k, k, k));
        end
        clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
        string_display=sprintf('fcu = %d',  j)
        err_sgnd % breakpoint
        err_sgnd_matriz(n,:)=err_sgnd % breakpoint
        n=n+1;
    end
end

%% ESTUDIAR RTA DINAMICA DE uh112
incremental=[0.0025,0.005,0.0075,0.01,0.0125,0.015,0.0175,0.02];
clear final_value, clear max_value
n=1;
k=1;
for c = ['h']
    for i = [112]
        for j = [incremental,incremental+0.02,incremental+0.04,incremental+0.06,incremental+0.08,0]
            eval(sprintf('u%c%d = %0.4f;', c, i, j));
            if j~=0
             sim('Red_problema1_original.slx')
             final_value(n) = yout(length(tout), k);
             max_value(n) = max(yout([40:60],k))
             %clipboard('copy', sprintf('%.4f\t%.4f\t%.4f\t%.4f', err_sgnd));
             string_display=sprintf('u%c%d = %0.1f', c, i, j)
             n=n+1;
            end
        end
    end
end

