function param = mcmcpars2param(mcmcpars)
% convert mcmcpars struct into param cell that is compatible with mcmcrun.m
% this function is only called once to initialize the mcmc

tmpvars = fieldnames(mcmcpars);
k = 1;
for i = 1:length(tmpvars)
    tmps = mcmcpars.(tmpvars{i}); % grab the sub-struct (tmps) for each variable
    % apply log transformation - todo, throw error if there are any infs?
    if tmps.log==0
        tmpf = @(x) (x);
    elseif tmps.log==1
        tmpf = @(x) log10(x);
    end
    for j = 1:length(tmps.subid)
       param{k} = {sprintf('%s%d',tmpvars{i},tmps.subid(j)),... % variable name
           tmpf(tmps.startval(j)),... % starting value
           tmpf(tmps.lims(1)),... % minimum sampling value
           tmpf(tmps.lims(2)),... % maximum sampling valued
           tmpf(tmps.priormu(j)),... % prior mean
           tmpf(tmps.priorstd(j)),... % prior std
           };
       k = k+1;
    end
end

end