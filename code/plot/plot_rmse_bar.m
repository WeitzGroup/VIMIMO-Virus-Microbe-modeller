function fig = plot_error(err,legendstr)

fig = figure('Units','inches');
fig.Position(3:4) = [4 3];
tmpb = bar(err,'FaceColor','flat');
tmpb.CData(1,:) = [.5 .5 .5];
tmpb.CData(2:end,:) = mcolors((2:length(err))+1);
tmpstr = ['baseline',legendstr];
set(gca,'XTickLabel',tmpstr,'XTickLabelRotation',60);
grid on;
title('simulation error');

end