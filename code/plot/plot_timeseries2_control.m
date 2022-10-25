function fig = plot_timeseries2_control(model,t,S,show_qpcr_infected,filestr)
% plot simulated timeseries on top of qpcr data, each channel separately
% control experiment (no viruses)

load('data/qpcr','data');
data2 = data;
load('data/qpcr_control','data');
fig = figure;
fig.Position(3:4) = fig.Position(3:4).*[2.5 .5];
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
if ~exist('show_qpcr_infected','var') || isempty(show_qpcr_infected)
    show_qpcr_infected = 0;
end


n = max(model.NH,model.NV);

% hosts
for i = 1:n
    subplot(1,n,i);
    set(gca,'ColorOrderIndex',2);
    semilogy(t,S(:,i),'Color',[1 1 1]*.5);
    hold on;
    set(gca,'ColorOrderIndex',1);
    semilogy(data.xdata,data.ydata(:,i),'.','HandleVisibility','off');
    if show_qpcr_infected
        semilogy(data2.xdata,data2.ydata(:,i),'.','HandleVisibility','off');
    end
    hold off;
    xlabel('time (hrs)');
    ylabel('density (1/ml)');
    title(sprintf('host %s',data.labels.host(i)));
    ylim([1e4 1e10]);
end

% model information
%{
if exist('filestr','var')
    tmpstr = filestr;
else
    tmpstr = sprintf('%s-%s',model.name,model.odestr());
end
text(1.3,0.5,tmpstr,'Units','normalized','Rotation',90,'HorizontalAlignment','center','Color','red');
%}

end