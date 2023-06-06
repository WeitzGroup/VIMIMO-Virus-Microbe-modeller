%% This version runs through the good runs of the model 
%I am generating a lot of such chains.

clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%mcmcoptions.waitbar = 0; % turn off mcmc status bar


%% Settings for running the model
% specify options for this run

model = SEIV_diff_NE(5,5,70);

include_pars = {'r','beta','phi','epsilon','tau'};
if model.debris_inhib == 1 || 2 || 3
    include_pars{end+1} = 'Dc';
end

if model.lysis_reset == 1
    include_pars{end+1} = 'epsilon_reset';
end




flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 1;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.inference_script = 1;
flags.confidence_interval = 0;
flags.tau_new = 0;

seed = 503;
mcmcoptions.nsimu = 10000;
transient_id = 1;
lambda = 0;


% create save directory
[dirstr,flags] = get_dirstr('local',model,include_pars,flags);
filestr = sprintf('%s/seed%dL%.2g',dirstr,seed,max(log10(lambda),0));


%% Load the parameters
rng(seed);

% import data
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

% create NE values
pars.NE = 10*(pars.M == 1);
pars.NE(1,2) = 98;
pars.NE(2,1) = 75;
pars.NE(2,2) = 68;
pars.NE(2,3) = 93;
pars.NE(3,3) = 71;
pars.NE(4,4) = 83;
pars.NE(4,5) = 104;
pars.NE(5,4) = 90;
pars.NE(5,5) = 101;


%subpar -- old one-from one step
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


 %pars.NE = round(pars.NE./5);


pars1.NE = pars.NE;



max_NE = round(max(max(pars.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


% modify latent periods to be longer
pars1.tau = pars1.tau*flags.tau_mult;
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);


% controlling settings for debris inhibition
if model.debris_inhib == 1 || 2 || 3
    %pars1.Dc = 1e8;
    %pars1.Dc = 4389100;
    pars1.Dc = 3.9e6;
    pars_labels.Dc = "";
    pars_units.Dc = "1/ml";
end


% controlling 
if model.lysis_reset == 1
    pars1.epsilon_reset = 0.01;
    pars_labels.epsilon_reset = "";
    pars_units.epsilon_reset = "";
end




pars1.beta = [0 332.5199 0 0 0; 285.8763  389.8026  285.1307 0 0; 0 0 81.5296 0 0; 0 0 0 172.3908 115.6997; 0 0 0 421.0652  84.0754];
pars1.phi = 1.0e-06 *[0 0.0779 0 0 0; 0.1471 0.0590 0.0526 0 0; 0 0 0.0651 0 0; 0 0 0 0.0014 0.0260; 0 0 0 0.0123 0.0012];
pars1.epsilon = [1.4320    0.7033    1.0714    1.0794    0.8978    1.2552    1.1261    1.3579    1.3952    1.0795];
  pars1.r = [ 0.1075;
    0.2900;
    0.0485;
    0.4375;
    0.4088];


pars1.eta = [ 0    0.2101         0         0         0;
    0.2122    0.1954    0.1917         0         0;
         0         0    0.2437         0         0;
         0         0         0    0.1163    0.2693;
         0         0         0    0.5219    0.0525];



pars1.tau(pars1.tau>0) = 1./pars1.eta(pars1.tau>0);


pars.beta = pars1.beta;
pars.phi = pars1.phi;
pars.epsilon = pars1.epsilon;
pars.r = pars1.r;
pars.eta = pars1.eta;
pars.tau = pars1.tau;
pars.Dc = pars1.Dc;


tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

figure(1)
for i=1:model.NH
plot(data.xdata,data.ydata(:,i),'*');hold on;plot(t1,S1(:,i),'-',LineWidth=2); %microbes
xlabel('Time (hours)');ylabel('Host (cells/ml)');set(gca,'Yscale','log'); ylim([1e5 1e8])
%title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    %' (N_E=10)'])
end

figure(2)
for i=1:model.NV
plot(data.xdata,data.ydata(:,i+5),'*');hold on;plot(t1,V1(:,i),'-',LineWidth=2); %virus
xlabel('Time (hours)');ylabel('Phage (cells/ml)');set(gca,'Yscale','log');
%title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end

%% inference

if flags.inference_script == 1
    inference_script;
end


%% plots stats


save(strcat(filestr,'_datasheet'));


if mcmcoptions.nsimu > 2
    figure_mcmc2
else
    sprintf("You have not run the chain, so can't plot the chain statistics.");
end




sprintf("Script executed successfully :)")
