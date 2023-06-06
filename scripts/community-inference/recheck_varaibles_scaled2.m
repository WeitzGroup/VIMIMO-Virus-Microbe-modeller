clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
load('seed307L0_datasheet.mat');


 tvec = 0:0.05:15.75;


%% inference again

mcmcoptions.nsimu = 100;

for i=1:1
    transient_id = mcmcoptions.nsimu *0.9;

pars2.NE = [ 0    42     0     0     0;
    39    37    45     0     0;
     0     0    38     0     0;
     0     0     0    43    52;
     0     0     0    47    50];

pars.NE = pars2.NE;
pars1.NE = pars2.NE;

max_NE = round(max(max(pars2.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


mcmcpars = mcmcpars_setup(pars2,pars2,include_pars,flags,model);
mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars2,mcmcpars,model,lambda); 


[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);
pars_from_dist = @(chain) median(chain);
pars2 = update_pars(pars2,pars_from_dist(chain(transient_id:end,:)),mcmcpars);



tvec = 0:0.05:15.75; % for better viz
[t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set



filestr = sprintf('%s/seed%dL%.2g',dirstr,seed+1001,max(log10(lambda),0));
figure_mcmc2

save(strcat(filestr,'_datasheet'));

end


