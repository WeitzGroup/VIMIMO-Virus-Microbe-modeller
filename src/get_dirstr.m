function [dirstr, flags] = get_dirstr(local_or_cluster,model,include_pars,flags)

modelstr = model.name;
odestr = model.odestr();
parstr = sort(cellfun(@(str) str(1),include_pars));

% old flags that are currently deactivated: 
%   q_single_val    (main.m)
%   uniform_priors  (mcmcpars_setup.m)
%   phi_uniform     (mcmcpars_setup.m)

% flags, set default values
flagopts = {'phi_entire_matrix','ssfun_normalized','tau_mult','mcmc_algorithm'};
flagdefaults = [0 0 1 1];
[~,tmpid] = sort(flagopts);
flagopts = flagopts(tmpid);
flagdefaults = flagdefaults(tmpid);

% create flagstr and modify flags struct if any values were not set
flagstr = [];
for i = 1:length(flagopts)
    if ~any(strcmp(flagopts{i},fieldnames(flags))) % flag was not set
        flags.(flagopts{i}) = flagdefaults(i);
    end
    flagstr = sprintf('%s%d',flagstr,flags.(flagopts{i})); % create string for dirstr
end

% directory setup
dirstr = sprintf('results/%s/%s_%s_%s_%s',local_or_cluster,modelstr,odestr,parstr,flagstr);
if ~isfolder(dirstr)
    mkdir(dirstr)
end

end