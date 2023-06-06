load('./../results/local/SEIV70_00000_Dbeprt_1001/seed341L0_datasheet.mat');


figure(1)
subplot(1,3,1)
Dc = pars2.Dc ;
prob = 1 - 1./(1+(D2./Dc).^2);
plot(t2,prob,'LineWidth',2.5,'Color','r');
xlabel('Time (hours)');
ylabel('Probability of lysis inhibition');
set(gca,'FontSize',24);
xlim([0 16]);
xticks(0:2:16)


subplot(1,3,2)
plot(D2,prob,'LineWidth',2.5,'Color','r');
set(gca, 'YScale', 'log')
xlabel({'Debris concentration', '(10^7 Lysed cells/ml)'});
ylabel({'Probability of lysis inhibition'});
set(gca,'FontSize',24);
yline(0.5,'--k',LineWidth=1.5);
xline(Dc,'--k',LineWidth=1.5);
xticks([0,Dc+3e6,2e7,4e7,6e7,8e7,10e7]);
xticklabels({'0','D_c','2','4','6','8','10'});
yticks([0.001,0.01,0.1,0.5,1]);
ylim([0.001 1])


subplot(1,3,3)
set(gca, 'YScale', 'linear')
plot(t2,D2,'LineWidth',2.5,'Color','r');
xlabel('Time (hours)');
xlim([0 16]);
xticks(0:2:16)
ylabel({'Debris concentration', '(10^7 Lysed cells/ml)'});
set(gca,'FontSize',24);