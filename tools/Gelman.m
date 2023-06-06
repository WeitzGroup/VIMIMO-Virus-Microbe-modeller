% clear all;
% clc;

% read here
% https://bookdown.org/rdpeng/advstatcomp/monitoring-convergence.html

%% load data
load('./../results/local/SEIV10_00002_Dbeprt_1001/seed106L0_datasheet.mat');

addpath("/Users/rdey33/Downloads/VIMIMO/mcmcstat/mcmcstat");
addpath("/Users/rdey33/Downloads/VIMIMO/src");

%load('./../results/local/SEIV70_00000_Dbeprt_1001/seed339L0_datasheet.mat');


transient_id = 1;
chain_1 = [chain(transient_id:end,1:23) chain(transient_id:end,33:43)];
mean_chain_1 = mean(chain_1);

N = mcmcoptions.nsimu - transient_id;
M = 2;

load('./../results/local/SEIV10_00002_Dbeprt_1001/seed107L0_datasheet.mat');
%load('./../results/local/SEIV70_00000_Dbeprt_1001/seed338L0_datasheet.mat');

transient_id = 1;
%chain_2 = randn(1,2000)+0.1;
chain_2 = [chain(transient_id:end,1:23) chain(transient_id:end,33:43)];
mean_chain_2 = mean(chain_2);

grand_mean = (mean_chain_1 + mean_chain_2 )/2;

%chain_1 and chain_2 are the chains.

B = N/(M-1) * ((mean_chain_1 - grand_mean).^2 + (mean_chain_2 - grand_mean).^2) ;

v_1 = (std(chain_1)).^2 ;
v_2 = (std(chain_2)).^2 ;

W = (1/M) * (v_1 + v_2) ;



R =  ( (N-1)/N * W + (B/N) ) ./W;

%% plot bars


figure(1)
subplot(2,1,1)
b = bar(R,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [0 0.8 0];
end

for i = 6:14
b.CData(i,:) = [0 0 0.8];
end

for i = 15:23
b.CData(i,:) = [0.8 0 0];
end

for i=24:33
b.CData(i,:) = [0.7 0.7 0];
end



b.CData(34,:) = [0 0.2 0.2];
set(gca,'XTickLabel','');
hold on;
line([0.2, 35.8], [1.1, 1.1], 'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2);
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{GR}')

%% geweke
store = chainstats(chain_1);
R_geweke = store(:,5);

subplot(2,1,2)
b = bar(R_geweke,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [0 0.8 0];
end

for i = 6:14
b.CData(i,:) = [0 0 0.8];
end

for i = 15:23
b.CData(i,:) = [0.8 0 0];
end

for i=24:33
b.CData(i,:) = [0.7 0.7 0];
end



b.CData(34,:) = [0 0.2 0.2];
set(gca,'XTickLabel','');
hold on;
line([0.2, 38], [0.9, 0.9],'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2  );
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{geweke}')



%% load data
RMSE = [];
AIC=[];

load('./../SEIV70_00000_Dbeprt_1001/seed314L0_datasheet.mat');
RMSE(end+1) = loglikefun_normalized(median(chain(18000:end,:)),data,pars2,mcmcpars,model,0)




load('./../results/local/SEIV10_00000_bepr_1001/seed91L0_datasheet.mat');
pars2.NE = pars2.M.*10;
RMSE(end+1) = loglikefun_normalized(median(chain(9000:end,:)),data,pars2,mcmcpars,model,0)



name = {'SEIVD';'SEIV'};
subplot(3,1,3)

x= [1,2];
b = bar(x,RMSE,'FaceColor','flat');
set(gca,'XTickLabel',name);
ylabel('RMSE');


