clear all;
clc;


%% add all files to path
addpath(genpath('./..'));



%% load file only beta

load('./../corrected2/revised50040.mat')
pars = pars2;
pars1 = pars2;

initial_error = error_from_pars(pars2,data,model);
tvec = 0:0.05:15.75; % for better viz

%initialization of gaussian priors.
r_sd = 0.00; %for 5 parameters
beta_sd = 20; % for 9 parameters
phi_sd = 1*1e-10; %for 9 parameters;
epsilon_sd = 0; %will not sample this.
tau_sd = 0.6; % will increase later -- after truncating.

chain = chain - mean(chain) + chain(:,1);
% for beta

for i = 1:9

chain_above = chain(100:1000,:);
chain_above(:,i) = chain_above(:,i) + 30;
chain_below = chain(100:1000,:);
chain_below(:,i) = chain_below(:,i) - 30;




pars_above = update_pars(pars2,median(chain_above) ,mcmcpars);
err_above = error_from_pars(pars_above,data,model);

pars_below =  update_pars(pars2,median(chain_below),mcmcpars);
err_below = error_from_pars(pars_below, data,model );

err_total(i) = abs(err_below + err_above);
i
end

% for phi

for i = 10:18

chain_above = chain(100:1000,:);
chain_above(:,i) = chain_above(:,i) + 0.5;
chain_below = chain(100:1000,:);
chain_below(:,i) = chain_below(:,i) - 0.5;




pars_above = update_pars(pars2,median(chain_above) ,mcmcpars);
err_above = error_from_pars(pars_above,data,model);

pars_below =  update_pars(pars2,median(chain_below),mcmcpars);
err_below = error_from_pars(pars_below, data,model );

err_total(i) = abs(err_below + err_above);
i
end

% for tau


for i = 19:27

chain_above = chain(100:1000,:);
chain_above(:,i) = chain_above(:,i) + 2;
chain_below = chain(100:1000,:);
chain_below(:,i) = chain_below(:,i) - 1;




pars_above = update_pars(pars2,median(chain_above) ,mcmcpars);
err_above = error_from_pars(pars_above,data,model);

pars_below =  update_pars(pars2,median(chain_below),mcmcpars);
err_below = error_from_pars(pars_below, data,model );

err_total(i) = abs(err_below + err_above);
i
end

