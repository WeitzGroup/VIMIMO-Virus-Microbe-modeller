function fig = plotting_confidence_interval(model,t,S,V,filestr,linewidth,S_max,S_min,V_max,V_min)
% plot simulated timeseries on top of qpcr data, each channel separately

load('data/qpcr','data');
fig = figure;
fig.Position(3:4) = fig.Position(3:4).*[2.5 1];
fig.Position(1) = fig.Position(1)-fig.Position(3)*.1;

% placeholders if no arguments are passed (plot qpcr data only)
if ~exist('model','var') || isempty(model)
    model = SIV(5,5);
end
if ~exist('t','var') || isempty(t)
    t = nan;
end
if ~exist('S','var') || isempty(S)
    S = nan(1,5);
end
if ~exist('V','var') || isempty(V)
    V = nan(1,5);
end
if ~exist('linewidth','var') || isempty(linewidth)
    linewidth = 1;
end



n = max(model.NH,model.NV);

% hosts
for i = 1:n
    subplot(2,n,i);
    set(gca, 'YScale', 'log')
    set(gca,'ColorOrderIndex',2);
    plot(data.xdata,data.ydata(:,data.id.S(i)),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255])%,'HandleVisibility','off');
  
    hold on;
    set(gca,'ColorOrderIndex',1);
    set(gca, 'YScale', 'log')
    set(gca,'FontSize',20);
    

    %plot(t,S(:,i),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
    
    %plot(t, S_min(:,i), 'w', 'LineWidth', 2);
    %plot(t, S_max(:,i), 'w', 'LineWidth', 2);
    
    time_2 = [t', fliplr(t')];
    inBetween = [S_min(:,i)', fliplr(S_max(:,i)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    
    plot(t,S(:,i),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
    %shade(t,S_min(:,i),t,S_max(:,i),'FillType',[1 2;2 1],'FillColor',[0.7 0.7 0.7]);
    

    hold off;
    %xlabel('time (hrs)');
    %ylabel('density (1/ml)');
    %title(sprintf('host %s',data.labels.host(i)));
    ylim([1e5 1e8]);
    xlim([0 16]);
    xticks(0:2:16);
    yticks([1e5 1e6 1e7 1e8]);
end

% viruses
for i = 1:n
    subplot(2,n,i+n);
    set(gca, 'YScale', 'log')
    set(gca,'ColorOrderIndex',2);
    plot(data.xdata,data.ydata(:,data.id.V(i)),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255])%,'HandleVisibility','off');
    hold on;
    set(gca,'ColorOrderIndex',1);
    set(gca, 'YScale', 'log')
    set(gca,'FontSize',20)
    
    time_2 = [t', fliplr(t')];
    inBetween = [V_min(:,i)', fliplr(V_max(:,i)')];
    fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
    plot(t,V(:,i),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);

    %shade(t,V_min(:,i),t,V_max(:,i),'FillType',[1 2;2 1],'FillColor',[0.7 0.7 0.7]);
    

    hold off;
    %xlabel('time (hrs)');
    %ylabel('density (1/ml)');
    %title(sprintf('phage %s',data.labels.phage(i)));
    ylim([1e4 1e11]);
    xlim([0 16]);
    xticks(0:2:16);
    yticks([1e4 1e6 1e8 1e10]);

end

% model information
if exist('filestr','var')
    tmpstr = filestr;
else
    tmpstr = sprintf('%s-%s',model.name,model.odestr());
end
%text(1.3,0.5,tmpstr,'Units','normalized','Rotation',90,'HorizontalAlignment','center','Color','red');

end