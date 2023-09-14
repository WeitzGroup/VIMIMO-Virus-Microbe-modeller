clc;
clear all;
tic

addpath(genpath('./../..'))
load('./../combined_posteriors.mat');
load('./../../data/triplicate_data.mat');


tvec = 0:0.05:15.75; % for better viz
%% new parameters

pars2 = update_pars(pars1,pars_from_dist(chain_stored4(5001:end,:)),mcmcpars);
pars2.epsilon = ones(1,10); % feature turned off
pars2.prob = [0 0 0 0 0]'; % feature turned off

pars2.phi = 1.0e-07 *[         0    0.4000         0         0      0;
                             0.1979    0.8000    0.4000         0         0;
                                  0         0    0.4000         0         0;
                                  0         0         0    0.6   0.1285;
                                  0         0         0    0.6   0.22];


pars2.tau =[0 2.8 0 0 0;
            1.8 2.8 1.9 0 0;
            0 0 1.6 0 0 ;
            0 0 0 1.8 2.7;
            0 0 0 2.3 2.5];
pars2.eta(pars2.tau>0) = 1./pars2.tau(pars2.tau>0);

% r
pars2.r = [0.18,0.25,0.3,0.68,0.52]' ;


% beta

pars2.beta = [0         108      0         0     0;
              260       155      10        0     0;
                0         0     100        0    0;
                0         0       0       522   60;
                0         0       0       485   50];




pars2.Dc = 10e6;
pars2.Dc2 = 6.0e6;
pars2.Dc3 = 10e6;
pars2.Dc4 = 19.3e5;
pars2.Dc5 = 16.4e5;



% NE

pars2.NE = [     0    50     0     0     0;
                50    50    50     0     0;
                0     0    50     0     0;
                0     0     0    50    100;
                0     0     0    50   100];




max_NE = round(max(max(pars2.NE)));
model = SEIVD_diff_NE_diff_debris_abs(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;
model.diff_beta = 0;


model.name = 'SEIVD-diffabs';

[t2,S_median,V_median,D_median,I_median,E_median] =  simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set


%% inference part

mcmcoptions.nsimu = 10000;
transient_id = 1;
lambda = 0;
include_pars = {'r','beta','phi','tau','Dc','Dc2','Dc3','Dc4','Dc5'};

mcmcoptions.method  = 'dram';
mcmcpars = mcmcpars_setup_new(pars2,pars2,include_pars,flags,model);
mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars2,mcmcpars,model,lambda); 
[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);


pars_afterinf = update_pars(pars2,median(chain(transient_id:end, :)),mcmcpars);
[t2,S_after,V_after,D_after,I_after,E_after] =  simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set

