function imagesc_parmat(x,xstr,xlims)
% plot a parameter matrix with host and phage labels

load('data/labels','labels');
load('data/parameters','pars_units');
fs = 12;

if exist('xlims','var') && ~isempty(xlims)
    tmpim = imagesc(x,xlims);
else
    tmpim = imagesc(x);
end
tmpim.AlphaData = x~=0 & ~isnan(x);
hold on;
[tmpy,tmpx] = find(isnan(x));
plot(tmpx,tmpy,'r*','LineWidth',1.5,'MarkerSize',10);
hold off;
set(gca,'XTick',1:size(x,2),'YTick',1:size(x,1));
set(gca,'XTickLabels',labels.phage,'YTickLabels',labels.host);
set(gca,'XTickLabelRotation',90);
cbar = colorbar();
cbar.Label.String = pars_units.(xstr);
title(xstr);
set(gca,'FontSize',fs);


end