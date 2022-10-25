function fig = plot_mcmc_chains(mcmcpars, chain, transient_id)
% plot mcmc chains - outputs a single figure, with one subplot per parameter

load('data/parameters','pars_units'); % load units
tmpvars = fieldnames(mcmcpars);
n = length(tmpvars);

fig = figure();
k = 0;
for i = 1:n
    tmpid = 1:length(mcmcpars.(tmpvars{i}).subid);
    subplot(1,n,i);
    plot(chain(:,k+tmpid));
    area_transient(transient_id);
    tmpstr = tmpvars{i};
    if mcmcpars.(tmpvars{i}).log==1
        tmpstr = sprintf('log10 %s',tmpstr);
    end
    title(tmpstr);
    ylabel(pars_units.(tmpvars{i}));
    xlabel('step');
    xlim([1 length(chain)]);
    k = k+length(tmpid);
end
fig.Position(3:4) = fig.Position(3:4).*[.7*n .75];
fig.Position(1) = fig.Position(1)-fig.Position(3)*.2;

end
