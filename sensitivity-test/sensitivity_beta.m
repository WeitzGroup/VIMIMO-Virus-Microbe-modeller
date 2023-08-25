clear all;
clc;






%% add all files to path
addpath(genpath('./..'));


% a seed is set just to check the code
seed = 20011;




%load('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat','pars2','seed','pars_units','model','pars_labels','chain','mcmcpars','mcmcmodel');
load('./../results/SEIVD-diff-all-seed'+string(seed)+'.mat')
pars = pars2;
pars1 = pars2;

tvec = 0:0.05:15.75; % for better viz

dummy_beta_list = 317;

for i=1:length(dummy_beta_list)
theta = median(chain);
theta(7) = dummy_beta_list(i);
%theta(8) = 286;
error(i) = loglikefun(theta,data,pars2,mcmcpars,model,0);
i
end

error