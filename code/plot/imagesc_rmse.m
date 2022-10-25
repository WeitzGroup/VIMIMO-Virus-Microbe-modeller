function fig = imagesc_rmse(err,par1,par1str,par2,par2str)

fig = figure('Units','inches');
fig.Position(3:4) = [4 3];
tmpX = err(1,1);
tmpY = err(2:end,2:end);
tmpZ = -(tmpY-tmpX)/tmpX*100; % decrease in error -> positive
tmpc = max(abs(tmpZ(:)));
[tmpmax,tmpid] = max(tmpZ(:)); % biggest decrease
[tmpi,tmpj] = ind2sub(size(tmpZ),tmpid);

imagesc(tmpZ,[-tmpc +tmpc]);
hold on;
plot(tmpj,tmpi,'b*');
set(gca,'XTick',1:length(par2),'XTickLabels',cellstr(num2str(par2','%.1g')));
set(gca,'XTickLabelRotation',90);
set(gca,'YTick',1:length(par1),'YTickLabels',cellstr(num2str(par1','%.1g')));
xlabel(par2str);
ylabel(par1str);
cbar = colorbar();
cbar.Label.String = 'percent decrease in error';
colormap(flip(redblue()));
text(length(par2),length(par1)+3,...
    sprintf('*max = %.2g%%',tmpmax),...
    'Color','b');

end