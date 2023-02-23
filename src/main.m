
%% setup and import
% set seed for reproducibility
rng(seed);

% import data
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

% modify latent periods to be longer
pars1.tau = pars1.tau*flags.tau_mult;
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);

% non-infectious fraction q to be uniform instead of a vector
%{
if flags.q_single_val==1
	pars.q = nan;
	pars1.q = 0.5;
end
%}

% which loglikelihood function to use
% default value is 0 (not normalized)
if flags.ssfun_normalized==0
	ssfun = @loglikefun;
elseif flags.ssfun_normalized==1
	ssfun = @loglikefun_normalized;
end

% which mcmc algorithm to use
% default value is 1 ('dram');
mcmcmethods = {'dram','am','dr', 'ram','mh'};
mcmcoptions.method = mcmcmethods{flags.mcmc_algorithm};
clear mcmcmethods;



%% mcmc run
mcmcpars = mcmcpars_setup(pars,pars1,include_pars,flags);
mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars1,mcmcpars,model,lambda); 
[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);


%% simulate timeseries for resulting parameter set
fprintf('simulating timeseries...\n');
%pars_from_dist = @(chain) mean(chain);
pars_from_dist = @(chain) median(chain);
pars2 = update_pars(pars1,pars_from_dist(chain(transient_id:end,:)),mcmcpars);
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set
[t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
clear tvec;


% compute error and envelope - very slow, do not run locally
if contains(dirstr,'cluster')

    %% compute error for each step in the chain
    fprintf('calculating error...\n');
    err.vals = [];
    [~, ~, err.id, err.labels, err.legends] = mcmcmodel.ssfun(chain(1,:),data);
    for i = 1:mcmcoptions.nsimu
        [~, err.vals(i,:)] = mcmcmodel.ssfun(chain(i,:),data);
    end
    clear i;


    %% compute ad hoc timeseries envelope for final parameter set
    fprintf('calculating timeseries envelope...\n');
    tsenv = compute_envelope(model,mcmcpars,pars2,chain,err,transient_id);

end
