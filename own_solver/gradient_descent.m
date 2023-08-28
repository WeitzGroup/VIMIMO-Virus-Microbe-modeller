clear all;
clc;


%% add all files to path
addpath(genpath('./..'));

%% load file all param

% % a seed is set just to check the code
% seed = 20011;
% 
% load('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat')
% pars = pars2;
% pars1 = pars2;
% 
% tvec = 0:0.05:15.75; % for better viz
% theta_initial = median(chain);
% initial_error = ssfun(median(chain),data,pars2,mcmcpars,model);
% 
% theta = theta_initial;
% theta(1:5) = pars2.r;
% theta(6:14) = pars2.beta(pars2.beta>0);
% theta(24:33) = pars2.epsilon;
% theta(34:42) = pars2.tau(pars2.tau>0) ;


%% load file only beta

load('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat')
pars = pars2;
pars1 = pars2;

tvec = 0:0.05:15.75; % for better viz
%theta_initial = median(chain);
%initial_error = ssfun(median(chain),data,pars2,mcmcpars,model);


theta(1:5) = pars2.r;
theta(6:14) = pars2.beta(pars2.beta>0);
theta(15:23) = pars2.phi(pars2.phi >0);
theta(24:33) = pars2.epsilon;
theta(34:42) = pars2.tau(pars2.tau>0) ;
theta()