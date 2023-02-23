function fig = plot_AIC(mcmcfit)

fig = figure();
n = length(mcmcfit.paramstr);
tmpxstr = strcat('combo',cellstr(num2str((1:n)')));
tmpcolor = [.0000 .4470 .7410; .8500 .3250 .0980; .9290 .6940 .1250];
fs = 12;

subplot(2,3,1);
hold on;
for i = 1:n
    bar(i,mcmcfit.numparam(i),.7);
end
hold off;
xlim([0.2 n+0.8]);
set(gca,'XTickLabel',tmpxstr);
title('number of parameters');
box on;
grid on;
set(gca,'FontSize',fs);

subplot(2,3,2);
hold on;
for i = 1:n
    bar(i,mcmcfit.sumsquares(:,i),'FaceColor',tmpcolor(i,:));
end
tmpx = xlim;
plot(tmpx,mcmcfit.sumsquares_original*[1 1],'r-');
tmpy = ylim;
if (tmpy(2)-mcmcfit.sumsquares_original)/tmpy(2) < 0.2
    tmpy(2) = tmpy(2)*1.1;
end
text(tmpx(1)+.04*diff(tmpx),mcmcfit.sumsquares_original+.04*diff(tmpy),'original simulation','Color','red');
ylim(tmpy);
hold off;
set(gca,'XTick',1:n,'XTickLabel',tmpxstr);
title('error');
box on;
grid on;
set(gca,'FontSize',fs);

subplot(2,3,3);
hold on;
for i = 1:n
    bar(i,mcmcfit.AIC(:,i),'FaceColor',tmpcolor(i,:));
end
hold off;
set(gca,'XTick',1:n,'XTickLabel',tmpxstr);
title('AIC');
box on;
grid on;
set(gca,'FontSize',fs);

subplot(2,3,4);
set(gca,'Visible','off');
tmpstr = sprintf('model: %s (NE=%d)\n',strrep(mcmcfit.model.name,'_','-'),mcmcfit.model.NE);
for i = 1:n
    tmpstr = sprintf('%s\ncombo%d: %s',tmpstr,i,strjoin(mcmcfit.paramstr{i}));
end
text(0,1,tmpstr,'VerticalAlignment','top','FontSize',12);
set(gca,'FontSize',fs);

fig.Position(3:4) = fig.Position(3:4).*[2 1.5];
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;

end