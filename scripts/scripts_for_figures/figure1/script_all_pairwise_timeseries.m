clear all;
clc;

color_green = [171,193,157]./255;
ii=1;
fig = figure;
load("./../results_same_phi/CBA18-2_18_5-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);
title('CBA 18:2 on 18', 'FontSize', 15);


load("./../results_same_phi/CBA18-3_4_10-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);
title('CBA 18:3 on 4', 'FontSize', 15);


load("./../results_same_phi/CBA18-3_18_7-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_confidence_interval(time_used,min,max,0.5,color_green);
plot_helper_osu(time2,y_series_osu);
title('CBA 18:3 on 18', 'FontSize', 15);

load("./../results_same_phi/CBA38-1_38_6-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_confidence_interval(time_used,min,max,0.5,color_green);
plot_helper_osu(time2,y_series_osu);
title('CBA 38:1 on 38', 'FontSize', 15);

load("./../results_same_phi/HP1_H100_6-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);

title('PSA HP1 on H100', 'FontSize', 15);

load("./../results_same_phi/HP1_13-15_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);
title('PSA HP1 on 13-15', 'FontSize', 15);


load("./../results_same_phi/HS6_H100_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);

title('PSA HS6 on H100', 'FontSize', 15);



load("./../results_same_phi/HS6_13-15_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
plot_helper_osu(time2,y_series_osu);
plot_confidence_interval(time_used,min,max,0.5,color_green);
title('PSA HS6 on 13-15', 'FontSize', 15);


han=axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,"Free phages (" +string(cell2mat(labels.units(1,3)))+")",'interpreter','none');
xlabel(han,'Time (hours)','interpreter','none');
%title(han,'yourTitle');
set(gca,'FontSize',18)




% % saving figure
% 
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 33 15]); %x_width=10cm y_width=15cm
% saveas(gcf,'one-step-timeseries-with-osu.png')
