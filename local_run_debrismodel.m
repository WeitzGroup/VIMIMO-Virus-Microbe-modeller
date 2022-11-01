
clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%mcmcoptions.waitbar = 0; % turn off mcmc status bar


%% Settings for running the model
% specify options for this run
model = SEIV(5,5,10);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 1;


if model.debris_inhib == 0
include_pars = {'beta','phi','epsilon'};
elseif model.debris_inhib == 1
include_pars = {'beta','phi','epsilon','Dc'};
end

flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 5;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.inference_script = 1;

seed = 0;
mcmcoptions.nsimu = 200;
transient_id = 1;
lambda = 0;


%% Load the parameters
rng(seed);

% import data
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

% modify latent periods to be longer
pars1.tau = pars1.tau*flags.tau_mult;
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);


% controlling settings for debris inhibition
if model.debris_inhib == 1
    pars1.Dc = 1e8;
end

tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

figure(1)
for i=1:model.NH
plot(data.xdata,data.ydata(:,i),'*');hold on;plot(t1,S1(:,i),'-',LineWidth=2); %microbes
xlabel('Time (hours)');ylabel('Host (cells/ml)');set(gca,'Yscale','log'); ylim([1e5 1e8])
title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    ' (N_E=10)'])
end

figure(2)
for i=1:model.NV
plot(data.xdata,data.ydata(:,i+5),'*');hold on;plot(t1,V1(:,i),'-',LineWidth=2); %virus
xlabel('Time (hours)');ylabel('Phage (cells/ml)');set(gca,'Yscale','log');
title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end

if flags.inference_script == 1
    inference_script;
end

%% plotting the error functions and chain statistics


