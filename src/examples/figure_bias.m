% measurement bias models - multiplicative and additive
% what happens to data under different models?

y = logspace(4,6,10);

biasstr = 'additive';

switch biasstr
    case 'multiplicative'
        lgdstr = {'original','120% bias','80% bias'};
        y1 = y*1.2;
        y2 = y*0.8;
    case 'additive'
        lgdstr = {'original','+1e4 constant bias','-1e4 constant bias'};
        y1 = y+1e4;
        y2 = y-1e4;
end

fig = figure();

subplot(2,2,1);
semilogy(y);
hold on;
semilogy(y1);
semilogy(y2);
xlim([1 length(y)]);
title('timeseries in log space');
set(gca,'FontSize',12);
grid on;
legend(lgdstr,'Location','NorthWest');

subplot(2,2,2);
plot(y);
hold on;
plot(y1);
plot(y2);
xlim([1 length(y)]);
title('timeseries in linear space');
set(gca,'FontSize',12);
grid on;
legend(lgdstr,'Location','NorthWest');

subplot(2,2,3);
semilogy(abs(y-y1),'r');
xlim([1 length(y)]);
title('abs error in log space');
set(gca,'FontSize',12);
grid on;

subplot(2,2,4);
plot(abs(y-y1),'r');
xlim([1 length(y)]);
title('abs error in linear space');
set(gca,'FontSize',12);
grid on;

fig.Position(3:4) = fig.Position(3:4).*[1.75 1.5];
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;

print(sprintf('results/examples/bias_%s',biasstr),'-dpng');