
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
model.tau_find_out = 0;


include_pars = {'beta','phi','epsilon'};
if model.debris_inhib == 1
    include_pars{end+1} = 'Dc';
end

if model.lysis_reset == 1
    include_pars{end+1} = 'epsilon_reset';
end

if model.tau_find_out == 1
    include_pars{end+1} = 'eta';
end




flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 5;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.inference_script = 1;
flags.confidence_interval = 1;

%whether to sample error or not
flags.sample_error = 1;



seed = 14;
mcmcoptions.nsimu = 10000;
transient_id = 1;%round(mcmcoptions.nsimu * 0.5);
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

% modify latent periods to be longer
pars1.tau = pars1.tau*flags.tau_mult;
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);


% controlling settings for debris inhibition
if model.debris_inhib == 1
    pars1.Dc = 1e8;
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



%% confidence intervals
tic

if flags.inference_script == 1 && flags.confidence_interval == 1
    pars_without_nan = pars1;
    confidence_limit = 0.5;
    %transient_id_new = round(mcmcoptions.nsimu * 0.5);
    transient_id_new = transient_id;
    [S_min,S_max,V_min,V_max] = find_confidence_intervals(chain,transient_id_new,mcmcpars,confidence_limit,model, pars_without_nan);


end

time_taken = toc;

%% plotting the error functions and chain statistics
% new_transient_id = round(mcmcoptions.nsimu * 0.6);
% clear stored_error2
% for i=new_transient_id:mcmcoptions.nsimu
%     stored_error2(i-new_transient_id+1) = loglikefun_normalized(chain(i,:), data, pars, mcmcpars, model, lambda);
% end
% 
% 
% fprintf("The error is %f +/- %f \n",loglikefun_normalized(median(chain(new_transient_id:end,:)), data, pars, mcmcpars, model, lambda),std(stored_error2));

%% plots stats

% figure_error = plot((new_transient_id:mcmcoptions.nsimu),stored_error2);
% xlabel('steps');
% ylabel('error function');
% saveas(figure_error,strcat(filestr,'error_chain'),'png');
% hold off;

if mcmcoptions.nsimu > 2
    figure_mcmc2


else
    sprintf("You have not run the chain, so can't plot the chain statistics.");
end


save(strcat(filestr,'_datasheet'));

sprintf("Script executed successfully :)")
