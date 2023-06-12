clear all;

addpath(genpath('/Users/rdey33/Downloads/VIMIMO'));


%% raw data
load('./../../triplicate_data.mat');
load('./SEIV_datasheet.mat');
 time_2 = [t2', fliplr(t2')];
linewidth = 2;

%%
hf = figure(2)
subplot(2,5,1)
errorbar(time/60,mean(1e3*host1'),std(1e3*host1'),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
ylabel({'Host density';'(cells/ml)'});
title('CBA 4','FontSize',18);
inBetween = [S_min(:,1)', fliplr(S_max(:,1)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,S_median(:,1),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);




subplot(2,5,2)
errorbar(time/60,mean(1e3*host2'),std(1e3*host2'),'o','MarkerSize',8,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('CBA 18','FontSize',18);
    inBetween = [S_min(:,2)', fliplr(S_max(:,2)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,S_median(:,2),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);




subplot(2,5,3)
errorbar(time/60,mean(1e3*host3'),std(1e3*host3'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
title('CBA 38','FontSize',18);
inBetween = [S_min(:,3)', fliplr(S_max(:,3)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,S_median(:,3),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);



subplot(2,5,4)
errorbar(time/60,mean(1e3*host4'),std(1e3*host4'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'FontSize',20)
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
  axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('PSA H100','FontSize',18);
    inBetween = [S_min(:,4)', fliplr(S_max(:,4)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,S_median(:,4),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);




subplot(2,5,5)
errorbar(time/60,mean(1e3*host5'),std(1e3*host5'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'FontSize',20);
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('PSA 13-15','FontSize',18);
    inBetween = [S_min(:,5)', fliplr(S_max(:,5)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,S_median(:,5),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);

%xlabel("Time (hours)");
%ylabel("Host density (cell/ml)");






subplot(2,5,6)
errorbar(time/60,mean(1e3*virus1'),std(1e3*virus1'),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e4 1e6 1e8 1e10]);
ylabel({'Phage density';'(virions/ml)'});
title('\phi 18:2','FontSize',18);
    inBetween = [V_min(:,1)', fliplr(V_max(:,1)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,V_median(:,1),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);

subplot(2,5,7)
errorbar(time/60,mean(1e3*virus2'),std(1e3*virus2'),'o','MarkerSize',8,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e4 1e6 1e8 1e10]);
    title('\phi 18:3','FontSize',18);
    inBetween = [V_min(:,2)', fliplr(V_max(:,2)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,V_median(:,2),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);




subplot(2,5,8)
errorbar(time/60,mean(1e3*virus3'),std(1e3*virus3'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
   yticks([1e4 1e6 1e8 1e10]);
   title('\phi 38:1','FontSize',18);
    inBetween = [V_min(:,3)', fliplr(V_max(:,3)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,V_median(:,3),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);

subplot(2,5,9)
errorbar(time/60,mean(1e3*virus4'),std(1e3*virus4'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
   yticks([1e4 1e6 1e8 1e10]);
   title('PSA HP1','FontSize',18);
    inBetween = [V_min(:,4)', fliplr(V_max(:,4)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,V_median(:,4),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);




subplot(2,5,10)
errorbar(time/60,mean(1e3*virus5'),std(1e3*virus5'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
 xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
  yticks([1e4 1e6 1e8 1e10]);
  title('PSA HS6','FontSize',18);
    inBetween = [V_min(:,5)', fliplr(V_max(:,5)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t2,V_median(:,5),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
 legend('Data','95% confidence interval','Bayesian fit');
 legend('Box','off');

han=axes(hf,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
set(gca,'FontSize',20);
set(gca,'fontname','times')  % Set it to times
xlabel("Time (hours)");
