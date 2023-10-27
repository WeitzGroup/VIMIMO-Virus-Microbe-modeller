clc;
clear all;

addpath(genpath('./../..'))
load('./../combined_posteriors.mat');

load('./../../data/triplicate_data.mat');
linewidth = 2;

color_ofthe_fit = [1 0 0]*0.5;
color_ofthe_fill = [0.95 0 0];
transparency = 0.25;
tvec = 0:0.01:15.75; % for better viz
%% new parameters

pars2 = update_pars(pars1,pars_from_dist(chain_stored4(5001:end,:)),mcmcpars);
pars2.epsilon = ones(1,10);
pars2.prob = [0 0 0 0 0]';

   pars2.phi = 1.0e-07 *[         0    0.6000         0         0      0;
                             0.18    0.8000    0.2       0         0;
                                  0         0    0.6        0         0;
                                  0         0         0    0.7   0.1285;
                                  0         0         0    0.6   0.22];


pars2.tau =[0 3 0 0 0;
            1.7 2.7 2.3 0 0;
            0 0 2 0 0 ;
            0 0 0 1.8 4.7;
            0 0 0 2.3 2];
pars2.eta(pars2.tau>0) = 1./pars2.tau(pars2.tau>0);
pars2.eta

% r
pars2.r = [0.18,0.25,0.3,0.68,0.52]' ;


% beta

pars2.beta = [0  1.7231         0         0         0;
  200.7512  205.9496  100.1492         0         0;
         0         0   20.7017         0         0;
         0         0         0  522.0549  60.2599;
         0         0         0  485.1209  50.9918];



pars2.Dc = 5e6;
pars2.Dc2 = 6.13e6;
pars2.Dc3 =16e6;
pars2.Dc4 = 17.3e5;
pars2.Dc5 = 15.5e5;



% NE


pars2.NE = 200*pars2.M;



max_NE = round(max(max(pars2.NE)));
model = SEIVD_diff_NE_diff_debris_abs(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;
model.debris_inhib2 = 2;
model.debris_inhib3 = 2;
model.debris_inhib4 = 2;
model.debris_inhib5 = 2;

model.diff_beta = 0;
model.name = 'SEIVD-diffabs';







[t2,S_median,V_median,D_median,I_median,E_median] =  simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
