%% an example parameter set + initial conditions
% nans have been arbitrarily set, either with random sampling or by taking
% averages; hopefully these are close to the 'true' values

clear;
load('data/parameters');

% deterministic
pars.beta(isnan(pars.beta)) = 5;
pars.tau(isnan(pars.tau)) = 1;
pars.eta(isnan(pars.eta)) = 1./pars.tau(isnan(pars.eta));
pars.a = eye(pars.NH);
pars.K = 2e7;
pars.q(isnan(pars.q)) = 0.5;
pars.epsilon(isnan(pars.epsilon)) = 1;
pars.S0(isnan(pars.S0)) = mean(pars.S0,'omitnan');
pars.V0(isnan(pars.V0)) = mean(pars.V0,'omitnan');

% random
rng(0);
pars.m = rand(pars.NV,1)*1e-3;
tmpid = find(isnan(pars.phi));
pars.phi(tmpid) = rand(length(tmpid),1)*1e-6;
clear tmpid

save('data/parameters_example','pars','pars_units','pars_labels');


