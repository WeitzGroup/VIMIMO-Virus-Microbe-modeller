clear all;
clc;

%just some settings 

% do not change
flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 1;
flags.tau_new = 0;


%% add all files to path
addpath(genpath('./..'));

%% Settings for running the model

% 5 hosts 5 phages and 70ish number of boxes. Will change this later.
model = SEIVD_diff_NE_diff_debris(10,10,70);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;




load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

% fixing number of compartments: obtained from one-step-inference.
pars.NE = 10*(pars.M == 1); 


pars1.NE = pars.NE; %pars1 was historically created to deal with cases where there was missing values, 
% do not worry about this for code-review now pars and pars1 are the same


% controlling settings for debris inhibition
if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    pars1.Dc = 7e6;
elseif model.debris_inhib == 0
    pars1.Dc = 15e20;
end

pars1.Dc2 = pars1.Dc;
pars_labels.Dc2 = pars_labels.Dc;
pars_units.Dc2 = pars_units.Dc;
pars_labels.Dc = "";
pars_units.Dc = "1/ml";



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

tvec = 0:0.05:5; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

figure(1)
for i=1:model.NH
plot(t1,S1(:,i),'-',LineWidth=2); hold on;%microbes
xlabel('Time (hours)');ylabel('Host (cells/ml)');set(gca,'Yscale','log');
%title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    %' (N_E=10)'])
end

figure(2)
for i=1:model.NV
plot(t1,V1(:,i),'-',LineWidth=2); hold on; %virus
xlabel('Time (hours)');ylabel('Phage (cells/ml)');set(gca,'Yscale','log');
%title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end


