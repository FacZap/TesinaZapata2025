% Script: vm_plot.m

% Define the number (can be 1, 2, or 3)
% Validate input
if ~isscalar(vm_plot_number) || ~ismember(vm_plot_number, 1:4)
    error('Input must be a number between 1 and 4.');
end

% Run specific code depending on the input
switch vm_plot_number
    case 1
        fig_1=figure,
        ax1=subplot(4,1,1); plot(tout,yout(:,1),'r'), hold on, plot(tout, ones(length(tout),1)*sp1, 'g.'), title('Th_o 1'), grid on, legend({'Th1_o','Setpoint1'})
        ax2=subplot(4,1,2); plot(tout,yout(:,2),'r'), hold on, plot(tout, ones(length(tout),1)*sp2, 'g.'), title('Th_o 2'), grid on, legend({'Th2_o','Setpoint2'})
        ax3=subplot(4,1,3); plot(tout,yout(:,3),'b'), hold on, plot(tout, ones(length(tout),1)*sp3, 'g.'), title('Tc_o 1'), grid on, legend({'Tc1_o','Setpoint3'})
        ax4=subplot(4,1,4); plot(tout,yout(:,4),'b'), hold on, plot(tout, ones(length(tout),1)*sp4, 'g.'), title('Tc_o 2'), grid on, legend({'Tc2_o','Setpoint4'})
    case 2
        fig_2=figure,
        ax1=subplot(4,1,1); plot(tout,yout(:,1),'r'), hold on, plot(tout, ones(length(tout),1)*sp1, 'g.'), title('Th_o 1'), grid on, legend({'Th1_o','Setpoint1'})
        ax2=subplot(4,1,2); plot(tout,yout(:,2),'r'), hold on, plot(tout, ones(length(tout),1)*sp2, 'g.'), title('Th_o 2'), grid on, legend({'Th2_o','Setpoint2'})
        ax3=subplot(4,1,3); plot(tout,yout(:,3),'b'), hold on, plot(tout, ones(length(tout),1)*sp3, 'g.'), title('Tc_o 1'), grid on, legend({'Tc1_o','Setpoint3'})
        ax4=subplot(4,1,4); plot(tout,yout(:,4),'b'), hold on, plot(tout, ones(length(tout),1)*sp4, 'g.'), title('Tc_o 2'), grid on, legend({'Tc2_o','Setpoint4'})
    case 3
        disp('Running code for number 3...');
        % Add your code here
    case 4
        ax1=subplot(3,1,1); plot(tout,d_exc(:,1),'r'), hold on, plot(tout, ones(length(tout),1)*620, 'k.'), title('thin1_pert'), grid on, ylim([619.5 625.5])
        ax2=subplot(3,1,2); plot(tout,d_exc(:,5),'c'), hold on, plot(tout, ones(length(tout),1)*300, 'k.'), title('tcin1_pert'), grid on, ylim([294.5 300.5])
        ax3=subplot(3,1,3); plot(tout,d_exc(:,7),'b'), hold on, plot(tout, ones(length(tout),1)*280, 'k.'), title('tcin2_pert'), grid on, ylim([274.5 280.5])
end