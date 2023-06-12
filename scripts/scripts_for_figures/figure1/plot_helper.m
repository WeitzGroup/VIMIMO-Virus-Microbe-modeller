function  i = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,i,time_used,min,max,grayscale)

%color_def = [70/255,210/255,130/255];
%color_def = [56, 142, 60]./255;
color_def = [121, 85, 72]./255;
color_def = [120,133,105]./255;
color_def = [115, 188,170]./255;
color_def = [171,193,157]./255;
%subplot(2,4,i);

nexttile

[~,something] = size(free_phages);
plot_confidence_interval(time_used,min,max,grayscale,color_def);hold on;
if something == 1
plot(time_free_phages,free_phages,'o','LineWidth', 2,'MarkerFaceColor',[70/255,130/255,180/255]);
else
errorbar(time_free_phages,mean(free_phages,2),std(free_phages'),'LineWidth',2,'LineStyle','none','Marker','o','MarkerFaceColor',[70/255,130/255,180/255],'Color',[70/255,130/255,180/255],'DisplayName','Bayesian fit');
end
 axis('square');
%ylim([1e2 1e8]);

%xlabel('Time (hours)','interpreter','none')
%ylabel("Free phages (" +string(cell2mat(labels.units(1,3)))+")",'interpreter','none');
title(string(labels.phage)+'-'+string(labels.host));
hold on;
plot(time,y_series_inferred(end,:),'-','LineWidth',2,'Color',color_def,'DisplayName','Data');hold on;

if i == 8
legend('95 % confidence interval','Data','Bayesian fit');
legend('boxoff');
end

set(gca, 'YScale', 'log');
set(gca,'FontSize',14)
set(gca,'fontname','times')  % Set it to times

i=i+1;
end

