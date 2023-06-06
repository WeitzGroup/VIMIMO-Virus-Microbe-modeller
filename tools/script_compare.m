clear all;
clc;

% read here
% https://bookdown.org/rdpeng/advstatcomp/monitoring-convergence.html

%% load data
RMSE = [];
AIC=[];

load('./../SEIV70_00000_Dbeprt_1001/seed314L0_datasheet.mat');
RMSE(end+1) = loglikefun_normalized(median(chain(18000:end,:)),data,pars2,mcmcpars,model,0)

load('./../SEIV70_00000_Dbeprt_1001/seed1303L0_datasheet.mat');
RMSE(end+1) = loglikefun_normalized(median(chain(18000:end,:)),data,pars2,mcmcpars,model,0)


load('./../results/local/SEIV10_00002_Dbeprt_1001/seed106L0_datasheet.mat');
pars2.NE = pars2.M.*10;
RMSE(end+1) = loglikefun_normalized(median(chain(9000:end,:)),data,pars2,mcmcpars,model,0)


load('./../results/local/SEIV10_00000_bepr_1001/seed91L0_datasheet.mat');
pars2.NE = pars2.M.*10;
RMSE(end+1) = loglikefun_normalized(median(chain(9000:end,:)),data,pars2,mcmcpars,model,0)


%%

name = {'unscaled';'CV scaled by 1.4';'CV scaled by 3';'no debris'};
x= [1,2,3,4];
b = bar(x,RMSE,'FaceColor','flat');
set(gca,'XTickLabel',name);
ylabel('RMSE');

set(gca,'FontSize',20);
