clear all;
clc;


%just some settings for the inference process:

% do not change
flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 1;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.tau_new = 0;
flags.broader_priors = 1;


% change to 1 if you want to see the scripts working,
% while running locally DO NOT turn ON the confidence_interval script --
% takes a long time.

flags.inference_script = 1;
flags.confidence_interval = 0;
flags.want_to_see_stats = 1;


%% add all files to path
addpath(genpath('./..'));

%% Settings for running the model

% 5 hosts 5 phages and 70ish number of boxes. Will change this later.
model = SEIVD_diff_NE_diff_debris(5,5,70);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;



% which of the variables to include in the inference process

include_pars = {'beta'};






% a seed is set just to check the code
seed = 20013;

% keeping it low so the code at least runs.
mcmcoptions.nsimu = 10000; 

% keeping the full chain, just for demo purposes of code review.
transient_id = 1;

%the regularizer in cost function was not used.
lambda = 0;

%% load the data, parameters etc.

%note: the datapath is already added, if it doesn't work (depending on your matlab version), just add the
%paths.
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

% fixing number of compartments: obtained from one-step-inference.
pars.NE = 10*(pars.M == 1); 
pars.NE(1,2) = 63;
pars.NE(2,1) = 75;
pars.NE(2,2) = 69;
pars.NE(2,3) = 70;
pars.NE(3,3) = 68;
pars.NE(4,4) = 75;
pars.NE(4,5) = 98;
pars.NE(5,4) = 87;
pars.NE(5,5) = 109;

pars1.NE = pars.NE; %pars1 was historically created to deal with cases where there was missing values, 
% do not worry about this for code-review now pars and pars1 are the same


% controlling settings for debris inhibition
if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    %pars1.Dc = 1e8;
    %pars1.Dc = 4389100;
    pars1.Dc = 3.9e6;
    pars_labels.Dc = "";
    pars_units.Dc = "1/ml";
    pars1.Dc2 = pars1.Dc;
    pars_labels.Dc2 = pars_labels.Dc;
    pars_units.Dc2 = pars_units.Dc;
end


% controlling settings for lysis reset (not used) 
if model.lysis_reset == 1
    pars1.epsilon_reset = 0.01;
    pars_labels.epsilon_reset = "";
    pars_units.epsilon_reset = "";
end

% finally fix the model with given number of boxes.
max_NE = round(max(max(pars.NE)));
model = SEIVD_diff_NE_diff_debris(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


% this was used to modify latent periods to be longer, is not used, ignore
% for code review - the multiplication factor was set to 1 anyway.
pars1.tau = pars1.tau*flags.tau_mult;

% a change of variable was done to test inference priors, not needed for code review
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);



%% SEIVD -- load good priors
dirstr = './../results';

% I wanted to create a method to check is file exists and not rewrite.
while exist('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat','file') == 2
    seed = seed + 1;
end
seed = seed - 1 ;

load('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat','pars2','seed','pars_units','pars_labels');
for i = 1:10
    pars = pars2;
    pars1 = pars2;
    clear pars2;
    if flags.inference_script == 1
        inference_script;
    end
    seed = seed+1;

    filestr = sprintf('%s/SEIVD-onlybeta-seed%d',dirstr,seed);
    save(filestr);  
end






%% finding confidence intervals

% WARNING -- DO NOT RUN THIS LOCALLY!! 
% IGNORE THIS FOR CODE REVIEW IF YOU LOVE YOUR TIME


% I have turned this off now, by flags.confidence_interval = 0


if flags.confidence_interval == 1
    load('./../res/inference_results/SEIVD_datasheet','chain'); %loading an actual chain
    transient_id_new = 1;
    confidence_interval = 0.95;
    [S_min,S_max,V_min,V_max] = find_confidence_interval_looped(chain,transient_id_new,mcmcpars,confidence_limit,model, pars2);
end

%% actual inference results after the pipeline.

% the inference process takes a long time, so we are just going to load the
% actual results after the inference.
%loading all the results.

load('./../res/inference_results/SEIVD_datasheet','S1','S2','S_max','S_median','S_min','V1','V2','V_max','V_median','V_min','chain','mcmcparam','mcmcpars','mcmcresults','t2');

%% some initial inference statistics 
% this part was hardly shown in the paper
% you may get an error if you run this as the folder does not exist.

if flags.want_to_see_stats == 1

% create save directory
[dirstr,flags] = get_dirstr('local',model,include_pars,flags);
filestr = sprintf('%s/seed%dL%.2g',dirstr,seed,max(log10(lambda),0));

if mcmcoptions.nsimu > 2
    figure_mcmc2
else
    sprintf("You have not run the chain, so can't plot the chain statistics.");
end

end
