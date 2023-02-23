function fig = plot_timeseries(model,t,S,V)
% plot simulated timeseries on top of qpcr data

load('data/qpcr','data');
fig = figure;
fig.Position(3:4) = fig.Position(3:4).*[1.5 .75];

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

% hosts
subplot(1,2,1);
set(gca,'ColorOrderIndex',1);
semilogy(t,S);
hold on;
set(gca,'ColorOrderIndex',1);
semilogy(data.xdata,data.ydata(:,data.id.S),'.','HandleVisibility','off');
hold off;
xlabel('time (hrs)');
ylabel('density (1/ml)');
title('Total hosts');
legend(data.labels.host,'Location','SouthWest');
ylim([1e4 1e8]);

% model information
text_model(model);

% viruses
subplot(1,2,2);
set(gca,'ColorOrderIndex',1);
semilogy(t,V);
hold on;
set(gca,'ColorOrderIndex',1);
semilogy(data.xdata,data.ydata(:,data.id.V),'.','HandleVisibility','off');
hold off;
xlabel('time (hrs)');
ylabel('density (1/ml)');
title('Free phage');
legend(data.labels.phage,'Location','SouthEast');
ylim([1e2 1e12]);

end