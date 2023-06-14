clear all;
clc;

flags.legend = 'on';

tiledlayout(2,4, 'Padding', 'none', 'TileSpacing', 'compact');

ii=1;   
fig = figure;
load("./../results_same_phi/CBA18-2_18_5-inferred.mat");

ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
xtickangle(45)
%plot_helper_osu(time2,y_series_osu);
title('\phi18:2 -- CBA 18', 'FontSize', 12);


load("./../results_same_phi/CBA18-3_4_10-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
ylim([5e4 4e6]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
xtickangle(45)
title('\phi18:3 -- CBA 4', 'FontSize', 12);


load("./../results_same_phi/CBA18-3_18_7-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);xtickangle(45)
title('\phi18:3 -- CBA 18', 'FontSize', 12);



load("./../results_same_phi/CBA38-1_38_6-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);xtickangle(45)
title('\phi38:1 -- CBA 38', 'FontSize', 12);




load("./../results_same_phi/HP1_H100_6-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);xtickangle(45)
title('PSA HP1 -- PSA H100', 'FontSize', 12);



load("./../results_same_phi/HP1_13-15_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);xtickangle(45)
title('PSA HP1 -- PSA 13-15', 'FontSize', 12);


load("./../results_same_phi/HS6_H100_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
xtickangle(45)
title('PSA HS6 -- PSA H100', 'FontSize', 12);



load("./../results_same_phi/HS6_13-15_3-inferred.mat");
ii = plot_helper(time_free_phages,free_phages,labels,time,y_series_inferred,ii, ...
    time_used,min,max,0.2);
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10]);
xlim([0 time_free_phages(end)]);
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4]);
xtickangle(45)
title('PSA HS6 -- PSA 13-15', 'FontSize', 12);


han=axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,"Free phages (" +string(cell2mat(labels.units(1,3)))+")",'interpreter','none');
xlabel(han,'Time (hours)','interpreter','none');
%title(han,'yourTitle');
set(gca,'FontSize',20)
set(gca,'fontname','times')  % Set it to times

%lgd = legend(han,'fit','data');
lgd.Layout.Tile = 'south';

% % add a bit space to the figure
% fig.Position(3) = fig.Position(3) + 250;
% % add legend
% Lgnd = legend('show');
% Lgnd.Position(1) = 0.01;
% Lgnd.Position(2) = 0.4;

% saving figure
% 
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 33 15]); %x_width=10cm y_width=15cm
% saveas(gcf,'one-step-timeseries-fig2.svg')
