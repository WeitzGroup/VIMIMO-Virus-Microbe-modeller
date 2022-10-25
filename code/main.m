
%% setup and import
% set seed for reproducibility
rng(seed);

%add to path
addpath('/Users/rdey33/Documents/MATLAB/mcmcstat-master');
addpath('/Users/rdey33/Downloads/biooceans/pilot_experiment_pace2/data');
addpath('/Users/rdey33/Downloads/biooceans/pilot_experiment_pace2/code/models');

% import data
current_dir = pwd;
load(current_dir+"/../data/qpcr",'data'); % qpcr data
load(current_dir+"/../data/parameters_example",'pars'); % parameters without nans
pars1 = pars;
load(current_dir+"/../data/parameters"); % true parameter set with nans  %loads to pars


% __by__raunak
flags.tau_mult = 1;
flags.ssfun_normalized = 1;
flags.mcmc_algorithm = 1;
flags.phi_entire_matrix=1;



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

%% Raunak demo pars
% to be deleted
% pars2 = pars1;
% pars2.r = [0.3687,0.286,0.32,0.256,0.282]';


%% mcmc run
mcmcpars = mcmcpars_setup(pars,pars1,flags);
mcmcparam = mcmcpars2param(mcmcpars);

model = SIV(5,5);
lambda = 0; 

mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars1,mcmcpars,model,lambda);  
mcmcmodel.N = length(data.xdata);  % total number of observations 


mcmcoptions.nsimu = 5000;

[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);

chainstats(chain,mcmcresults)

%% simulate timeseries for resulting parameter set
fprintf('simulating timeseries...\n');
%pars_from_dist = @(chain) mean(chain);
pars_from_dist = @(chain) median(chain);

transient_id=1000; % so 1001 to 10k is used
pars2 = update_pars(pars1,pars_from_dist(chain(transient_id:end,:)),mcmcpars);
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set
[t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
clear tvec;

%% plotting section
figure(5)
for i=1:5
plot(data.xdata,data.ydata(:,i),'-');hold on;plot(t2,S2(:,i),'.'); %microbes
end

figure(6)
for i=1:5
plot(data.xdata,data.ydata(:,i+5),'-');hold on;plot(t2,V2(:,i),'.'); %virus
end


%%%%%%%%% ____ error thing starts here ____ %%%%%%%%%

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
