%% This version runs through the good runs of the model 
%I am generating a lot of such chains.

clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%mcmcoptions.waitbar = 0; % turn off mcmc status bar

%% Settings for running the model
% specify options for this run

model = SEIV_diff_NE(5,5,70);

include_pars = {'r','beta','phi','epsilon','tau'};
if model.debris_inhib == (1 || 2 || 3)
    include_pars{end+1} = 'Dc';
end

if model.lysis_reset == 1
    include_pars{end+1} = 'epsilon_reset';
end




flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 4;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.inference_script = 1;
flags.confidence_interval = 0;
flags.tau_new = 0;



% import data
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans


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

pars1.NE = pars.NE;
max_NE = round(max(max(pars.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 0;


% modify latent periods to be longer
pars1.tau = pars1.tau*flags.tau_mult;
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);


% controlling settings for debris inhibition
if model.debris_inhib == (1 || 2 || 3)
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


tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

%% plots

figure(1)

for i=1:model.NH
    subplot(2,5,i)
plot(data.xdata,data.ydata(:,i),'o',MarkerEdgeColor='none',MarkerFaceColor=[51 102 153]./255);hold on;plot(t1,S1(:,i),'--',LineWidth=2,Color=[0.1 0.1 0.1].*1); %microbes
axis square
set(gca,'Yscale','log'); ylim([1e5 1e8])
%title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    %' (N_E=10)'])
end


for j=1:model.NV
    subplot(2,5,j+5)
plot(data.xdata,data.ydata(:,i+5),'o',MarkerEdgeColor='none',MarkerFaceColor=[51 102 153]./255);hold on;plot(t1,V1(:,i),'--',LineWidth=2,Color=[0.1 0.1 0.1].*1); %virus
axis square
set(gca,'Yscale','log');
%title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end



%% error

if flags.ssfun_normalized==0
	ssfun = @loglikefun;
elseif flags.ssfun_normalized==1
	ssfun = @loglikefun_normalized;
end


mcmcpars = mcmcpars_setup(pars,pars1,include_pars,flags,model);
mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars1,mcmcpars,model,lambda); 

ssfun(median(chain(19000:end,:)),data,pars1,mcmcpars,model)

