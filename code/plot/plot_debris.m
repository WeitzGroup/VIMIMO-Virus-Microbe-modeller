function fig = plot_debris(t1,D1,t2,D2,parvec,parstr)

if ~iscell(t2)
    t2 = {t2};
end
if ~iscell(D2)
    D2 = {D2};
end

% import qpcr data
load('data/qpcr','data');

fig = figure('Units','inches');
fig.Position(3:4) = [4 3];

tmpt = data.xdata;
tmpS = sum(data.ydata(:,1:5),2); % host data only
semilogy(tmpt,tmpS,'.','MarkerSize',7);
hold on;
semilogy(tmpt,cumsum(tmpS),'.','MarkerSize',7);

semilogy(t1,D1,'Color',[1 1 1]*.5,'LineWidth',2); % baseline model

set(gca,'ColorOrderIndex',3);
for i = 1:length(parvec) % variations
    semilogy(t2{i},D2{i});
end

xlim([t1(1) t1(end)]);
tmpy = ylim;
ylim([1e-2 tmpy(2)]);
xlabel('time (hrs)');
ylabel('density (1/mL)');
title('debris accumulation');
tmpstr = strcat('cumulative debris, ',parstr,'=',string(parvec));
tmpstr = ['living cells (qPCR)','cumulative living cells (qPCR)','cumulate debris (baseline model)',tmpstr];
legend(tmpstr,'Location','southeast');
grid on;

end