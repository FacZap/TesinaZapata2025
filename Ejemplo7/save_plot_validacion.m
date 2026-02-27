% save_plot_validacion;

figs_valid=figure,
 ax1=subplot(4,1,1); plot(tout,yout(:,1),'r'), hold on, plot(tout, ones(length(tout),1)*sp1, 'g.'), plot(tout,yout(:,5),'k--'), title('Th_o 1'), grid on, legend({'Th1_o','Setpoint1'})
 ax2=subplot(4,1,2); plot(tout,yout(:,2),'r'), hold on, plot(tout, ones(length(tout),1)*sp2, 'g.'), plot(tout,yout(:,6),'k--'), title('Th_o 2'), grid on, legend({'Th2_o','Setpoint2'})
 ax3=subplot(4,1,3); plot(tout,yout(:,3),'b'), hold on, plot(tout, ones(length(tout),1)*sp3, 'g.'), plot(tout,yout(:,7),'k--'), title('Tc_o 1'), grid on, legend({'Tc1_o','Setpoint3'})
 ax4=subplot(4,1,4); plot(tout,yout(:,4),'b'), hold on, plot(tout, ones(length(tout),1)*sp4, 'g.'), plot(tout,yout(:,8),'k--'), title('Tc_o 2'), grid on, legend({'Tc2_o','Setpoint4'})       
 linkaxes([ax1,ax2,ax3,ax4],'x'), xlim([t_step-2 sim_time]);
 savefig(figs_valid,strcat(select_area,'_',num2str(u_selected),'_validacion'))
 close all
 clear ax1
 clear ax2
 clear ax3
 clear ax4
 clear figs_valid