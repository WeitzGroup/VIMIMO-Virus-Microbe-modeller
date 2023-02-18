
clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%mcmcoptions.waitbar = 0; % turn off mcmc status bar

% specify options for this run
model = SEIV(5,5,10);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 0;
include_pars = {'beta','phi','epsilon'};
flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 5;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
seed = 0;
mcmcoptions.nsimu = 200;
transient_id = 1;
lambda = 0;

% create save directory
[dirstr,flags] = get_dirstr('local',model,include_pars,flags);
filestr = sprintf('%s/seed%dL%.2g',dirstr,seed,max(log10(lambda),0));



% run main mcmc script
main;
if exist(sprintf('%s.mat',filestr),'file')
    fprintf('overwriting existing file...\n');
end
save(filestr);

% only generate mcmc figures if mcmc chain was run
if mcmcoptions.nsimu > 2
    figures_mcmc
else
    fig = plot_timeseries2(model,t1,S1,V1); % original (grey)
    print(fig,sprintf('%s_timeseries2',filestr),'-dpng');
end
fprintf('done!\n\n');
