%% plot qpcr data


fig(1) = plot_timeseries2();
print(fig(1),'results/examples/qpcr','-dpng');

fig(2) = plot_timeseries2_control();
print(fig(2),'results/examples/qpcr_control','-dpng');

fig(3) = plot_timeseries2_control([],[],[],1);
print(fig(3),'results/examples/qpcr_compare','-dpng');


%% control data w/ replicates

clear;
load('data/qpcr_raw');

tmpx = qpcr_replicates{4};
tmpx2 = mean(tmpx,3);
tmpx2err = std(tmpx,0,3);
%%
fig = figure();
fig.Position(3:4) = fig.Position(3:4).*[2.5 .5];
for i = 1:5
    subplot(1,5,i);
    errorbar(t,tmpx2(:,i),tmpx2err(:,i),'.');
    set(gca,'YScale','log');
    ylim([1e4 1e10]);
    xlabel('t (hrs)');
    ylabel('density (1/ml)');
    title(labels.host(i));
end