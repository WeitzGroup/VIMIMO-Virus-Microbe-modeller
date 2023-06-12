clear all;
clc;

load('./../../results/local/SEIV70_00000_Dbeprt_1001/seed341L0_datasheet.mat');


addpath(genpath('/Users/rdey33/Downloads/VIMIMO'));

%% CI
flags.confidence_interval = 1;
[S_min,S_max,V_min,V_max,S_median,V_median] = find_confidence_interval_looped(chain,8000,mcmcpars,0.95,model, pars2);
save(strcat('SEIVD','_datasheet'));
