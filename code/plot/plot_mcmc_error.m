function fig = plot_mcmc_error(err, transient_id)
% plot mcmc error - outputs a single figure, with one subplot per error
% column

n = length(err.labels);

fig = figure();
for i = 1:n
    subplot(1,n,i);
    semilogy(err.vals(:,err.id==i));
    area_transient(transient_id);
    if ~isempty(err.legends{i})
        legend(err.legends{i},'Location','NorthEast');
    end
    title(err.labels(i));
    xlim([1 length(err.vals)]);
end
fig(1).Position(3:4) = fig.Position(3:4).*[.75*n .75];

end
