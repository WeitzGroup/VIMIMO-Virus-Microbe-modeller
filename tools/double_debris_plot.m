load('./../results/SEIVD-diff-all-seed20011.mat');

%%
figure(1)
subplot(1,2,1)
Dc = pars2.Dc ;
Dc2 = pars2.Dc2;

prob = 1 - 1./(1+(D2./Dc).^2);
prob2 = 1 - 1./(1+(D2./Dc2).^2);

plot(t2,prob,'LineWidth',2.5,'Color','r');
hold on; 
plot(t2,prob2,'LineWidth',2.5,'Color','b');
xlabel('Time (hours)');
ylabel('Probability of lysis inhibition');
set(gca,'FontSize',24);
xlim([2 8]);
xticks(0:2:16)
legend('CBA module','PSA module');

subplot(1,2,2)
plot(D2,prob,'LineWidth',2.5,'Color','r');
hold on;
plot(D2,prob2,'LineWidth',2.5,'Color','b');
set(gca, 'YScale', 'log')
xlabel({'Debris concentration', '(10^7 Lysed cells/ml)'});
ylabel({'Probability of lysis inhibition'});
set(gca,'FontSize',24);
yline(0.5,'--r',LineWidth=1.5);
xline(Dc,'--r',LineWidth=1.5);
yline(0.5,'--b',LineWidth=1.5);
xline(Dc2,'--b',LineWidth=1.5);



xticks([0,2e7,4e7,6e7,8e7,10e7]);
xticklabels({'0','2','4','6','8','10'});
yticks([0.001,0.01,0.1,0.5,1]);
ylim([0.001 1])
legend('CBA module','PSA module');

% subplot(1,3,3)
% set(gca, 'YScale', 'linear')
% plot(t2,D2,'LineWidth',2.5,'Color','r');
% xlabel('Time (hours)');
% xlim([0 16]);
% xticks(0:2:16)
% ylabel({'Debris concentration', '(10^7 Lysed cells/ml)'});
% set(gca,'FontSize',24);